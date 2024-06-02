use std::io;

use crate::{entry::Entry, Shell};
use serde::{Deserialize, Serialize};

#[derive(Debug, Deserialize, Serialize)]
pub struct Aliases {
    aliases: Vec<Entry>,
}

impl Aliases {
    pub fn to_shell_aliases(&self, w: &mut impl io::Write, shell: Shell) -> io::Result<()> {
        for alias in &self.aliases {
            alias.to_shell_alias(w, shell)?;
        }

        Ok(())
    }
}
