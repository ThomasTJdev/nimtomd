## Nim to Markdown

*Generated with [Nim to Markdown](https://github.com/ThomasTJdev/nimtomd)*

This Nim package converts Nim code to Markdown. Use `nimtomd`
on your Nim file and transform it into a styled Markdown file.

You can choose to only include global elements (*) and top
comments, or you can include everything.

# Usage:
```nim
nimtomd [options] <filename>
```

# Options:
```nim
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
```


## Requirements

Your code needs to follow the Nim coding style. Checkout the
source file for examples.


## Examples

This README.md is made with ``nimtomd`` with the command:
```nim
nimtomd -o:README.md -ow -g nimtomd.nim
```

# Output to screen

This prints the Markdown output to the screen:
```nim
nimtomd filename.nim
```

# Save output to file

You can force ``nimtomd`` to overwrite an existing file
by using the option ``-ow``.

```nim
nimtomd -o:README.md -ow filename.nim
```
