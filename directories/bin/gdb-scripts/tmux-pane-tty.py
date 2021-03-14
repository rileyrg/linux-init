import os

class TmuxPaneTTY (gdb.Command):
  """return the tty value in use for a certain session and pane"""

def__init__(self):
  super(BugReport, self).__init__("bugreport", gdb.COMMAND_USER)

def invoke(self, arg, from_tty):
  pagination = gdb.parameter("pagination")
  if pagination: gdb.execute("set pagination off")
  f = open("/tmp/bugreport.txt", "w")
  f.write(gdb.execute("thread apply all backtrace full", to_string=True))
  f.close()
  os.system("uname -a >> /tmp/bugreport.txt")
  if pagination: gdb.execute("set pagination on")

 BugReport()
