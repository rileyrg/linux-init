# Maintained in linux-init-files.org

set auto-load safe-path /
set auto-load local-gdbinit on
set history save on
set history filename ~/.gdb_history
set history size 32768
set history expansion on

set print pretty on

set print symbol-filename on

set pagination on
set confirm off

# set print address off
# set print symbol-filename on

define gef-init
source ~/bin/thirdparty/gef/gef.py
# gef save updates ~/.gef.rc
# gef config context.layout "legend -regs stack -args source -code -threads -trace -extra -memory"
# gef config context.nb_lines_code 16
# gef config context.nb_lines_code_prev 4
# gef config context.nb_lines_stack 4
tmux-setup
context
end

define voltron-init
source /home/rgr/.local/lib/python3.9/site-packages/voltron/entry.py
voltron init
end

define init
gef-init
voltron-init
end
