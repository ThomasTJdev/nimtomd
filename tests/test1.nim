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


test "simpleSeq":
  check parseNimContentSeq(nimCode) == @["# My Program", "Important test", "and more", "# Types\n", "## Procs\n", "### proc markdownShow", "```nim", "proc markdownShow() =", "```", "Echo markdown"]

test "complexSeq":
  check parseNimContentSeq(nimCodeComplex) == @["# My Program", "Important test", "and more", "", "## Usage:", "```", " nimtomd [options] <filename>", "```", "", "", "## Options:", "```", " filename.nim    File to output in Markdown", " help            Shows the help menu", "", "```", "", "# Types\n", "## Procs\n", "### proc globalProc*", "```nim", "proc globalProc*() =", "```", "Echo markdown", "## Macros\n", "### template nothing", "```nim", "template nothing(): string =", "```", "### macro donothing", "```nim", "macro donothing(): untyped =", "```", "## Other\n", "### var globalVar*", "```nim", "var globalVar*: string", "```", "Important global"]

test "simpleString":
  check parseNimContentString(nimCode) == "# My Program\nImportant test\nand more\n# Types\n## Procs\n### proc markdownShow\n```nim\nproc markdownShow() =\n```\nEcho markdown\n"

test "complexString":
  check parseNimContentString(nimCodeComplex) == "# My Program\nImportant test\nand more\n\n## Usage:\n```\n nimtomd [options] <filename>\n```\n\n\n## Options:\n```\n filename.nim    File to output in Markdown\n help            Shows the help menu\n\n```\n\n# Types\n## Procs\n### proc globalProc*\n```nim\nproc globalProc*() =\n```\nEcho markdown\n## Macros\n### template nothing\n```nim\ntemplate nothing(): string =\n```\n### macro donothing\n```nim\nmacro donothing(): untyped =\n```\n## Other\n### var globalVar*\n```nim\nvar globalVar*: string\n```\nImportant global\n"