# Maintained in linux-init-files.org

set auto-load safe-path /
set auto-load local-gdbinit on
set history save on
set history filename ~/.gdb_history
set history size 32768
set history expansion on

set print pretty on

set print symbol-filename on

set pagination off
set confirm off

set print address off
set print symbol-filename off

define lsource
list *$rip
end

define il
info locals $arg0
end

define ila
info locals
end


define hook-quit
shell tmux kill-session -t "$(voltron-session)" &> /dev/null
shell tmux kill-session -t "$(tmux-current-session)" &> /dev/null
end

#### Initialise GEF Session
define gef-init

source ~/bin/thirdparty/gef/gef.py

define f
frame $arg0
context
end

define hook-up
context
end

define hook-down
context
end

# gef save updates ~/.gef.rc
# gef config context.layout "legend -regs stack -args source -code -threads -trace -extra -memory"
# gef config context.nb_lines_code 13
# gef config context.nb_lines_code_prev 6
# gef config context.nb_lines_stack 4
tmux-setup
# context
# shell tmux select-pane -t .0

end

#### Initialise Voltron Session
define voltron-init
source /home/rgr/.local/lib/python3.9/site-packages/voltron/entry.py

alias vtty = shell tmux-pane-tty voltron 4

define voltron-source-tty
shell tmux-pane-tty
end

voltron init

end

#### Initialise utility extensions
define ext-init
gef-init
voltron-init
end
