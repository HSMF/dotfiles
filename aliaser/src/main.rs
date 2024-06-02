use std::{fs::read_to_string, io, path::PathBuf};

use clap::{Command, CommandFactory, Parser, Subcommand, ValueEnum, ValueHint};
use clap_complete::{generate, Generator};
mod alias;
mod entry;
mod envs;

#[derive(Debug, Parser)]
#[clap(version, about, author, long_about = None)]
struct Opts {
    /// specify the shell
    #[clap(long, short, value_enum, value_name = "SHELL")]
    shell: Shell,

    #[clap(subcommand)]
    command: Commands,
}

#[derive(Debug, ValueEnum, Clone, Copy)]
pub enum Shell {
    Bash,
    Zsh,
    Fish,
}

impl Shell {
    fn to_complete_shell(self) -> clap_complete::Shell {
        use clap_complete::Shell as CShell;
        match self {
            Shell::Bash => CShell::Bash,
            Shell::Zsh => CShell::Zsh,
            Shell::Fish => CShell::Fish,
        }
    }
}

#[derive(Debug, Subcommand)]
enum Commands {
    /// generate aliases for SHELL
    Alias {
        /// TOML file that contains the alias declarations
        #[clap(value_hint = ValueHint::FilePath, value_name = "FILE")]
        file: PathBuf,
    },

    /// generate environment variable declarations for SHELL
    Env {
        /// TOML file that contains the environment variable declarations
        #[clap(value_hint = ValueHint::FilePath, value_name = "FILE")]
        path: PathBuf,
    },

    /// Generate shell completions for SHELL
    Complete,

    /// Sets the PATH variable
    Path {
        /// plaintext file that contains the entries for the PATH variable, one entry per line
        #[clap(value_hint = ValueHint::FilePath, value_name = "FILE")]
        file: PathBuf,

        /// additional path variables, not set in FILE
        #[clap(long, short)]
        additional: Vec<String>,
    },
}

fn print_completions<G: Generator>(gen: G, cmd: &mut Command) {
    generate(gen, cmd, cmd.get_name().to_string(), &mut io::stdout());
}

fn main() -> io::Result<()> {
    let opts = Opts::parse();

    match opts.command {
        Commands::Alias { file } => {
            let aliases = read_to_string(file)?;
            let aliases: alias::Aliases = toml::from_str(&aliases)
                .map_err(|e| {
                    eprintln!("{}", e.message());
                    e
                })
                .unwrap();

            let mut stdout = io::stdout().lock();
            aliases.to_shell_aliases(&mut stdout, opts.shell)?;
        }

        Commands::Env { path } => {
            let environments = read_to_string(path)?;
            let environments: envs::Envs = toml::from_str(&environments)
                .map_err(|e| {
                    eprintln!("{}", e.message());
                    e
                })
                .unwrap();

            let mut stdout = io::stdout().lock();
            environments.to_shell_environment(&mut stdout, opts.shell)?;
        }

        Commands::Complete => {
            let mut cmd = Opts::command();
            let shell = opts.shell.to_complete_shell();
            print_completions(shell, &mut cmd);
        }

        Commands::Path { file, additional } => {
            let path_vars = read_to_string(file)?;
            let mut lines = path_vars
                .lines()
                .chain(additional.iter().map(String::as_str))
                .filter(|l| !l.is_empty())
                .filter(|l| !l.starts_with('#'));
            let mut path = String::with_capacity(path_vars.len());
            path += lines.next().unwrap_or("");
            for p in lines {
                path.push(':');
                path.push_str(p);
            }
            println!("{path}");
        }
    }

    Ok(())
}
