# Copyright 2018 - Thomas T. Jarløv
## Nim to Markdown
## ---------------
##
## *Generated with [Nim to Markdown](https://github.com/ThomasTJdev/nimtomd)*
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
##    -h, --help                Shows the help menu
##    -o:, --output:[filename]  Outputs the markdown to a file
##    -ow, --overwrite          Allow to overwrite a existing md file
##    -g, --global              Only include global elements (*)
##
## Requirements
## ------------
##
## Your code needs to follow the Nim commenting style. Checkout the
## source file for examples.
##
##
## Examples
## --------
##
## This README.md is made with ``nimtomd`` with the command:
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
## You can force ``nimtomd`` to overwrite an existing file
## by using the option ``-ow``.
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
## You can get the Markdown in either a seq[string] or string.
## The proc's are documented in the "Types -> Proc's" section.
## loop through.
##
## **Parse file**
## .. code-block::Nim
##    import nimtomd
##    let md = parseNimFileSeq("filename.nim")
##    for line in md:
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
##    let md = parseNimContentString(myNimCode)
##    for line in md.split("\n"):
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
  filename.nim              File to output in Markdown
  -h, --help                Shows the help menu
  -o:, --output:[filename]  Outputs the markdown to a file
  -ow, --overwrite          Allow to overwrite a existing md file
  -g, --global              Only include global elements (*)"""


var mdTop:seq[string]
var mdImport:seq[string]
var mdInclude:seq[string]
var mdCodeProc:seq[string]
var mdCodeTemplate:seq[string]
var mdCodeMacro:seq[string]
var mdCodeIterator:seq[string]
var mdCodeFunc:seq[string]
var mdCodeOther:seq[string]

var lineNew: string
var lineOld: string
var firstRun: bool
var firstComment: bool
var newBlock: bool
var copyrightInserted: bool
var globalOnly: bool
var globalActive: bool
var codeElementLast: bool
var codeElement: seq[string]
var codeElementSingleLine: bool
var codeIsReached: bool
var codeFirstRun: bool
var codeBlockOpen: bool
var codeBlockFirstLine: bool
var activeElement: string
var lastActiveElement: string

proc addToMd(data: string) =
  if data.len() == 0:
    return
  case activeElement
  of "proc":
    mdCodeProc.add(data)
  of "template":
    mdCodeTemplate.add(data)
  of "macro":
    mdCodeMacro.add(data)
  of "iterator":
    mdCodeIterator.add(data)
  of "func":
    mdCodeFunc.add(data)
  else:
    mdCodeOther.add(data)

proc initMdContainers() =
  mdTop = @[]
  mdImport = @[]
  mdInclude = @[]
  mdCodeProc = @[]
  mdCodeTemplate = @[]
  mdCodeMacro = @[]
  mdCodeIterator = @[]
  mdCodeFunc = @[]
  mdCodeOther = @[]

  lineNew = ""
  lineOld = ""
  firstRun = true
  firstComment = false
  newBlock = true
  copyrightInserted = false
  globalActive = false
  codeElementLast = false
  codeElement = @[]
  codeElementSingleLine = false
  codeIsReached = false
  codeFirstRun = true
  codeBlockOpen = false
  codeBlockFirstLine = false
  activeElement = ""
  lastActiveElement = ""

proc isElement(line: string): bool =
  ## Check if line has an element
  if line.contains("#"):
    activeElement = "other"
    return false
  if line.strip().substr(0, 3) == "proc":
    activeElement = "proc"
    return true
  if line.strip().substr(0, 7) == "template":
    activeElement = "template"
    return true
  if line.strip().substr(0, 4) == "macro":
    activeElement = "macro"
    return true
  if line.strip().substr(0, 7) == "iterator":
    activeElement = "iterator"
    return true
  if line.strip().substr(0, 3) == "func":
    activeElement = "func"
    return true

proc isGlobal(line: string): bool =
  ## Check if line has global identifier
  if line.contains(re".*\S.*\*\("):
    return true
  if line.contains(re".*\S.*\*\:"):
    return true
  if line.contains(re".*\S.*\*\["):
    return true
  if line.contains(re".*\*\{"):
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
        mdTop.add("```")
        mdTop.add("")
        mdTop.add("")
        mdTop.add("```")
      else:
        mdTop.add("```")
        mdTop.add("")
        mdTop.add("")
        mdTop.add("```nim")

      codeBlockFirstLine = true
      codeBlockOpen = true

    elif (replace(line, "#", "").len() >= 1 and line.substr(0,2) != "   ") or
          (replace(line, "#", "").len() == 0 and replace(lineOld, "#", "").len() == 0):
      # Close the codeblock of new text is found or if
      # the last line and current line are blank
      mdTop.add("```")
      mdTop.add("")
      mdTop.add("")
      mdTop.add(line)
      codeBlockOpen = false

    else:
      if codeBlockFirstLine:
        # If this is the first line in the codeblock
        codeBlockFirstLine = false
      else:
        mdTop.add(lineOld.substr(3, lineOld.len()))

  elif contains(lineNew.replace(" ", ""), "..code-block::"):
    # Check if this is going to be a codeblock
    if contains(toLowerAscii(lineNew), "plain"):
      mdTop.add("```")
    else:
      mdTop.add("```nim")

    codeBlockFirstLine = true
    codeBlockOpen = true

  elif contains(lineNew, "---"):
    # Make heading H1
    if mdTop.len() > 0: mdTop.delete(mdTop.len())
    mdTop.add("#" & lineOld)

  elif contains(lineNew, "===") or contains(lineNew, "^^^"):
    # Make sub heading H2
    if mdTop.len() > 0: mdTop.delete(mdTop.len())
    mdTop.add("##" & lineOld)

  else:
    # Add line
    mdTop.add(line.substr(1, line.len()))

  return true

proc fileCheckBasic(line: string): bool =
  ## Basic check of file

  if line == "when isMainModule:":
    return false

  if not firstComment:
    if line.substr(0,1) == "# " and not copyrightInserted and toLowerAscii(line).contains("copyright"):
      mdTop.add("*" & line & "*")
      mdTop.add("")
      copyrightInserted = true
      return false

    elif line.substr(0,1) == "##":
      firstComment = true
      lineOld = line.substr(2, line.len())
      mdTop.add(line.substr(3, line.len()))

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
      mdTop.add("```")
      codeBlockOpen = false

  return true

proc formatCode(line: string) =
  ## Format the code

  if contains(lineNew, ".. code-block::") or contains(lineNew, "..code-block::"):
    # Start a code block
    if contains(lineNew, "plain") or contains(lineNew, "Plain"):
      addToMd("```")
    else:
      addToMd("```nim")
    codeBlockFirstLine = true
    codeBlockOpen = true
  else:
    codeElementLast = false
    if newBlock:
      discard isElement(line)
      # Starting a new block

      if globalOnly:
        # Check if this is global
        var isGlobal = false
        for a in codeElement:
          #if "*(" in a or "*[" in a:
          if isGlobal(a):
            isGlobal = true
            globalActive = true
            break
        if not isGlobal:
          newBlock = false
          globalActive = false
          return

      addToMd("") # Add spacing


      # Add code
      if codeElement.len() > 0:
        addToMd("### " & codeElement[0].strip().replace(re"\(.*", ""))
        addToMd("```nim")
        for i, h in codeElement:
          if i == 0:
            addToMd(h.strip())
          else:
            addToMd(h)
        addToMd("```")
        addToMd(line.substr(1, line.len()))

      # Cleanup
      codeElement = @[]
      newBlock = false

    else:
      # Just insert
      addToMd(line.substr(1, line.len()))

proc textCode(line: string): bool =
  ## Work with the code text

  # Check if this is a single line comment continued
  if line.strip().len() == 0:
    codeElementSingleLine = false

  # If this is first time the code text is reached.
  if codeFirstRun:
    # Close open codeblocks from mdTop. codeFirstRun: bool is used to
    # identify mdTop
    if codeBlockOpen:
      mdTop.add(lineNew.substr(3, lineNew.len()))
      mdTop.add("```")
      mdTop.add("")
      codeBlockOpen = false
    addToMd("")
    codeFirstRun = false

  # Check if global is required
  if globalOnly and not globalActive:
    if not isGlobal(line): #not line.contains(re"\S.*\*"):
      return false

  if line.substr(0, 5) == "import":
    mdImport.add(line.strip())
    return false

  if line.substr(0, 6) == "include":
    mdInclude.add(line.strip())
    return false

  # Check line has 2xhashtag
  if contains(line, " ##"):
  #if contains(line.strip().substr(0,1), "##"):
    codeElementLast = false

    # Skip TODO's comments
    # TODO: Should TODO's be visible?
    if line.contains(re"\S.*## TODO"):
      return false

    # Single line element and comment
    # Checks for <alpha 2xhashtag> and <` 2xhashtag>
    if line.contains(re"\S.*##") or line.contains(re"\`.*##"):
      #Check if only global is allowed
      if globalOnly:
        if not isGlobal(line): #not line.contains(re"\S.*\*"):
          return false
      discard isElement(line)
      addToMd("")
      # Clean heading with =, : and {
      addToMd("### " & (line.multiReplace([(re"\=.*", ""), (re"\:.*", ""), (re"\{.*", "")])).strip())
      addToMd("```nim")
      addToMd(line.replace(re"##.*", "").strip())
      addToMd("```")
      addToMd(line.replace(re".*## ", ""))
      codeElement = @[]
      codeElementSingleLine = true

    # Check if single line comment has been active.
    # This is used for multiple line comments for a single line element
    elif codeElementSingleLine and line.contains(re".*##\s\S"):
      addToMd(line.replace(re".*##", ""))

    # New codeblock or comment under element
    else:
      codeElementSingleLine = false
      lineNew = line.replace(re".*##", "")
      formatCode(lineNew)
      lineOld = lineNew

  # If line does not contain 2xhashtag
  else:
    # Is the line an element
    if isElement(line):
      # If codeElement has an element in storage, insert it before adding a new
      if codeElement.len() > 0:
        activeElement = lastActiveElement

        if codeBlockOpen:       # TEST
          addToMd("```")        # TEST
          codeBlockOpen = false # TEST
        addToMd("### " & codeElement[0].strip().replace(re"\(.*", ""))
        addToMd("```nim")
        for i, h in codeElement:
          if i == 0:
            addToMd(h.strip())
          else:
            addToMd(h)
        addToMd("```")

        codeElement = @[]

      discard isElement(line)
      lastActiveElement = activeElement

      # Check if only global is allowed
      if globalOnly:
        if not isGlobal(line): #not line.contains(re"\S.*\*"):
          return false
      globalActive = true
      codeElementLast = true

    if codeElementLast:
      # check for "): xxx =", "{ xxx } xxx =" = and ") xxx ="
      if line.contains(re"\)\:.*\=") or line.contains(re"\{.*\}.*\=") or line.contains(re"\).*\=") or line.contains(re"\(.*\).*\{.*\}"):
        codeElementLast = false
      codeElement.add(line)

    # If this is an open code block
    if codeBlockOpen:
      codeElementLast = false

      # Close code block if open or append
      if replace(line, "#", "").len() >= 1 and line.substr(0,2) != "   ":
        addToMd("```")
        codeBlockOpen = false
      else:
        addToMd(line.substr(1, line.len()))

    newBlock = true

proc appendLastLine() =
  ## When the file is ended and an element is in cache
  if codeElement.len() > 0:
    addToMd("### " & codeElement[0].strip().replace(re"\(.*", ""))
    addToMd("```nim")
    for i, h in codeElement:
      if i == 0:
        addToMd(h.strip())
      else:
        addToMd(h)
    addToMd("```")

proc generateMarkdown(): string =
  ## Generate markdown to string
  for line in mdTop:
    result.add(line & "\n")
  if mdImport.len() > 0:
    result.add("# Imports\n")
    for line in mdImport:
      result.add(line & "\n\n")
  if mdInclude.len() > 0:
    result.add("# Include\n")
    for line in mdInclude:
      result.add(line & "\n\n")
  result.add("# Types\n")
  if mdCodeProc.len() > 0:
    result.add("## Procs\n")
    for line in mdCodeProc:
      result.add(line & "\n")
  if mdCodeTemplate.len() > 0:
    result.add("## Templates\n")
    for line in mdCodeTemplate:
      result.add(line & "\n")
  if mdCodeMacro.len() > 0:
    result.add("## Macros\n")
    for line in mdCodeMacro:
      result.add(line & "\n")
  if mdCodeIterator.len() > 0:
    result.add("## Iterators\n")
    for line in mdCodeIterator:
      result.add(line & "\n")
  if mdCodeFunc.len() > 0:
    result.add("## Funcs\n")
    for line in mdCodeFunc:
      result.add(line & "\n")
  if mdCodeOther.len() > 0:
    result.add("## Other\n")
    for line in mdCodeOther:
      result.add(line & "\n")

proc generateMarkdownSeq(): seq[string] =
  ## Generate markdown to seq
  var md: seq[string] = @[]
  if mdTop.len() > 0:
    md.add(mdTop)
  if mdImport.len() > 0:
    md.add("# Imports\n")
    md.add(mdImport)
  if mdInclude.len() > 0:
    md.add("# Include\n")
    md.add(mdInclude)
  md.add("# Types\n")
  if mdCodeProc.len() > 0:
    md.add("## Procs\n")
    md.add(mdCodeProc)
  if mdCodeTemplate.len() > 0:
    md.add("## Templates\n")
    md.add(mdCodeTemplate)
  if mdCodeMacro.len() > 0:
    md.add("## Macros\n")
    md.add(mdCodeMacro)
  if mdCodeIterator.len() > 0:
    md.add("## Iterators\n")
    md.add(mdCodeIterator)
  if mdCodeFunc.len() > 0:
    md.add("## Funcs\n")
    md.add(mdCodeFunc)
  if mdCodeOther.len() > 0:
    md.add("## Other\n")
    md.add(mdCodeOther)
  return md

proc markdownShow() =
  ## Echo markdown
  let md = generateMarkdown()
  if md.len() == 0:
    styledWriteLine(stderr, fgYellow, "WARNING: ", resetStyle, "No markdown was generated.")
  else:
    for line in md.split("\n"):
      echo line

proc markdownToFile(filename: string, overwrite = false) =
  ## Save markdown to file
  if not overwrite and fileExists(filename):
    styledWriteLine(stderr, fgYellow, "WARNING: ", resetStyle, "File exists. Use -ow to overwrite.")
  else:
    let md = generateMarkdown()
    if md.len() == 0:
      styledWriteLine(stderr, fgYellow, "WARNING: ", resetStyle, "No markdown was generated.")

    writeFile(filename, md)

proc parseNim(filename: string) =
  ## Loop through file and generate Markdown
  initMdContainers()
  for line in lines(filename):
    if not fileCheckBasic(line):
      continue
    if not codeIsReached:
      if not textTop(line):
        continue
    else:
      if not textCode(line):
        continue
  appendLastLine()

proc parseNimFile(filename: string) =
  ## Loop through file and generate Markdown
  initMdContainers()
  for line in lines(filename):
    if not fileCheckBasic(line):
      continue
    if not codeIsReached:
      if not textTop(line):
        continue
    else:
      if not textCode(line):
        continue
  appendLastLine()

proc parseNimString(content: string) =
  ## Loop through string and generate Markdown
  initMdContainers()
  for line in split(content, "\n"):
    if not fileCheckBasic(line):
      continue
    if not codeIsReached:
      if not textTop(line):
        continue
    else:
      if not textCode(line):
        continue
  appendLastLine()

proc parseNimFileString*(filename: string): string =
  ## Loop through file and generate Markdown to string
  parseNimFile(filename)
  return generateMarkdown()

proc parseNimFileSeq*(filename: string): seq[string] =
  ## Loop through file and generate Markdown to seq[string]
  parseNimFile(filename)
  return generateMarkdownSeq()

proc parseNimContentString*(content: string): string =
  ## Loop through string and generate Markdown to string
  parseNimString(content)
  return generateMarkdown()

proc parseNimContentSeq*(content: string): seq[string] =
  ## Loop through string and generate Markdown to seq[string]
  parseNimString(content)
  return generateMarkdownSeq()

when isMainModule:
  let args = multiReplace(commandLineParams().join(","), [("-", ""), (" ", "")])
  case args
  of "", " ":
    echo nimtomd

  of "h", "help":
    echo help

  else:
    var toFile = false
    var outputFile = ""
    var overwrite = false
    let argsSplit = args.split(",")
    for arg in argsSplit:
      if arg.contains("o:"):
        outputFile = arg.substr(2, arg.len())
      elif arg.contains("output:"):
        outputFile = arg.substr(7, arg.len())
      elif arg == "ow" or arg == "overwrite":
        overwrite = true
      elif arg == "global" or arg == "g":
        globalOnly = true

    if fileExists(argsSplit[argsSplit.len() - 1]):
      parseNim(argsSplit[argsSplit.len() - 1])
    else:
      styledWriteLine(stderr, fgRed, "ERROR: ", resetStyle, "File not found: " & argsSplit[argsSplit.len() - 1])
      quit(0)

    if outputFile.len() != 0:
      markdownToFile(outputFile, overwrite)
    else:
      markdownShow()
