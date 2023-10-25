#!/bin/bash -x

# Export environment variables to a file for persistence
export > ~/.bashrc

# Start Butterfly server instances for each database
butterfly.server.py --uri-root-path=postgres --cmd="bash -il -c psql"  --host=0.0.0.0 --port=8881 --i-hereby-declare-i-dont-want-any-security-whatsoever &
butterfly.server.py --uri-root-path=mysql --cmd="bash -il -c mysql"  --host=0.0.0.0 --port=8882 --i-hereby-declare-i-dont-want-any-security-whatsoever &
sudo -u sqlite butterfly.server.py --uri-root-path=sqlite --cmd="bash -il -c sqlite3"  --host=0.0.0.0 --port=8883 --i-hereby-declare-i-dont-want-any-security-whatsoever &

# Warning: Butterfly seems to handle nested quotes badly, so we use this very dirty trick to avoid them simply.
# The oracle database may take longer to start.
# rlwrap allows to have interactive features like history, line editing for non-interactive CLI applications.
echo >>~/.bashrc 'alias oracle="rlwrap sqlplus $ORACLE_USER/$ORACLE_PASSWORD@$ORACLE_HOST:$ORACLE_PORT/$ORACLE_PDB"'
butterfly.server.py --uri-root-path=oracle --cmd="bash -il -c oracle" --host=0.0.0.0 --port=8884 --i-hereby-declare-i-dont-want-any-security-whatsoever
