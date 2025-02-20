import os

  class TmuxPaneTTY (gdb.Command):
      """return the tty value in use for a certain session and pane"""

   def__init__(self):
   super(TmuxPaneTTY, self).__init__("tmux-pane-tty", gdb.COMMAND_USER)

   def invoke(self, arg, from_tty):
       os.system("tmux-pane-tty voltron 4")

  TMuxPaneTTY()
