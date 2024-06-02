use std::{
    collections::HashSet,
    env::current_dir,
    path::{Path, PathBuf},
    sync::OnceLock,
};

use clap::Parser;
use glob::glob_with;

#[derive(Parser)]
#[command(author, version, about, long_about = None)]
struct Cli {
    path: Option<PathBuf>,

    /// Print out all the patterns that match a root project and exit
    #[arg(short, long)]
    print_patterns: bool,

    /// Add an additional pattern to the default list.
    /// Supports glob but make sure to quote them to not have your shell expand the glob.
    ///
    /// `-a '*.rs'` matches every file with a `.rs` extension
    #[arg(short, long)]
    additional_pattern: Vec<String>,
}

#[derive(Debug)]
struct ParentDirs {
    current: Option<PathBuf>,
}

impl ParentDirs {
    pub fn new(cwd: PathBuf) -> Self {
        ParentDirs { current: Some(cwd) }
    }
}

impl Iterator for ParentDirs {
    type Item = PathBuf;
    fn next(&mut self) -> Option<Self::Item> {
        if let Some(cur) = &mut self.current {
            let out = cur.to_owned();

            if !cur.pop() {
                self.current = None;
            }

            Some(out)
        } else {
            None
        }
    }
}

static PATTERNS: OnceLock<HashSet<String>> = OnceLock::new();

fn looks_like_root(path: &Path) -> bool {
    let options = glob::MatchOptions {
        case_sensitive: true,
        require_literal_separator: true,
        require_literal_leading_dot: false,
    };
    for pattern in PATTERNS.get().into_iter().flatten() {
        let mut p = path.to_owned();
        p.push(pattern);
        let Some(p) = p.to_str() else {
            continue;
        };
        if glob_with(p, options).into_iter().flatten().next().is_some() {
            return true;
        }
    }

    false
}

fn main() -> std::io::Result<()> {
    let cli = Cli::parse();

    let mut patterns = HashSet::from(
        [
            "Cargo.toml",
            "dune",
            "package.json",
            ".git",
            ".gitignore",
            "Cargo.lock",
            "node_modules",
            "*.opam",
            "dune-project",
        ]
        .map(ToOwned::to_owned),
    );
    for pat in cli.additional_pattern {
        patterns.insert(pat);
    }
    PATTERNS.set(patterns).expect("couldnt init PATTERNS");

    if cli.print_patterns {
        for p in PATTERNS.get().into_iter().flatten() {
            println!("{p}");
        }
        return Ok(());
    }

    let path = cli.path.map(Ok).unwrap_or_else(current_dir)?;
    let path = path.canonicalize()?;

    let root = ParentDirs::new(path.clone())
        .find(|path| looks_like_root(path))
        .unwrap_or(path);

    let project_name = root
        .file_name()
        .and_then(|name| name.to_str())
        .unwrap_or(":root");
    println!("{project_name}");

    Ok(())
}
