*# Copyright 2018 - Thomas T. Jarløv*

# Nim to Markdown

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
 help            Shows the help menu
 -o:[filename]   Outputs the markdown to a file
 -ow             Overwrites a file when -o is used
 -global         Only include global element (*)
```


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

Both ``proc's`` will return a ``seq[string]`` which you can
loop through.

**Parse file**
```nim
 import nimtomd
 parseNimFile("filename.nim")
 for line in markdown:
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

 parseNimString(myNimCode)
 for line in markdown:
   echo line
```

# Types


### proc parseNimFile*
```nim
proc parseNimFile*(filename: string): seq[string] =
```
Loop through file and generate Markdown

### proc parseNimString*
```nim
proc parseNimString*(content: string): seq[string] =
```
Loop through string and generate Markdown
