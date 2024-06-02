use std::{borrow::Cow, io};

use serde::{Deserialize, Serialize};

use crate::Shell;

#[derive(Debug, Deserialize, Serialize)]
#[serde(untagged)]
enum Value {
    Same(String),
    Different {
        fish: String,
        zsh: String,
        bash: String,
    },
}

#[derive(Debug, Deserialize, Serialize)]
pub struct Entry {
    name: String,
    value: Value,
    expand: Option<Vec<Value>>,
    abbr: Option<bool>,
}

pub fn escape(s: Cow<'_, str>, qch: char) -> Cow<'_, str> {
    fn do_escape(s: &str, qch: char) -> String {
        let mut out = String::with_capacity(s.len() * 2);
        for ch in s.chars() {
            match ch {
                x | x @ '\\' if x == qch => out.push('\\'),
                _ => {}
            }
            out.push(ch)
        }
        out
    }
    match s {
        Cow::Borrowed(s) if !s.contains('\'') => Cow::Borrowed(s),
        Cow::Owned(ref s) => Cow::Owned(do_escape(s, qch)),
        Cow::Borrowed(s) => Cow::Owned(do_escape(s, qch)),
    }
}

impl Entry {
    #[allow(dead_code)]
    fn new(aliased: String, value: String, expand: Option<Vec<Value>>) -> Self {
        Self {
            name: aliased,
            value: Value::Same(value),
            expand,
            abbr: None,
        }
    }

    pub fn sh_value(&self, shell: Shell) -> Cow<'_, str> {
        let value = match &self.value {
            Value::Same(s) => s,
            Value::Different { fish, zsh, bash } => match shell {
                Shell::Fish => fish,
                Shell::Zsh => zsh,
                Shell::Bash => bash,
            },
        }
        .as_str();

        let value = if let Some(expand) = &self.expand {
            let mut value = value.to_owned();
            for val in expand {
                let val = match &val {
                    Value::Same(s) => s,
                    Value::Different { fish, zsh, bash } => match shell {
                        Shell::Fish => fish,
                        Shell::Zsh => zsh,
                        Shell::Bash => bash,
                    },
                };
                value = value.replacen("{}", val, 1);
            }
            Cow::Owned(value)
        } else {
            Cow::Borrowed(value)
        };

        value
    }

    pub fn to_shell_alias(&self, w: &mut impl io::Write, shell: Shell) -> io::Result<()> {
        let value = self.sh_value(shell);

        let value = escape(value, '\'');
        match shell {
            Shell::Fish => {
                if self.abbr == Some(true) {
                    writeln!(w, "abbr -a -- {} '{}'", self.name, value)?
                } else {
                    writeln!(w, "alias {} '{}'", self.name, value)?
                }
            }
            Shell::Bash | Shell::Zsh => writeln!(w, "alias {}='{}'", self.name, value)?,
        };

        Ok(())
    }

    pub fn to_shell_environ(&self, w: &mut impl io::Write, shell: Shell) -> io::Result<()> {
        let value = self.sh_value(shell);
        let value = escape(value, '"');
        match shell {
            Shell::Fish => writeln!(w, "set -gx {} \"{}\"", self.name, value)?,
            Shell::Bash | Shell::Zsh => writeln!(w, "export {}=\"{}\"", self.name, value)?,
        };
        Ok(())
    }
}
