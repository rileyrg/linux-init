# Maintained in linux-init-files.org
alias gef = source ~/bin/thirdparty/gef/gef.py
#alias gefc = gef config context.layout "legend -regs -stack code args source -threads -trace -extra -memory"

set auto-load safe-path /
set auto-load local-gdbinit on
set history save on
set history filename ~/.gdb_history
set history size 32768
set history expansion on

set print pretty on
set pagination off
set confirm off

#  /home/rgr/.local/lib/python3.9/site-packages/voltron/entry.py
