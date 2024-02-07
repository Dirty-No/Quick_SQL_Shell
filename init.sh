#!/bin/bash -x

# Export environment variables to a file for persistence
export > ~/.bashrc

start_webshell() {
    ROOT_PATH="$1"
    PORT="$2"
    COMMAND="$3"

    # Butterfly seems to be buggy when passing quotes and stuff to --cmd, so the best way to bypass this issue
    # is to write the command in a temporary shell script in execute is with bash.
    CMD_FILE=$(mktemp)
    echo "$3" > "$CMD_FILE"

    # The security flag is required to allow exposing butterfly without password and SSL (which you should handle with a reverse-proxy)
    butterfly.server.py \
        --cmd="bash -il $CMD_FILE" \
        --uri-root-path="$ROOT_PATH" \
        --host=0.0.0.0 \
        --port="$PORT" \
        --i-hereby-declare-i-dont-want-any-security-whatsoever &
}

# Start postgres shell (args in env)
start_webshell postgres 8881 psql

# Start mysql shell (args in env)
start_webshell mysql 8882 mysql

# Start sqlite shell (-safe forbids escapes like using .shell/.system commands), no other args needed
start_webshell sqlite 8883 'sqlite3 -safe'

# Start oracle shell, sqlplus doesn't seem to use readline for interactive line editing, history etc, 
# so we add it ourselves using rlwrap
start_webshell oracle 8884 'rlwrap sqlplus $ORACLE_USER/$ORACLE_PASSWORD@$ORACLE_HOST:$ORACLE_PORT/$ORACLE_PDB'

# Webshells run in background, only exit if all of them have died.
wait
