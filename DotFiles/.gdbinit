# Maintained in linux-init-files.org
alias gef = source ~/bin/thirdparty/gef/gef.py

set auto-load safe-path /
set auto-load local-gdbinit on
set history save on
set history filename ~/.gdb_history
set history size 32768
set history expansion on

set print pretty on
set pagination off
set confirm off

# set print address off
# set print symbol-filename on

define gef-start
gef
gef config context.layout "legend -regs stack -args source -code -threads -trace -extra -memory"
gef config context.nb_lines_prev 4
gef config context.nb_lines_code 60
gef config context.nb_lines_stack 4
tmux-setup
ctx
end
