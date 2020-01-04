## My Program
## ----------
##
## Important test
## and more
##
## Usage:
## =====
##
## .. code-block::nim
##    nimtomd [options] <filename>
##
## Options:
## ========
## .. code-block::nim
##    filename.nim    File to output in Markdown
##    help            Shows the help menu
##

var globalVar*: string ## Important global


proc globalProc*() =
  ## Echo markdown
  echo "proc"


template nothing(): string =
  "nimtomd"


macro donothing(): untyped =
  discard