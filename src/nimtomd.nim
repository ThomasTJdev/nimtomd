# Copyright 2018 - Thomas T. Jarløv
## Nim to Markdown
## ---------------
##
## This Nim package converts Nim code to Markdown. Use `nimtomd`
## on your Nim file and transform it into a styled Markdown file.
##
## You can choose to only include global elements (*) and top
## comments, or you can include everything.
##
## The package is *hybrid* which means, it can run as binary
## but also be imported into your project.
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
##    -o:[filename]   Outputs the markdown to a file
##    -ow             Overwrites a file when -o is used
##    -global         Only include global element (*)
##
## Examples
## --------
##
## This README.md is made with `nimtomd` with the command:
## .. code-block::plain
##    nimtomd -o:README.md -ow -global nimtomd.nim
##
## Output to screen
## ================
##
## This prints the Markdown output to the screen:
## .. code-block::plain
##    nimtomd filename.nim
##
## Save output to file
## ===================
##
## You can force `nimtomd` to overwrite an existing file
## by using the option `-ow`.
##
## .. code-block::plain
##    nimtomd -o:README.md filename.nim
##
## Import nimtomd
## ===================
##
## When importing nimtomd to your project, you can pass
## Nim code as a string or by pointing to a file.
##
## **Parse file**
## .. code-block::Nim
##    import nimtomd
##    parseNimFile("filename.nim")
##    for line in markdown:
##      echo line
##
## **Parse string**
## .. code-block::Nim QQ
##    import nimtomd
##    let myNimCode = """
##      proc special*(data: string): string =
##        ## Special proc
##        echo data
##        return "Amen"
##    """
##
##    parseNimString(myNimCode)
##    for line in markdown:
##      echo line

import os, strutils, re, terminal


const
  nimtomd = """
nimtomd: Convert Nim comments to Markdown

nimtomd [options] filename"""

  help = """
nimtomd converts a Nim files comments to Markdown

Usage:
  nimtomd [options] <filename>

Options:
  filename.nim    File to output in Markdown
  help            Shows the help menu
  -o:[filename]   Outputs the markdown to a file
  -ow             Overwrites a file when -o is used
  -global         Only include global element (*)"""


var markdown:seq[string] = @[]

var lineNew = ""
var lineOld = ""


var firstRun = true
var firstComment = false

var newBlock = true

var copyrightInserted = false

var globalOnly = false
var globalActive = false

var codeElementLast = false
var codeElement: seq[string] = @[]

var codeIsReached = false
var codeFirstRun = true

var codeBlockOpen = false
var codeBlockFirstLine = false



proc isElement(line: string): bool =
  ## Check if line has an element
  if line.contains("#"):
    return false
  if line.strip().substr(0, 3) == "proc":
    return true
  if line.strip().substr(0, 7) == "template":
    return true
  if line.strip().substr(0, 4) == "macro":
    return true
  if line.strip().substr(0, 7) == "iterator":
    return true
  if line.strip().substr(0, 3) == "func":
    return true

proc isGlobal(line: string): bool =
  ## Check if line has global identifier
  if line.contains(re".*\S.*\*\("):
    return true
  if line.contains(re".*\S.*\*\:"):
    return true
  if line.contains(re".*\S.*\*\["):
    return true
  return false



proc formatTop(line: string): bool =
  ## Format top comments

  # Check the first line. If it's empty only using
  # single #, skip it
  if not firstComment:
    if line == "" or line.substr(0,1) == "# ":
      return false
    else:
      firstComment = true

  # If a codeblock is open
  if codeBlockOpen:
    if contains(lineNew.replace(" ", ""), "..code-block::"):
      # Check if this is going to be a codeblock
      if contains(toLowerAscii(lineNew), "plain"):
        markdown.add("```")
        markdown.add("")
        markdown.add("")
        markdown.add("```")
      else:
        markdown.add("```")
        markdown.add("")
        markdown.add("")
        markdown.add("```nim")

      codeBlockFirstLine = true
      codeBlockOpen = true
    elif (replace(line, "#", "").len() >= 1 and line.substr(0,2) != "   "):
      # Close the codeblock
      markdown.add("```")
      markdown.add("")
      markdown.add("")
      markdown.add(line)
      codeBlockOpen = false
    else:
      if codeBlockFirstLine:
        # If this is the first line in the codeblock
        codeBlockFirstLine = false
      else:
        markdown.add(lineOld.substr(3, lineOld.len()))

  elif contains(lineNew.replace(" ", ""), "..code-block::"):
    # Check if this is going to be a codeblock
    if contains(toLowerAscii(lineNew), "plain"):
      markdown.add("```")
    else:
      markdown.add("```nim")

    codeBlockFirstLine = true
    codeBlockOpen = true

  elif contains(lineNew, "---"):
    # Make heading H1
    markdown.delete(markdown.len())
    markdown.add("#" & lineOld)
  elif contains(lineNew, "===") or contains(lineNew, "^^^"):
    # Make sub heading H2
    markdown.delete(markdown.len())
    markdown.add("##" & lineOld)
  else:
    # Add line
    #markdown.add(line)
    markdown.add(line.substr(1, line.len()))

  return true



proc formatCode(line: string) =
  ## Format the code

  if contains(lineNew, ".. code-block::") or contains(lineNew, "..code-block::"):
    # Start a code block
    if contains(lineNew, "plain") or contains(lineNew, "Plain"):
      markdown.add("```")
    else:
      markdown.add("```nim")
    codeBlockFirstLine = true
    codeBlockOpen = true
  else:
    codeElementLast = false
    if newBlock:
      # Starting a new block

      if globalOnly:
        # Check if this is global
        var isGlobal = false
        for a in codeElement:
          if "*(" in a or "*[" in a:
            isGlobal = true
            globalActive = true
            break
        if not isGlobal:
          newBlock = false
          globalActive = false
          return

      markdown.add("") # Add spacing


      # Add code
      markdown.add("### " & codeElement[0].strip().replace(re"\(.*", ""))
      markdown.add("```nim")
      for i, h in codeElement:
        if i == 0:
          markdown.add(h.strip())
        else:
          markdown.add(h)
      markdown.add("```")
      markdown.add(line.substr(1, line.len()))

      # Cleanup
      codeElement = @[]
      newBlock = false

    else:
      # Just insert
      markdown.add(line.substr(1, line.len()))


proc fileCheckBasic(line: string): bool =
  ## Basic check of file

  if line == "when isMainModule:":
    return false

  if not firstComment:
    if line.substr(0,1) == "# " and not copyrightInserted and toLowerAscii(line).contains("copyright"):
      markdown.add("*" & line & "*")
      markdown.add("")
      copyrightInserted = true
      return false

    elif line.substr(0,1) == "##":
      firstComment = true
      lineOld = line.substr(2, line.len())
      markdown.add(line.substr(3, line.len()))

    elif line == "" or line.substr(0,1) == "# " or line.len() == 1:
      return false

    else:
      firstComment = true

  # If the code body is reached.
  # Checked with line = "" (ending of top comment) or line containing alpha.
  if not codeIsReached and (line == "" or isAlphaAscii(line.strip().substr(0, 1))):
    codeIsReached = true
    return true
  elif line.substr(0, 1) == "# ":
    return false

  return true


proc textTop(line: string): bool =
  ## Check the top text
  if line.substr(0, 1) == "##":
    lineNew = line.substr(2, line.len())

    if firstRun:
      firstRun = false
      return false

    if not formatTop(lineNew):
      return false

    lineOld = lineNew

  else:
    if codeBlockOpen:
      markdown.add("```")
      codeBlockOpen = false

  return true



proc textCode(line: string): bool =
  ## Work with the code text

  # If this is first time the code text is reached.
  if codeFirstRun:
    # Close open codeblocks and insert heading
    if codeBlockOpen:
      markdown.add(lineNew.substr(3, lineNew.len()))
      markdown.add("```")
      codeBlockOpen = false
    markdown.add("")
    markdown.add("# Types")
    markdown.add("")
    codeFirstRun = false

  # Check if global is required
  if globalOnly and not globalActive:
    if not isGlobal(line): #not line.contains(re"\S.*\*"):
      return false

  # Checkf line has double ##
  if contains(line.strip().substr(0,1), "##"):
    codeElementLast = false

    # Skip TODO's comments
    # TODO: Should TODO's be visible?
    if line.contains(re"\S.*## TODO"):
      return false

    # Single line element and comment
    if line.contains(re"\S.*##"):

      markdown.add("")
      markdown.add("### " & (line.multiReplace([(re"\=.*", ""), (re"\:.*", "")])).strip())
      markdown.add("```nim")
      markdown.add(line.replace(re"##.*", ""))
      markdown.add("```")
      markdown.add(line.replace(re".*## ", ""))
      codeElement = @[]

    # New codeblock or comment under element
    else:
      lineNew = line.replace(re".*##", "")
      formatCode(lineNew)
      lineOld = lineNew

  # If line does not contain double ##
  else:
    if isElement(line):

      # If codeElement has an element in storage, insert it before adding a new
      if codeElement.len() > 0:
        markdown.add("### " & codeElement[0].strip().replace(re"\(.*", ""))
        markdown.add("```nim")
        for i, h in codeElement:
          if i == 0:
            markdown.add(h.strip())
          else:
            markdown.add(h)
        markdown.add("```")

        codeElement = @[]

      # Check if only global is allowed
      if globalOnly:
        if not isGlobal(line): #not line.contains(re"\S.*\*"):
          return false
      globalActive = true
      codeElementLast = true

    if codeElementLast:
      # check for `): xxx =`, `{xxx} = and `) =`
      if line.contains(re"\)\:.*\=") or line.contains(re"\{.*\}.*\=") or line.contains(re"\).*\="):
        codeElementLast = false
      codeElement.add(line)

    # If this is an open code block
    if codeBlockOpen:
      codeElementLast = false

      # Close code block if open or append
      if replace(line, "#", "").len() >= 1 and line.substr(0,2) != "   ":
        markdown.add("```")
        codeBlockOpen = false
      else:
        markdown.add(line.substr(1, line.len()))

    newBlock = true

proc parseNim(filename: string) =
  ## Loop through file and generate Markdown
  for line in lines(filename):
    if not fileCheckBasic(line):
      continue
    if not codeIsReached:
      if not textTop(line):
        continue
    else:
      if not textCode(line):
        continue

proc parseNimFile*(filename: string): seq[string] =
  ## Loop through file and generate Markdown
  markdown = @[]
  for line in lines(filename):
    if not fileCheckBasic(line):
      continue
    if not codeIsReached:
      if not textTop(line):
        continue
    else:
      if not textCode(line):
        continue
  return markdown

proc parseNimString*(content: string): seq[string] =
  ## Loop through string and generate Markdown
  for line in split(content, "\n"):
    if not fileCheckBasic(line):
      continue
    if not codeIsReached:
      if not textTop(line):
        continue
    else:
      if not textCode(line):
        continue
  if codeElement.len() > 0:
    markdown.add("### " & codeElement[0].strip().replace(re"\(.*", ""))
    markdown.add("```nim")
    for i, h in codeElement:
      if i == 0:
        markdown.add(h.strip())
      else:
        markdown.add(h)
    markdown.add("```")
  return markdown

proc markdownShow() =
  ## Echo markdown
  for line in markdown:
    echo line

proc markdownToFile(filename: string, overwrite = false) =
  ## Save markdown to file
  if not overwrite and fileExists(filename):
    styledWriteLine(stderr, fgYellow, "WARNING: ", resetStyle, "File exists. Use -ow to overwrite.")
    return

  var content: string
  for line in markdown:
    content.add(line & "\n")

  writeFile(filename, content)

when isMainModule:
  let args = commandLineParams()
  if args.len() == 0:
    echo nimtomd
  elif "help" in args:
    echo help
  else:
    var toFile = false
    var outputFile = ""
    var overwrite = false
    for arg in args:
      if arg.substr(0, 2) == "-o:":
        outputFile = arg.substr(3, arg.len())
      elif arg == "-ow":
        overwrite = true
      elif arg == "-global":
        globalOnly = true

    if fileExists(args[args.len() - 1]):
      parseNim(args[args.len() - 1])
    else:
      styledWriteLine(stderr, fgRed, "ERROR: ", resetStyle, "File not found: " & args[args.len() - 1])
      quit(0)

    if outputFile.len() != 0:
      markdownToFile(outputFile, overwrite)
    else:
      markdownShow()
