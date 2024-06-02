use std::io;

use crate::{entry::Entry, Shell};
use serde::{Deserialize, Serialize};
#[derive(Debug, Deserialize, Serialize)]
pub struct Envs {
    env: Vec<Entry>,
}

impl Envs {
    pub fn to_shell_environment(&self, w: &mut impl io::Write, shell: Shell) -> io::Result<()> {
        for environ in &self.env {
            environ.to_shell_environ(w, shell)?;
        }
        Ok(())
    }
}
