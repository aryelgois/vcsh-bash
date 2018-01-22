# Executed by bash(1) when login shell exits

# When leaving the console, clear the screen to increase privacy
if [ "$SHLVL" = 1 ]; then
    if hash tput 2> /dev/null; then
        tput reset
    elif [ -x /usr/bin/clear_console ]; then
        /usr/bin/clear_console -q
    fi
    clear
fi
