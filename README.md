*# Copyright 2018 - Thomas T. Jarløv*

# Nim to Markdown

*Generated with [Nim to Markdown](https://github.com/ThomasTJdev/nimtomd)*

This Nim package converts Nim code to Markdown. Use `nimtomd`
on your Nim file and transform it into a styled Markdown file.

You can choose to only include global elements (*) and top
comments, or you can include everything.

The package is *hybrid* which means, it can run as binary
but also be imported into your project.

## Usage:
```
 nimtomd [options] <filename>
```


## Options:
```
 filename.nim    File to output in Markdown
 -h, --help                Shows the help menu
 -o:, --output:[filename]  Outputs the markdown to a file
 -ow, --overwrite          Allow to overwrite a existing md file
 -g, --global              Only include global elements (*)
```


# Requirements

Your code needs to follow the Nim commenting style. Checkout the
source file for examples.


# Examples

This README.md is made with ``nimtomd`` with the command:
```
 nimtomd -o:README.md -ow -global nimtomd.nim
```


## Output to screen

This prints the Markdown output to the screen:
```
 nimtomd filename.nim
```


## Save output to file

You can force ``nimtomd`` to overwrite an existing file
by using the option ``-ow``.

```
 nimtomd -o:README.md filename.nim
```


## Import nimtomd

When importing nimtomd to your project, you can pass
Nim code as a string or by pointing to a file.

You can get the Markdown in either a seq[string] or string.
The proc's are documented in the "Types -> Proc's" section.
loop through.

**Parse file**
```nim
 import nimtomd
 let md = parseNimFileSeq("filename.nim")
 for line in md:
   echo line
```


 **Parse string**
```nim
 import nimtomd
 let myNimCode = """
   proc special*(data: string): string =
     ## Special proc
     echo data
     return "Amen"
 """

 let md = parseNimContentString(myNimCode)
 for line in md.split("\n"):
   echo line
```

# Types
## Procs
### proc parseNimFileString*
```nim
proc parseNimFileString*(filename: string): string =
```
Loop through file and generate Markdown to string
### proc parseNimFileSeq*
```nim
proc parseNimFileSeq*(filename: string): seq[string] =
```
Loop through file and generate Markdown to seq[string]
### proc parseNimContentString*
```nim
proc parseNimContentString*(content: string): string =
```
Loop through string and generate Markdown to string
### proc parseNimContentSeq*
```nim
proc parseNimContentSeq*(content: string): seq[string] =
```
Loop through string and generate Markdown to seq[string]
