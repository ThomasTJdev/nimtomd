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
## Usage:
## =====
## .. code-block::plain
##    nimtomd [options] <filename>
##
## Options:
## ========
## .. code-block::plain
##    Options:
##      <filename>                Nim-file to convert into markdown
##      -h,  --help               Shows the help menu
##      -o:, --output:[filename]  Outputs the markdown to a file
##      -ow, --overwrite          Allow to overwrite a existing md file
##      -g,  --onlyglobals        Only include global elements (*)
##      -sh                       Skip headings
##      -si                       Skip imports
##      -st                       Skip types
##      -il, --includelines       Include linenumbers
##      -ic, --includeconst       Include const
##      -il, --includelet         Include let
##      -iv, --includevar         Include var
##
##
## Requirements
## ------------
##
## Your code needs to follow the Nim coding style. Checkout the
## source file for examples.
##
##
## Examples
## --------
##
## This README.md is made with ``nimtomd`` with the command:
## .. code-block::plain
##    nimtomd -o:README.md -ow -g nimtomd.nim
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
##    nimtomd -o:README.md -ow filename.nim
##



import strutils, re, os, terminal, algorithm

from times import epochTime


type
  CodeText = object
    data: seq[string]

  CodeImport = object
    data: seq[tuple[line: int, global: bool, newline: bool, code: string]]

  CodeFrom = object
    data: seq[tuple[line: int, global: bool, newline: bool, code: string]]

  CodeType = object
    data: seq[tuple[line: int, global: bool, newline: bool, heading: string, comment: string, code: string]]

  CodeTemplate = object
    data: seq[tuple[line: int, global: bool, heading: string, comment: string, code: string, runnable: string]]

  CodeMacro = object
    data: seq[tuple[line: int, global: bool, heading: string, comment: string, code: string, runnable: string]]

  CodeProc = object
    data: seq[tuple[line: int, global: bool, heading: string, comment: string, code: string, runnable: string]]

  CodeFunc = object
    data: seq[tuple[line: int, global: bool, heading: string, comment: string, code: string, runnable: string]]

  CodeIterator = object
    data: seq[tuple[line: int, global: bool, heading: string, comment: string, code: string, runnable: string]]

  CodeConst = object
    data: seq[tuple[line: int, global: bool, heading: string, comment: string, code: string]]

  CodeLet = object
    data: seq[tuple[line: int, global: bool, heading: string, comment: string, code: string]]

  CodeVar = object
    data: seq[tuple[line: int, global: bool, heading: string, comment: string, code: string]]


var
  codeText: CodeText
  codeImport: CodeImport
  codeFrom: CodeFrom
  codeType: CodeType
  codeTemplate: CodeTemplate
  codeMacro: CodeMacro
  codeProc: CodeProc
  codeFunc: CodeFunc
  codeIterator: CodeIterator
  codeConst: CodeConst
  codeLet: CodeLet
  codeVar: CodeVar

var
  lineForce: int      ## Force to a new line, if `forceNewLine=true`
  forceNewLine: bool  ## Can force the parser to a new line
  hasAnyData: bool    ## Used to check, if theres any data available




proc checkElement(line: string): string =
  ## Check if line has an element and return the element type
  if line.substr(0, 3) == "proc":
    return "proc"
  elif line.substr(0, 7) == "template":
    return "template"
  elif line.substr(0, 4) == "macro":
    return "macro"
  elif line.substr(0, 7) == "iterator":
    return "iterator"
  elif line.substr(0, 3) == "func":
    return "func"
  elif line.substr(0, 3) == "type":
    return "type"
  elif line.substr(0, 5) == "import":
    return "import"
  elif line.substr(0,3) == "from" and line.contains("import"):
    return "from"
  elif line.substr(0,4) == "const":
    return "const"
  elif line.substr(0,2) == "var":
    return "var"
  elif line.substr(0,2) == "let":
    return "let"
  else:
    return ""


proc isGlobal(line: string): bool =
  ## Check if line has global identifier
  if line.contains(re".*\S.*\*\("):     #bla*(
    return true
  elif line.contains(re".*\S.*\*\:"):   #bla*:
    return true
  elif line.contains(re".*\S.*\*\["):   #bla*[
    return true
  elif line.contains(re".*\*\{"):       #bla*{
    return true
  else:
    return false


proc fillElement(element: string, headLineNr: int, isGlobal: bool, head, comment, code, runnable: string) =
  ## Fill an element

  case element
  of "template":
    codeTemplate.data.add((headLineNr, isGlobal, head, comment, code, runnable))
  of "macro":
    codeMacro.data.add((headLineNr, isGlobal, head, comment, code, runnable))
  of "proc":
    codeProc.data.add((headLineNr, isGlobal, head, comment, code, runnable))
  of "func":
    codeFunc.data.add((headLineNr, isGlobal, head, comment, code, runnable))
  of "iterator":
    codeIterator.data.add((headLineNr, isGlobal, head, comment, code, runnable))
  else:
    styledWriteLine(stderr, fgRed, "ERROR: ", resetStyle, "Could not fill " & element)
    return

  hasAnyData = true


proc fillVariable(element: string, headLineNr: int, isGlobal: bool, head, comment, code: string) =
  ## Fill an element

  case element
  of "const":
    codeConst.data.add((headLineNr, isGlobal, head, comment, code))
  of "let":
    codeLet.data.add((headLineNr, isGlobal, head, comment, code))
  of "var":
    codeVar.data.add((headLineNr, isGlobal, head, comment, code))
  else:
    styledWriteLine(stderr, fgRed, "ERROR: ", resetStyle, "Could not fill " & element)
    return

  hasAnyData = true

proc isAlphaNumeric(s: string): bool =
  ## WHY! WHY! WHY don't we have this is in std?
  for c in s:
    if not isAlphaNumeric(c):
      return false
  return true

proc parseVariable(elementValue: string, lineCurrentNr: int, file: seq[string]) =
  ## Parse a const, var or let

  var
    head: string
    comment: string
    code: string
    headLineNr: int
    isGlobal: bool

  for lineNr in countup(lineCurrentNr, file.len()-1):
    let line = file[lineNr].strip()
    if line == elementValue:
      if head != "":
        fillVariable(elementValue, headLineNr, isGlobal, head, comment, code)
        head = ""
        comment = ""
        code = ""
        headLineNr = 0
        isGlobal = false
      continue
    elif line == "":
      fillVariable(elementValue, headLineNr, isGlobal, head, comment, code)
      head = ""
      comment = ""
      code = ""
      headLineNr = 0
      isGlobal = false
      if file[lineNr+1] == "" or file[lineNr+1].substr(0,1) != "  ":# and file[lineNr+1].substr(0,1) :
        forceNewLine = true
        lineForce    = lineNr
        break
      continue
    elif head != "" and file[lineNr].substr(0,2) != "   " and "#" notin file[lineNr].substr(0,2):
      fillVariable(elementValue, headLineNr, isGlobal, head, comment, code)
      head = ""
      comment = ""
      code = ""
      headLineNr = 0
      isGlobal = false

    if line.contains("##"):
      if line.replace(re"##.*", "") == "":
        let lineComm = line.replace("##", "").strip()
        if comment != "":
          comment.add("\n")
        comment.add(lineComm)
      else:
        let lineHead = line.replace(re"##.*", "").replace(elementValue, "").strip()
        let lineComm = line.replace(re".*##", "").strip()
        if comment != "":
          comment.add("\n")
        comment.add(lineComm)
        head.add(lineHead.replace(re"=.*", ""))
        code.add(lineHead)
        headLineNr = lineNr
        isGlobal = if line.contains("*"): true else: false

    else:
      let lineClean = line.replace(elementValue, "").strip()
      head.add(lineClean.replace(re"=.*", ""))
      code.add(lineClean)
      headLineNr = lineNr
      isGlobal = if line.contains("*"): true else: false



proc parseElement(elementValue: string, lineCurrentNr: int, file: seq[string]) =
  ## Parse `template`

  var
    isRunning: bool
    isGlobal: bool
    isRunnableExample: bool
    headLineNr: int
    head: string
    comment: string
    code: string
    codeblock: bool
    runnable: string

  for lineNr in countup(lineCurrentNr, file.len()-1):
    let line = file[lineNr].strip()
    let element = checkElement(file[lineNr]) # Do not pass a strip(), then it'll find it as a let element.

    # If a new element was found or line is empty, exit the parser
    if (element != elementValue and element != "") or line == "":
      forceNewLine = true
      lineForce    = lineNr
      if isRunning:
        fillElement(elementValue, headLineNr, isGlobal, head, comment, code, runnable)
      break

    # Heading
    if element == elementValue:
      if isRunning:
        fillElement(elementValue, headLineNr, isGlobal, head, comment, code, runnable)

      if line.contains("##"):
        comment = line.replace(re".*##\s", "").strip()

      isRunning   = true
      isGlobal   = isGlobal(line)
      headLineNr = lineNr + 1 # Adding +1 since fileread starts from 0
      head       = line.replace(re"\(.*", "").replace("proc", "").strip() # anyNonWord# blabla
      code       = line.replace(re"#.*", "").strip()
      continue

    elif codeblock and line.substr(0,4) == "##   " and line.replace("##", "") != "":
      comment.add(line.replace("##  ", "") & "\n")


    elif line.substr(0,1) == "##":
      if line.contains(".. code-block::"):
        codeblock = true
        comment.add("\n")
        comment.add("```nim")
        comment.add("\n")
        continue

      if codeblock and file[lineNr-1].contains(".. code-block::"):
        continue

      if codeblock:
        comment.add("```")
        comment.add("\n")
      codeblock = false

      var comm = line.replace(re".*##\s", "").replace("##", "").strip()
      var isLink = comm.replace(re".*\<", "").replace(re"\>`_.*", "")

      # HTML link
      if isLink != "" and isLink.substr(isLink.len()-5, isLink.len()) == ".html":
        let link = " [(link)](https://nim-lang.org/docs/" & isLink & ")"
        comm = comm.replace("<" & isLink & ">`_", link).replace("`", "")

      # Insert new line
      if comment.len() != 0:
        comment.add(" ")

      if line == "## See also:":
        comment.add("\n\n" & comm)
      elif line.substr(0, 3) == "## *":
        comment.add("\n" & comm)
      elif comm == "":
        comment.add("\n\n")
      else:
        comment.add(comm)

    elif line == "runnableExamples:" or isRunnableExample:
      isRunnableExample = true
      if line == "runnableExamples:" or file[lineNr].substr(0,3) == "    ":
        if runnable != "":
          runnable.add("\n")
        runnable.add(file[lineNr])


    elif line.substr(line.len()-1, line.len()-1) == "=":
      code.add(" " & line)



proc parseType(lineCurrentNr: int, file: seq[string]) =
  ## Parse `type` statements.

  var
    typeIsRunning: bool
    typeIsGlobal: bool
    typeHeadLineNr: int
    typeHead: string
    typeComment: string
    typeCode: string

  for lineNr in countup(lineCurrentNr, file.len()-1):
    let line = file[lineNr].strip()
    let element = checkElement(line)

    # Empty line continue
    if line == "" or line == "type":
      continue

    # If a new element was found, exit the parser
    if element != "type" and element != "":
      forceNewLine = true
      lineForce    = lineNr
      if typeIsRunning:
        codeType.data.add((typeHeadLineNr, typeIsGlobal, true, typeHead, typeComment, typeCode))
        hasAnyData = true
      break

    # Get heading - indent = 2
    if file[lineNr].substr(0,1) == "  " and isAlphaNumeric(file[lineNr].substr(2,2)):
      # Code check
      if isLowerAscii(file[lineNr][2]):
        styledWriteLine(stderr, fgRed, "ERROR: ", resetStyle, "Type is starting with a lower ASCII: " & line)

      # Check if a new type is found
      if typeIsRunning:
        # ADD type
        codeType.data.add((typeHeadLineNr, typeIsGlobal, true, typeHead, typeComment, typeCode))
        hasAnyData = true
        typeHead    = ""
        typeComment = ""
        typeCode    = ""

      if file[lineNr].contains("##"):
        typeComment = line.replace(re".*##\s", "").strip()

      typeIsRunning  = true
      typeIsGlobal   = if file[lineNr].contains("*"): true else: false
      typeHeadLineNr = lineNr + 1 # Adding +1 since fileread starts from 0
      typeHead       = line.replace(re"\W#\s.*", "").strip() # anyNonWord# blabla
      typeCode       = "  " & line.replace(re"#.*", "").strip() # First line (object), strip comment
      continue

    # Check if multiline comment is present for head
    if line.substr(0, 1) == "##":
      typeComment.add(" " & line.replace("##", "").strip)
      continue

    # Get items - indent = 4
    if file[lineNr].substr(0,3) == "    " and isAlphaNumeric(file[lineNr].substr(4,4)):
      let cleanCode = file[lineNr].replace(re"\W#\s.*", "")

      # Check if comment is present
      if file[lineNr].contains("##"):

        # Head comment is already present, insert new line
        if typeComment.len() != 0:
          typeComment.add("\n\n")

        typeComment.add("* __" & cleanCode.strip() & "__: " & line.replace(re".*##\s", "").strip())
        hasAnyData = true

      typeCode.add("\n" & cleanCode)
      continue


proc parseFrom(lineCurrentNr: int, file: seq[string]) =
  ## Parse `from xx import yy` statements.
  ##
  ## `lineNr` contains "from" and "import".
  ##
  ## Does not support multiline comments

  for lineNr in countup(lineCurrentNr, file.len()-1):
    let line = file[lineNr].strip()
    let lineRaw = file[lineNr]
    let element = checkElement(line)

    # If a new element was found, exit the parser
    if (element != "from" and element != "") or line == "":
      forceNewLine = true
      lineForce    = lineNr
      break

    # Add data
    # Always new lines, due to to long lines otherwise
    if lineRaw.substr(0,1) == "##" or lineRaw.substr(0,1) == "# " or line.substr(0,1) == "##" or line.substr(0,1) == "# ":# or (lineRaw.substr(0,3) != "from" and lineRaw.substr(0,1) != "  "):
      continue

    # Strip line, so inside code comments is gone.
    let lineClean = line.strip()
    var data: string
    if line.contains("##"):
      data = replace(lineClean, "##", ":").strip() # space#space*
    elif line.contains("#"):
      data = replace(lineClean, re"\s#\s.*", "").strip() # space#space*
    else:
      data = lineClean

    # If its global, add global bool
    # Baah - imports should not be global"
    if line.contains("*"):
      codeFrom.data.add((lineNr, true, true, data))
      hasAnyData = true
      styledWriteLine(stderr, fgYellow, "WARNING: ", resetStyle, "You have an import from set as a global..: " & line)
    # Add as normal
    else:
      codeFrom.data.add((lineNr, false, true, "* " & data))
      hasAnyData = true



proc parseImport(lineCurrentNr: int, file: seq[string]) =
  ## Parse `import xx` statements.
  ##
  ## `lineNr` contains "import".
  ##
  ## Does not support multiline comments
  for lineNr in countup(lineCurrentNr, file.len()-1):
    let line = file[lineNr].strip()
    let element = checkElement(line)

    # Empty line continue
    if line == "import":
      continue

    # If a new element was found, exit the parser
    if (element != "import" and element != "") or line == "":
      forceNewLine = true
      lineForce    = lineNr
      break

    # Check for multiline comment
    if line.substr(0,1) == "##" or line.substr(0,0) == "#":
      continue

    # Add data
    # If line contains comments, specify it as a new line
    var newline = if line.contains("##"): true else: false

    # Strip line, so inside code comments is gone.
    let lineClean = line.replace(re"import\s", "").replace(",", "").strip()
    var data: string
    if not newline:
      data = "* " & lineClean.split(" ")[0].strip()
    else:
      data = "* " & replace(lineClean, re"\s.#", ": ").strip()

    # If its global, add global bool
    # Baah - imports should not be global"
    if line.contains("*"):
      codeImport.data.add((lineNr, true, newline, data))
      hasAnyData = true
      styledWriteLine(stderr, fgYellow, "WARNING: ", resetStyle, "You have an import from set as a global..: " & line)
    # Add as normal
    else:
      codeImport.data.add((lineNr, false, newline, data))
      hasAnyData = true


proc parseCodeText(lineCurrentNr: int, file: seq[string]) =
  ## Parse text inside code. E.g. intro text etc.
  var skipNextLine: bool
  var codeRunning: bool

  for lineNr in countup(lineCurrentNr, file.len()-1):

    # If we already have taken next lines header, then skip the header line.
    # Only used on === and ----
    if skipNextLine:
      skipNextLine = false
      continue

    let line = file[lineNr].strip()

    # Check if next line is a code - if we're currently inserting code
    if (line == "" or line.substr(0,1) == "# " or line == "#") and codeRunning:
      codeRunning = false
      codeText.data.add("```")

    # Empty line continue
    if (line == "" or line.substr(0,1) == "# " or line == "#"):
      # If the next line does not have a comment, then break
      if file[lineNr+1].substr(0,1) != "##" or file[lineNr+1].substr(0,1) != "# ":
        forceNewLine = true
        lineForce    = lineNr
        break

      continue

    # If this is a code block
    if line.contains(".. code-block::") or codeRunning:
      codeRunning = true
      let lineClean = line.substr(2, line.len())
      let nextLine = file[lineNr+1].substr(2, file[lineNr+1].len())
      let nextNextLine = file[lineNr+2].substr(2, file[lineNr+2].len())

      # If we are coming to an end with the code block
      if lineClean.strip() == "" and nextLine.substr(0, 1) != "  " and nextNextLine.substr(0, 1) != "  ":
        codeRunning = false
        codeText.data.add("```")

      # Code block start
      if line.contains(".. code-block::"):
        codeText.data.add("```nim")
      # Code block code
      else:
        codeText.data.add(lineClean.strip())

    # Normal text
    else:
      # Check the headings
      let nextLine = file[lineNr+1].substr(2, file[lineNr+1].len()).strip()
      var heading: string
      if nextLine.contains("==="):           #H1
        skipNextLine = true
        heading = "# "
      elif nextLine.substr(0,0) == "#":      #H1
        heading = "# "
      elif nextLine.contains("---"):         #H2
        skipNextLine = true
        heading = "## "
      elif nextLine.substr(0,1) == "##":     #H2
        heading = "## "
      elif nextLine.substr(0,2) == "###":    #H3
        heading = "### "
      elif nextLine.substr(0,3) == "####":   #H4
        heading = "#### "
      elif nextLine.substr(0,4) == "#####":  #H5
        heading = "##### "
      elif nextLine.substr(0,5) == "######": #H6
        heading = "###### "

      # Insert text
      codeText.data.add(heading & line.replace("#", "").strip())



proc parseLine(lineNr: int, file: seq[string]) =
  ## Parse the current line. If a `proc` or other element is spottet, the
  ## parser will continue until it is parsed, and push a new line the reader.

  # Check element
  let element = checkElement(file[lineNr])

  # If this is first run and main text is coming
  if element == "" and not hasAnyData and (file[lineNr].substr(0,1) == "##" or file[lineNr].substr(0,1) == "# "):
    parseCodeText(lineNr, file)
    return

  # If this is inside code
  elif element == "":
    return

  # If an element was found, parse it
  case element
  of "import":
    parseImport(lineNr, file)
  of "from":
    parseFrom(lineNr, file)
  of "type":
    parseType(lineNr, file)
  of "template":
    parseElement("template", lineNr, file)
  of "macro":
    parseElement("macro", lineNr, file)
  of "proc":
    parseElement("proc", lineNr, file)
  of "func":
    parseElement("func", lineNr, file)
  of "iterator":
    parseElement("iterator", lineNr, file)
  of "const":
    parseVariable("const", lineNr, file)
  of "let":
    parseVariable("let", lineNr, file)
  of "var":
    parseVariable("var", lineNr, file)
  else:
    echo element

  return


proc generateMarkdown(onlyGlobals, includeHeadings, includeImport, includeTypes, includeLines, includeConst, includeLet, includeVar: bool): seq[string] =
  var data: seq[string]

  # Code text
  if codeText.data.len() > 0:
    for i in codeText.data:
      data.add(i)


  # Import
  if includeImport and (codeImport.data.len() > 0 or codeFrom.data.len() > 0):
    data.add("# Imports\n")

    for i in codeImport.data.sortedByIt(it.code):
      for n in split(i.code, "\n"):
        data.add(n)

    data.add("\n")

    for i in codeFrom.data.sortedByIt(it.code):
      for n in split(i.code, "\n"):
        data.add(n)

    data.add("\n")


  # Types
  if includeTypes and codeType.data.len() > 0:
    data.add("# Types\n")
    for i in codeType.data:
      if onlyGlobals:
        if not i.global: continue

      if includeHeadings:
        data.add("## " & i.heading & "\n")
      for n in split(i.comment, "\n"):
        data.add(n)
      data.add("```nim")
      for n in split(i.code, "\n"):
        data.add(n)
      data.add("```\n")
      data.add("____\n")
      data.add("\n")


  # Const
  if includeConst and codeConst.data.len() > 0:
    data.add("# Const\n")
    for i in codeConst.data:
      if onlyGlobals:
        if not i.global: continue

      if includeHeadings:
        data.add("## " & i.heading & "\n")
      data.add("```nim")
      data.add(i.code)
      data.add("```\n")
      for n in split(i.comment, "\n"):
        data.add(n)
      data.add("____\n")
      data.add("\n")


  # Let
  if includeLet and codeLet.data.len() > 0:
    data.add("# Let\n")
    for i in codeLet.data:
      if onlyGlobals:
        if not i.global: continue

      if includeHeadings:
        data.add("## " & i.heading & "\n")
      data.add("```nim")
      data.add(i.code)
      data.add("```\n")
      for n in split(i.comment, "\n"):
        data.add(n)
      data.add("____\n")
      data.add("\n")


  # Var
  if includeVar and codeVar.data.len() > 0:
    data.add("# Var\n")
    for i in codeVar.data:
      if onlyGlobals:
        if not i.global: continue

      if includeHeadings:
        data.add("## " & i.heading & "\n")
      data.add("```nim")
      data.add(i.code)
      data.add("```\n")
      for n in split(i.comment, "\n"):
        data.add(n)
      data.add("____\n")
      data.add("\n")


  # Procs
  if codeProc.data.len() > 0:
    data.add("# Procs\n")
    for i in codeProc.data:
      if onlyGlobals:
        if not i.global: continue

      if includeHeadings:
        data.add("## " & i.heading & "\n")
      data.add("```nim")
      data.add(i.code)
      data.add("```\n")
      if includeLines:
        data.add("Line: " & $i.line & "\n")
      data.add(i.comment)
      data.add("\n")
      if i.runnable != "":
        #data.add("__Runnable example:__")
        data.add("```nim")
        for r in i.runnable.split("\n"):
          data.add(r.substr(2, r.len()))
        data.add("```\n")
      data.add("____\n")


  # Templates
  if codeTemplate.data.len() > 0:
    data.add("# Templates\n")
    for i in codeTemplate.data:
      if onlyGlobals:
        if not i.global: continue

      if includeHeadings:
        data.add("## " & i.heading & "\n")
      data.add("```nim")
      data.add(i.code)
      data.add("```\n")
      if includeLines:
        data.add("Line: " & $i.line & "\n")
      data.add(i.comment)
      data.add("\n")
      if i.runnable != "":
        #data.add("__Runnable example:__")
        data.add("```nim")
        for r in i.runnable.split("\n"):
          data.add(r.substr(2, r.len()))
        data.add("```\n")
      data.add("____\n")


  # Macros
  if codeMacro.data.len() > 0:
    data.add("# Macros\n")
    for i in codeMacro.data:
      if onlyGlobals:
        if not i.global: continue

      if includeHeadings:
        data.add("## " & i.heading & "\n")
      data.add("```nim")
      data.add(i.code)
      data.add("```\n")
      if includeLines:
        data.add("Line: " & $i.line & "\n")
      data.add(i.comment)
      data.add("\n")
      if i.runnable != "":
        #data.add("__Runnable example:__")
        data.add("```nim")
        for r in i.runnable.split("\n"):
          data.add(r.substr(2, r.len()))
        data.add("```\n")
      data.add("____\n")


  # Func
  if codeFunc.data.len() > 0:
    data.add("# Funcs\n")
    for i in codeFunc.data:
      if onlyGlobals:
        if not i.global: continue

      if includeHeadings:
        data.add("## " & i.heading & "\n")
      data.add("```nim")
      data.add(i.code)
      data.add("```\n")
      if includeLines:
        data.add("Line: " & $i.line & "\n")
      data.add(i.comment)
      data.add("\n")
      if i.runnable != "":
        #data.add("__Runnable example:__")
        data.add("```nim")
        for r in i.runnable.split("\n"):
          data.add(r.substr(2, r.len()))
        data.add("```\n")
      data.add("____\n")


  # Iterator
  if codeIterator.data.len() > 0:
    data.add("# Iterators\n")
    for i in codeIterator.data:
      if onlyGlobals:
        if not i.global: continue

      if includeHeadings:
        data.add("## " & i.heading & "\n")
      data.add("```nim")
      data.add(i.code)
      data.add("```\n")
      if includeLines:
        data.add("Line: " & $i.line & "\n")
      data.add(i.comment)
      data.add("\n")
      if i.runnable != "":
        #data.add("__Runnable example:__")
        data.add("```nim")
        for r in i.runnable.split("\n"):
          data.add(r.substr(2, r.len()))
        data.add("```\n")
      data.add("____\n")


  return data


proc markdownToFile(filename: string, data: seq[string]) =
  ## Save markdown to file
  var markdown: string
  for md in data:
    markdown.add(md & "\n")

  try:
    writeFile(filename, markdown)
    styledWriteLine(stderr, fgGreen, "OK: ", resetStyle, "Markdown written in: " & filename)
  except:
    styledWriteLine(stderr, fgRed, "ERROR: ", resetStyle, "Could not write markdown to file: " & filename)



proc markdownShow(markdown: seq[string]) =
  ## Show markdown
  if markdown.len() == 0:
    styledWriteLine(stderr, fgYellow, "WARNING: ", resetStyle, "No markdown was generated.")
  else:
    for line in markdown:
      echo line


proc parseNim(filename: string, onlyGlobals=false, includeHeadings=true, includeImport=true, includeTypes=true, includeLines=false, includeConst=false, includeLet=false, includeVar=false): seq[string] =
  ## Loop through file and generate Markdown.
  ##
  ## We are reading the number of lines, which will help us to jump back and
  ## forward with more control, than if we just did *for lines in file*.

  # Read file
  let file = readFile(filename).split("\n")
  let lines = file.len()

  styledWriteLine(stderr, fgGreen, "OK: ", resetStyle, "Read file: " & filename)
  styledWriteLine(stderr, fgGreen, "OK: ", resetStyle, "Lines to parse: " & $lines)

  # Loop through all lines
  for lineNr in countup(0, lines-1):
    if forceNewLine:
      if lineNr < lineForce:
        continue
      else:
        forceNewLine = false

    parseLine(lineNr, file)

  # Generate markdown
  return generateMarkdown(onlyGlobals, includeHeadings, includeImport, includeTypes, includeLines, includeConst, includeLet, includeVar)


const help = """

nimtomd converts a Nim files into markdown

Usage:
  nimtomd [options] <filename>

Options:
  <filename>                Nim-file to convert into markdown
  -h,  --help               Shows the help menu
  -o:, --output:[filename]  Outputs the markdown to a file
  -ow, --overwrite          Allow to overwrite a existing md file
  -g,  --onlyglobals        Only include global elements (*)
  -sh                       Skip headings
  -si                       Skip imports
  -st                       Skip types
  -il, --includelines       Include linenumbers
  -ic, --includeconst       Include const
  -il, --includelet         Include let
  -iv, --includevar         Include var
"""

when isMainModule:
  let time1 = epochTime()

  let args = multiReplace(commandLineParams().join(","), [("-", ""), (" ", "")])
  case args
  of "", " ", "h", "help":
    echo help

  else:
    var
      outputFile  = ""
      overwrite           = false
      argOnlyGlobals      = false
      argIncludeHeadings  = true
      argIncludeImport    = true
      argIncludeTypes     = true
      argIncludeLines     = false
      argIncludeConst     = false
      argIncludeLet       = false
      argIncludeVar       = false

    let
      argsSplit = args.split(",")

    # Go through args
    for arg in argsSplit:
      if arg.contains("o:"):
        outputFile = arg.substr(2, arg.len())
      elif arg.contains("output:"):
        outputFile = arg.substr(7, arg.len())
      elif arg == "ow" or arg == "overwrite":
        overwrite = true
      elif arg == "onlyglobals" or arg == "g":
        argOnlyGlobals = true
      elif arg == "skipheading" or arg == "sh":
        argIncludeHeadings = false
      elif arg == "skipimports" or arg == "si":
        argIncludeImport = false
      elif arg == "skiptypes" or arg == "st":
        argIncludeTypes = false
      elif arg == "includelines" or arg == "il":
        argIncludeLines = true
      elif arg == "includeconst" or arg == "ic":
        argIncludeConst = true
      elif arg == "includelet" or arg == "il":
        argIncludeLet = true
      elif arg == "includevar" or arg == "iv":
        argIncludeVar = true

    # Check if file with code exists
    if not fileExists(argsSplit[argsSplit.len() - 1]):
      styledWriteLine(stderr, fgRed, "ERROR: ", resetStyle, "File not found: " & argsSplit[argsSplit.len() - 1])
      quit(0)

    # Check if we are going to write the markdown to a file. Then also check if
    # the file already exists- then the -ow arg needs to be specificed.
    if outputFile != "" and fileExists(outputFile) and not overwrite:
      styledWriteLine(stderr, fgYellow, "WARNING: ", resetStyle, "Output file already exists. Specify -ow to overwrite it.")
      quit(0)

    # Generate markdown
    let markdown = parseNim(argsSplit[argsSplit.len() - 1], onlyGlobals=argOnlyGlobals, includeHeadings=argIncludeHeadings, includeImport=argIncludeImport, includeTypes=argIncludeTypes, includeLines=argIncludeLines, includeConst=argIncludeConst, includeLet=argIncludeLet, includeVar=argIncludeVar)

    if markdown.len() == 0:
      styledWriteLine(stderr, fgYellow, "WARNING: ", resetStyle, "No markdown was generated.")
      quit(0)

    # Output markdown
    if outputFile.len() != 0:
      markdownToFile(outputFile, markdown)
    else:
      markdownShow(markdown)

    let time2 = epochTime()
    styledWriteLine(stderr, fgGreen, "OK: ", resetStyle, "Time used: " & $(time2 - time1) & " seconds")

