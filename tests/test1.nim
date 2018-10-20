# This is just an example to get you started. You may wish to put all of your
# tests into a single file, or separate them into multiple `test1`, `test2`
# etc. files (better names are recommended, just make sure the name starts with
# the letter 't').
#
# To run these tests, simply execute `nimble test`.

import unittest

import nimtomd

const nimCode = """
## My Program
## ----------
## Important test
## and more
proc markdownShow() =
  ## Echo markdown"""

const nimCodeComplex = """
## My Program
## ----------
## Important test
## and more
##
## Usage:
## =====
## .. code-block::plain
##    nimtomd [options] <filename>
##
## Options:
## ========
## ..code-block::plain
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
  discard"""


test "simple":
  check parseNimString(nimCode) == @["# My Program", "Important test", "and more", "", "# Types", "", "", "### proc markdownShow", "```nim", "proc markdownShow() =", "```", "Echo markdown"]

test "complex":
  check parseNimString(nimCodeComplex) == @["# My Program", "Important test", "and more", "", "# Types", "", "", "### proc markdownShow", "```nim", "proc markdownShow() =", "```", "Echo markdown", "My Program", "----------", "Important test", "and more", "", "Usage:", "=====", "```", "   nimtomd [options] <filename>", "", "Options:", "========", "```", "   filename.nim    File to output in Markdown", "   help            Shows the help menu", "", "```", "", "### proc globalProc*", "```nim", "proc globalProc*() =", "```", "Echo markdown", "### template nothing", "```nim", "template nothing(): string =", "```", "### macro donothing", "```nim", "macro donothing(): untyped =", "```"]