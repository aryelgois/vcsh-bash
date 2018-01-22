# Executed by the command interpreter for login shells

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package
#umask 022

# If running bash
if [ -n "$BASH_VERSION" ]; then
    # Include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
        . "$HOME/.bashrc"
    fi
fi

# Set PATH so it includes user's private bin directories
PATH="$HOME/bin:$HOME/.local/bin:$PATH"
