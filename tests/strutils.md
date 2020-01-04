The system module defines several common functions for working with strings,
such as:
* ``$`` for converting other data-types to strings
* ``&`` for string concatenation
* ``add`` for adding a new character or a string to the existing one
* ``in`` (alias for ``contains``) and ``notin`` for checking if a character
is in a string

This module builds upon that, providing additional functionality in form of
procedures, iterators and templates for strings.

```nim
import strutils

let
numbers = @[867, 5309]
multiLineString = "first line\nsecond line\nthird line"

let jenny = numbers.join("-")
assert jenny == "867-5309"

assert splitLines(multiLineString) ==
@["first line", "second line", "third line"]
assert split(multiLineString) == @["first", "line", "second",
"line", "third", "line"]
assert indent(multiLineString, 4) ==
"    first line\n    second line\n    third line"
assert 'z'.repeat(5) == "zzzzz"
```

The chaining of functions is possible thanks to the
`method call syntax<manual.htmlprocedures-method-call-syntax>`_:

```nim
import strutils
from sequtils import map

let jenny = "867-5309"
assert jenny.split('-').map(parseInt) == @[867, 5309]

assert "Beetlejuice".indent(1).repeat(3).strip ==
"Beetlejuice Beetlejuice Beetlejuice"
```

This module is available for the `JavaScript target
<backends.htmlbackends-the-javascript-target>`_.
## 

**See also:**
* `strformat module<strformat.html>`_ for string interpolation and formatting
* `unicode module<unicode.html>`_ for Unicode UTF-8 handling
* `sequtils module<sequtils.html>`_ for operations on container
types (including strings)
* `parseutils module<parseutils.html>`_ for lower-level parsing of tokens,
numbers, identifiers, etc.
* `parseopt module<parseopt.html>`_ for command-line parsing
* `strtabs module<strtabs.html>`_ for efficient hash tables
(dictionaries, in some programming languages) mapping from strings to strings
* `pegs module<pegs.html>`_ for PEG (Parsing Expression Grammar) support
* `ropes module<ropes.html>`_ for rope data type, which can represent very
long strings efficiently
* `re module<re.html>`_ for regular expression (regex) support
* `strscans<strscans.html>`_ for ``scanf`` and ``scanp`` macros, which offer
easier substring extraction than regular expressions
# Imports

* parseutils


* from algorithm import reverse
* from math import pow, floor, log10


# Types

## SkipTable* = array[char, int]


```nim
  SkipTable* = array[char, int]
```

____



## FloatFormatMode* = enum

 the different modes of floating point formatting

* __ffDefault,__: use the shorter floating point notation

* __ffDecimal,__: use decimal floating point notation

* __ffScientific__: use scientific notation (using ``e`` character)
```nim
  FloatFormatMode* = enum
    ffDefault,   
    ffDecimal,   
    ffScientific 
```

____



## BinaryPrefixMode* = enum

the different names for binary prefixes
```nim
  BinaryPrefixMode* = enum
    bpIEC,                
    bpColloquial          
```

____



# Procs

## isAlphaAscii*

```nim
proc isAlphaAscii*(c: char): bool {.noSideEffect, procvar, rtl, extern: "nsuIsAlphaAsciiChar".} =
```

Checks whether or not character `c` is alphabetical. 

 This checks a-z, A-Z ASCII characters only. Use Unicode module [(link)](https://nim-lang.org/docs/unicode.html) for UTF-8 support.


```nim
runnableExamples:
  doAssert isAlphaAscii('e') == true
  doAssert isAlphaAscii('E') == true
  doAssert isAlphaAscii('8') == false
```

____

## isAlphaNumeric*

```nim
proc isAlphaNumeric*(c: char): bool {.noSideEffect, procvar, rtl, extern: "nsuIsAlphaNumericChar".} =
```

Checks whether or not `c` is alphanumeric. 

 This checks a-z, A-Z, 0-9 ASCII characters only.


```nim
runnableExamples:
  doAssert isAlphaNumeric('n') == true
  doAssert isAlphaNumeric('8') == true
  doAssert isAlphaNumeric(' ') == false
```

____

## isDigit*

```nim
proc isDigit*(c: char): bool {.noSideEffect, procvar, rtl, extern: "nsuIsDigitChar".} =
```

Checks whether or not `c` is a number. 

 This checks 0-9 ASCII characters only.


```nim
runnableExamples:
  doAssert isDigit('n') == false
  doAssert isDigit('8') == true
```

____

## isSpaceAscii*

```nim
proc isSpaceAscii*(c: char): bool {.noSideEffect, procvar, rtl, extern: "nsuIsSpaceAsciiChar".} =
```

Checks whether or not `c` is a whitespace character.


```nim
runnableExamples:
  doAssert isSpaceAscii('n') == false
  doAssert isSpaceAscii(' ') == true
  doAssert isSpaceAscii('\t') == true
```

____

## isLowerAscii*

```nim
proc isLowerAscii*(c: char): bool {.noSideEffect, procvar, rtl, extern: "nsuIsLowerAsciiChar".} =
```

Checks whether or not `c` is a lower case character. 

 This checks ASCII characters only. Use Unicode module [(link)](https://nim-lang.org/docs/unicode.html) for UTF-8 support. 

 

See also: 
* `toLowerAscii proc<#toLowerAscii,char>`_


```nim
runnableExamples:
  doAssert isLowerAscii('e') == true
  doAssert isLowerAscii('E') == false
  doAssert isLowerAscii('7') == false
```

____

## isUpperAscii*

```nim
proc isUpperAscii*(c: char): bool {.noSideEffect, procvar, rtl, extern: "nsuIsUpperAsciiChar".} =
```

Checks whether or not `c` is an upper case character. 

 This checks ASCII characters only. Use Unicode module [(link)](https://nim-lang.org/docs/unicode.html) for UTF-8 support. 

 

See also: 
* `toUpperAscii proc<#toUpperAscii,char>`_


```nim
runnableExamples:
  doAssert isUpperAscii('e') == false
  doAssert isUpperAscii('E') == true
  doAssert isUpperAscii('7') == false
```

____

## toLowerAscii*

```nim
proc toLowerAscii*(c: char): char {.noSideEffect, procvar, rtl, extern: "nsuToLowerAsciiChar".} =
```

Returns the lower case version of character ``c``. 

 This works only for the letters ``A-Z``. See `unicode.toLower <unicode.html#toLower,Rune>`_ for a version that works for any Unicode character. 

 

See also: 
* `isLowerAscii proc<#isLowerAscii,char>`_ 
* `toLowerAscii proc<#toLowerAscii,string>`_ for converting a string


```nim
runnableExamples:
  doAssert toLowerAscii('A') == 'a'
  doAssert toLowerAscii('e') == 'e'
  result = chr(ord(c) + (ord('a') - ord('A')))
  result = c
```

____

## toLowerAscii*

```nim
proc toLowerAscii*(s: string): string {.noSideEffect, procvar, rtl, extern: "nsuToLowerAsciiStr".} =
```

Converts string `s` into lower case. 

 This works only for the letters ``A-Z``. See `unicode.toLower <unicode.html#toLower,string>`_ for a version that works for any Unicode character. 

 

See also: 
* `normalize proc<#normalize,string>`_


```nim
runnableExamples:
  doAssert toLowerAscii("FooBar!") == "foobar!"
```

____

## toUpperAscii*

```nim
proc toUpperAscii*(c: char): char {.noSideEffect, procvar, rtl, extern: "nsuToUpperAsciiChar".} =
```

Converts character `c` into upper case. 

 This works only for the letters ``A-Z``.  See `unicode.toUpper <unicode.html#toUpper,Rune>`_ for a version that works for any Unicode character. 

 

See also: 
* `isLowerAscii proc<#isLowerAscii,char>`_ 
* `toUpperAscii proc<#toUpperAscii,string>`_ for converting a string 
* `capitalizeAscii proc<#capitalizeAscii,string>`_


```nim
runnableExamples:
  doAssert toUpperAscii('a') == 'A'
  doAssert toUpperAscii('E') == 'E'
  result = chr(ord(c) - (ord('a') - ord('A')))
  result = c
```

____

## toUpperAscii*

```nim
proc toUpperAscii*(s: string): string {.noSideEffect, procvar, rtl, extern: "nsuToUpperAsciiStr".} =
```

Converts string `s` into upper case. 

 This works only for the letters ``A-Z``.  See `unicode.toUpper <unicode.html#toUpper,string>`_ for a version that works for any Unicode character. 

 

See also: 
* `capitalizeAscii proc<#capitalizeAscii,string>`_


```nim
runnableExamples:
  doAssert toUpperAscii("FooBar!") == "FOOBAR!"
```

____

## capitalizeAscii*

```nim
proc capitalizeAscii*(s: string): string {.noSideEffect, procvar, rtl, extern: "nsuCapitalizeAscii".} =
```

Converts the first character of string `s` into upper case. 

 This works only for the letters ``A-Z``. Use Unicode module [(link)](https://nim-lang.org/docs/unicode.html) for UTF-8 support. 

 

See also: 
* `toUpperAscii proc<#toUpperAscii,char>`_


```nim
runnableExamples:
  doAssert capitalizeAscii("foo") == "Foo"
  doAssert capitalizeAscii("-bar") == "-bar"
```

____

## normalize*

```nim
proc normalize*(s: string): string {.noSideEffect, procvar, rtl, extern: "nsuNormalize".} =
```

Normalizes the string `s`. 

 That means to convert it to lower case and remove any '_'. This should NOT be used to normalize Nim identifier names. 

 

See also: 
* `toLowerAscii proc<#toLowerAscii,string>`_


```nim
runnableExamples:
  doAssert normalize("Foo_bar") == "foobar"
  doAssert normalize("Foo Bar") == "foo bar"
  if s[i] in {'A'..'Z'}:
    result[j] = chr(ord(s[i]) + (ord('a') - ord('A')))
    inc j
  elif s[i] != '_':
    result[j] = s[i]
    inc j
```

____

## cmpIgnoreCase*

```nim
proc cmpIgnoreCase*(a, b: string): int {.noSideEffect, rtl, extern: "nsuCmpIgnoreCase", procvar.} =
```

Compares two strings in a case insensitive manner. Returns: 

 | 0 if a == b | < 0 if a < b | > 0 if a > b


```nim
runnableExamples:
  doAssert cmpIgnoreCase("FooBar", "foobar") == 0
  doAssert cmpIgnoreCase("bar", "Foo") < 0
  doAssert cmpIgnoreCase("Foo5", "foo4") > 0
  result = ord(toLowerAscii(a[i])) - ord(toLowerAscii(b[i]))
  if result != 0: return
  inc(i)
```

____

## cmpIgnoreStyle*

```nim
proc cmpIgnoreStyle*(a, b: string): int {.noSideEffect, rtl, extern: "nsuCmpIgnoreStyle", procvar.} =
```

Semantically the same as ``cmp(normalize(a), normalize(b))``. It is just optimized to not allocate temporary strings. This should NOT be used to compare Nim identifier names. Use `macros.eqIdent<macros.html#eqIdent,string,string>`_ for that. 

 Returns: 

 | 0 if a == b | < 0 if a < b | > 0 if a > b


```nim
runnableExamples:
  doAssert cmpIgnoreStyle("foo_bar", "FooBar") == 0
  doAssert cmpIgnoreStyle("foo_bar_5", "FooBar4") > 0
  while i < a.len and a[i] == '_': inc i
  while j < b.len and b[j] == '_': inc j
  var aa = if i < a.len: toLowerAscii(a[i]) else: '\0'
  var bb = if j < b.len: toLowerAscii(b[j]) else: '\0'
  result = ord(aa) - ord(bb)
  if result != 0: return result
  # the characters are identical:
  if i >= a.len:
    # both cursors at the end:
    if j >= b.len: return 0
    # not yet at the end of 'b':
    return -1
  elif j >= b.len:
    return 1
  inc i
  inc j
```

____

## substrEq

```nim
proc substrEq(s: string, pos: int, substr: string): bool =
```




____

## split*

```nim
proc split*(s: string, sep: char, maxsplit: int = -1): seq[string] {.noSideEffect, rtl, extern: "nsuSplitChar".} =
```

The same as the `split iterator <#split.i,string,char,int>`_ (see its documentation), but is a proc that returns a sequence of substrings. 

 

See also: 
* `split iterator <#split.i,string,char,int>`_ 
* `rsplit proc<#rsplit,string,char,int>`_ 
* `splitLines proc<#splitLines,string>`_ 
* `splitWhitespace proc<#splitWhitespace,string,int>`_


```nim
runnableExamples:
  doAssert "a,b,c".split(',') == @["a", "b", "c"]
  doAssert "".split(' ') == @[""]
```

____

## split*

```nim
proc split*(s: string, seps: set[char] = Whitespace, maxsplit: int = -1): seq[string] {. noSideEffect, rtl, extern: "nsuSplitCharSet".} =
```

The same as the `split iterator <#split.i,string,set[char],int>`_ (see its documentation), but is a proc that returns a sequence of substrings. 

 

See also: 
* `split iterator <#split.i,string,set[char],int>`_ 
* `rsplit proc<#rsplit,string,set[char],int>`_ 
* `splitLines proc<#splitLines,string>`_ 
* `splitWhitespace proc<#splitWhitespace,string,int>`_


```nim
runnableExamples:
  doAssert "a,b;c".split({',', ';'}) == @["a", "b", "c"]
  doAssert "".split({' '}) == @[""]
```

____

## split*

```nim
proc split*(s: string, sep: string, maxsplit: int = -1): seq[string] {.noSideEffect, rtl, extern: "nsuSplitString".} =
```

Splits the string `s` into substrings using a string separator. 

 Substrings are separated by the string `sep`. This is a wrapper around the `split iterator <#split.i,string,string,int>`_. 

 

See also: 
* `split iterator <#split.i,string,string,int>`_ 
* `rsplit proc<#rsplit,string,string,int>`_ 
* `splitLines proc<#splitLines,string>`_ 
* `splitWhitespace proc<#splitWhitespace,string,int>`_


```nim
runnableExamples:
  doAssert "a,b,c".split(",") == @["a", "b", "c"]
  doAssert "a man a plan a canal panama".split("a ") == @["", "man ", "plan ", "canal panama"]
  doAssert "".split("Elon Musk") == @[""]
  doAssert "a  largely    spaced sentence".split(" ") == @["a", "", "largely",
      "", "", "", "spaced", "sentence"]
  doAssert "a  largely    spaced sentence".split(" ", maxsplit = 1) == @["a", " largely    spaced sentence"]
```

____

## rsplit*

```nim
proc rsplit*(s: string, sep: char, maxsplit: int = -1): seq[string] {.noSideEffect, rtl, extern: "nsuRSplitChar".} =
```

The same as the `rsplit iterator <#rsplit.i,string,char,int>`_, but is a proc that returns a sequence of substrings. 

 A possible common use case for `rsplit` is path manipulation, particularly on systems that don't use a common delimiter. 

 For example, if a system had `#` as a delimiter, you could do the following to get the tail of the path: 


```nim
 var tailSplit = rsplit("Root#Object#Method#Index", '#', maxsplit=1)
```
 

 Results in `tailSplit` containing: 


```nim
 @["Root#Object#Method", "Index"]
```
 

 

See also: 
* `rsplit iterator <#rsplit.i,string,char,int>`_ 
* `split proc<#split,string,char,int>`_ 
* `splitLines proc<#splitLines,string>`_ 
* `splitWhitespace proc<#splitWhitespace,string,int>`_


____

## rsplit*

```nim
proc rsplit*(s: string, seps: set[char] = Whitespace, {.noSideEffect, rtl, extern: "nsuRSplitCharSet".} =
```

The same as the `rsplit iterator <#rsplit.i,string,set[char],int>`_, but is a proc that returns a sequence of substrings. 

 A possible common use case for `rsplit` is path manipulation, particularly on systems that don't use a common delimiter. 

 For example, if a system had `#` as a delimiter, you could do the following to get the tail of the path: 


```nim
 var tailSplit = rsplit("Root#Object#Method#Index", {'#'}, maxsplit=1)
```
 

 Results in `tailSplit` containing: 


```nim
 @["Root#Object#Method", "Index"]
```
 

 

See also: 
* `rsplit iterator <#rsplit.i,string,set[char],int>`_ 
* `split proc<#split,string,set[char],int>`_ 
* `splitLines proc<#splitLines,string>`_ 
* `splitWhitespace proc<#splitWhitespace,string,int>`_


____

## rsplit*

```nim
proc rsplit*(s: string, sep: string, maxsplit: int = -1): seq[string] {.noSideEffect, rtl, extern: "nsuRSplitString".} =
```

The same as the `rsplit iterator <#rsplit.i,string,string,int,bool>`_, but is a proc that returns a sequence of substrings. 

 A possible common use case for `rsplit` is path manipulation, particularly on systems that don't use a common delimiter. 

 For example, if a system had `#` as a delimiter, you could do the following to get the tail of the path: 


```nim
 var tailSplit = rsplit("Root#Object#Method#Index", "#", maxsplit=1)
```
 

 Results in `tailSplit` containing: 


```nim
 @["Root#Object#Method", "Index"]
```
 

 

See also: 
* `rsplit iterator <#rsplit.i,string,string,int,bool>`_ 
* `split proc<#split,string,string,int>`_ 
* `splitLines proc<#splitLines,string>`_ 
* `splitWhitespace proc<#splitWhitespace,string,int>`_


```nim
runnableExamples:
  doAssert "a  largely    spaced sentence".rsplit(" ", maxsplit = 1) == @[
      "a  largely    spaced", "sentence"]
  doAssert "a,b,c".rsplit(",") == @["a", "b", "c"]
  doAssert "a man a plan a canal panama".rsplit("a ") == @["", "man ",
      "plan ", "canal panama"]
  doAssert "".rsplit("Elon Musk") == @[""]
  doAssert "a  largely    spaced sentence".rsplit(" ") == @["a", "",
      "largely", "", "", "", "spaced", "sentence"]
```

____

## splitLines*

```nim
proc splitLines*(s: string, keepEol = false): seq[string] {.noSideEffect, rtl, extern: "nsuSplitLines".} =
```

The same as the `splitLines iterator<#splitLines.i,string>`_ (see its documentation), but is a proc that returns a sequence of substrings. 

 

See also: 
* `splitLines iterator<#splitLines.i,string>`_ 
* `splitWhitespace proc<#splitWhitespace,string,int>`_ 
* `countLines proc<#countLines,string>`_


____

## splitWhitespace*

```nim
proc splitWhitespace*(s: string, maxsplit: int = -1): seq[string] {.noSideEffect, rtl, extern: "nsuSplitWhitespace".} =
```

The same as the `splitWhitespace iterator <#splitWhitespace.i,string,int>`_ (see its documentation), but is a proc that returns a sequence of substrings. 

 

See also: 
* `splitWhitespace iterator <#splitWhitespace.i,string,int>`_ 
* `splitLines proc<#splitLines,string>`_


____

## toBin*

```nim
proc toBin*(x: BiggestInt, len: Positive): string {.noSideEffect, rtl, extern: "nsuToBin".} =
```

Converts `x` into its binary representation. 

 The resulting string is always `len` characters long. No leading ``0b`` prefix is generated.


```nim
runnableExamples:
  let
    a = 29
    b = 257
  doAssert a.toBin(8) == "00011101"
  doAssert b.toBin(8) == "00000001"
  doAssert b.toBin(9) == "100000001"
  mask = BiggestUInt 1
  shift = BiggestUInt 0
  result[j] = chr(int((BiggestUInt(x) and mask) shr shift) + ord('0'))
  inc shift
  mask = mask shl BiggestUInt(1)
```

____

## toOct*

```nim
proc toOct*(x: BiggestInt, len: Positive): string {.noSideEffect, rtl, extern: "nsuToOct".} =
```

Converts `x` into its octal representation. 

 The resulting string is always `len` characters long. No leading ``0o`` prefix is generated. 

 Do not confuse it with `toOctal proc<#toOctal,char>`_.


```nim
runnableExamples:
  let
    a = 62
    b = 513
  doAssert a.toOct(3) == "076"
  doAssert b.toOct(3) == "001"
  doAssert b.toOct(5) == "01001"
  mask = BiggestUInt 7
  shift = BiggestUInt 0
  result[j] = chr(int((BiggestUInt(x) and mask) shr shift) + ord('0'))
  inc shift, 3
  mask = mask shl BiggestUInt(3)
```

____

## toHex*

```nim
proc toHex*(x: BiggestInt, len: Positive): string {.noSideEffect, rtl, extern: "nsuToHex".} =
```

Converts `x` to its hexadecimal representation. 

 The resulting string will be exactly `len` characters long. No prefix like ``0x`` is generated. `x` is treated as an unsigned value.


```nim
runnableExamples:
  let
    a = 62
    b = 4097
  doAssert a.toHex(3) == "03E"
  doAssert b.toHex(3) == "001"
  doAssert b.toHex(4) == "1001"
  HexChars = "0123456789ABCDEF"
  n = x
  result[j] = HexChars[int(n and 0xF)]
  n = n shr 4
  # handle negative overflow
  if n == 0 and x < 0: n = -1
```

____

## toHex*[T: SomeInteger]

```nim
proc toHex*[T: SomeInteger](x: T): string =
```

Shortcut for ``toHex(x, T.sizeOf * 2)``


```nim
runnableExamples:
  doAssert toHex(1984'i64) == "00000000000007C0"
```

____

## toHex*

```nim
proc toHex*(s: string): string {.noSideEffect, rtl.} =
```

Converts a bytes string to its hexadecimal representation. 

 The output is twice the input long. No prefix like ``0x`` is generated. 

 

See also: 
* `parseHexStr proc<#parseHexStr,string>`_ for the reverse operation


```nim
runnableExamples:
  let
    a = "1"
    b = "A"
    c = "\0\255"
  doAssert a.toHex() == "31"
  doAssert b.toHex() == "41"
  doAssert c.toHex() == "00FF"
```

____

## toOctal*

```nim
proc toOctal*(c: char): string {.noSideEffect, rtl, extern: "nsuToOctal".} =
```

Converts a character `c` to its octal representation. 

 The resulting string may not have a leading zero. Its length is always exactly 3. 

 Do not confuse it with `toOct proc<#toOct,BiggestInt,Positive>`_.


```nim
runnableExamples:
  doAssert toOctal('1') == "061"
  doAssert toOctal('A') == "101"
  doAssert toOctal('a') == "141"
  doAssert toOctal('!') == "041"
```

____

## fromBin*[T: SomeInteger]

```nim
proc fromBin*[T: SomeInteger](s: string): T =
```

Parses a binary integer value from a string `s`. 

 If `s` is not a valid binary integer, `ValueError` is raised. `s` can have one of the following optional prefixes: `0b`, `0B`. Underscores within `s` are ignored. 

 Does not check for overflow. If the value represented by `s` is too big to fit into a return type, only the value of the rightmost binary digits of `s` is returned without producing an error.


```nim
runnableExamples:
  let s = "0b_0100_1000_1000_1000_1110_1110_1001_1001"
  doAssert fromBin[int](s) == 1216933529
  doAssert fromBin[int8](s) == 0b1001_1001'i8
  doAssert fromBin[int8](s) == -103'i8
  doAssert fromBin[uint8](s) == 153
  doAssert s.fromBin[:int16] == 0b1110_1110_1001_1001'i16
  doAssert s.fromBin[:uint64] == 1216933529'u64
```

____

## fromOct*[T: SomeInteger]

```nim
proc fromOct*[T: SomeInteger](s: string): T =
```

Parses an octal integer value from a string `s`. 

 If `s` is not a valid octal integer, `ValueError` is raised. `s` can have one of the following optional prefixes: `0o`, `0O`. Underscores within `s` are ignored. 

 Does not check for overflow. If the value represented by `s` is too big to fit into a return type, only the value of the rightmost octal digits of `s` is returned without producing an error.


```nim
runnableExamples:
  let s = "0o_123_456_777"
  doAssert fromOct[int](s) == 21913087
  doAssert fromOct[int8](s) == 0o377'i8
  doAssert fromOct[int8](s) == -1'i8
  doAssert fromOct[uint8](s) == 255'u8
  doAssert s.fromOct[:int16] == 24063'i16
  doAssert s.fromOct[:uint64] == 21913087'u64
```

____

## fromHex*[T: SomeInteger]

```nim
proc fromHex*[T: SomeInteger](s: string): T =
```

Parses a hex integer value from a string `s`. 

 If `s` is not a valid hex integer, `ValueError` is raised. `s` can have one of the following optional prefixes: `0x`, `0X`, `#`. Underscores within `s` are ignored. 

 Does not check for overflow. If the value represented by `s` is too big to fit into a return type, only the value of the rightmost hex digits of `s` is returned without producing an error.


```nim
runnableExamples:
  let s = "0x_1235_8df6"
  doAssert fromHex[int](s) == 305499638
  doAssert fromHex[int8](s) == 0xf6'i8
  doAssert fromHex[int8](s) == -10'i8
  doAssert fromHex[uint8](s) == 246'u8
  doAssert s.fromHex[:int16] == -29194'i16
  doAssert s.fromHex[:uint64] == 305499638'u64
```

____

## intToStr*

```nim
proc intToStr*(x: int, minchars: Positive = 1): string {.noSideEffect, rtl, extern: "nsuIntToStr".} =
```

Converts `x` to its decimal representation. 

 The resulting string will be minimally `minchars` characters long. This is achieved by adding leading zeros.


```nim
runnableExamples:
  doAssert intToStr(1984) == "1984"
  doAssert intToStr(1984, 6) == "001984"
  result = '0' & result
  result = '-' & result
```

____

## parseInt*

```nim
proc parseInt*(s: string): int {.noSideEffect, procvar, rtl, extern: "nsuParseInt".} =
```

Parses a decimal integer value contained in `s`. 

 If `s` is not a valid integer, `ValueError` is raised.


```nim
runnableExamples:
  doAssert parseInt("-0042") == -42
  raise newException(ValueError, "invalid integer: " & s)
```

____

## parseBiggestInt*

```nim
proc parseBiggestInt*(s: string): BiggestInt {.noSideEffect, procvar, rtl, extern: "nsuParseBiggestInt".} =
```

Parses a decimal integer value contained in `s`. 

 If `s` is not a valid integer, `ValueError` is raised.


____

## parseUInt*

```nim
proc parseUInt*(s: string): uint {.noSideEffect, procvar, rtl, extern: "nsuParseUInt".} =
```

Parses a decimal unsigned integer value contained in `s`. 

 If `s` is not a valid integer, `ValueError` is raised.


____

## parseBiggestUInt*

```nim
proc parseBiggestUInt*(s: string): BiggestUInt {.noSideEffect, procvar, rtl, extern: "nsuParseBiggestUInt".} =
```

Parses a decimal unsigned integer value contained in `s`. 

 If `s` is not a valid integer, `ValueError` is raised.


____

## parseFloat*

```nim
proc parseFloat*(s: string): float {.noSideEffect, procvar, rtl, extern: "nsuParseFloat".} =
```

Parses a decimal floating point value contained in `s`. 

 If `s` is not a valid floating point number, `ValueError` is raised. ``NAN``, ``INF``, ``-INF`` are also supported (case insensitive comparison).


```nim
runnableExamples:
  doAssert parseFloat("3.14") == 3.14
  doAssert parseFloat("inf") == 1.0/0
  raise newException(ValueError, "invalid float: " & s)
```

____

## parseBinInt*

```nim
proc parseBinInt*(s: string): int {.noSideEffect, procvar, rtl, extern: "nsuParseBinInt".} =
```

Parses a binary integer value contained in `s`. 

 If `s` is not a valid binary integer, `ValueError` is raised. `s` can have one of the following optional prefixes: ``0b``, ``0B``. Underscores within `s` are ignored.


```nim
runnableExamples:
  let
    a = "0b11_0101"
    b = "111"
  doAssert a.parseBinInt() == 53
  doAssert b.parseBinInt() == 7
```

____

## parseOctInt*

```nim
proc parseOctInt*(s: string): int {.noSideEffect, rtl, extern: "nsuParseOctInt".} =
```

Parses an octal integer value contained in `s`. 

 If `s` is not a valid oct integer, `ValueError` is raised. `s` can have one of the following optional prefixes: ``0o``, ``0O``.  Underscores within `s` are ignored.


____

## parseHexInt*

```nim
proc parseHexInt*(s: string): int {.noSideEffect, procvar, rtl, extern: "nsuParseHexInt".} =
```

Parses a hexadecimal integer value contained in `s`. 

 If `s` is not a valid hex integer, `ValueError` is raised. `s` can have one of the following optional prefixes: ``0x``, ``0X``, ``#``.  Underscores within `s` are ignored.


____

## generateHexCharToValueMap

```nim
proc generateHexCharToValueMap(): string = let o =
```

Generate a string to map a hex digit to uint value


____

## parseHexStr*

```nim
proc parseHexStr*(s: string): string {.noSideEffect, procvar, rtl, extern: "nsuParseHexStr".} =
```

Convert hex-encoded string to byte string, e.g.: 

 Raises ``ValueError`` for an invalid hex values. The comparison is case-insensitive. 

 

See also: 
* `toHex proc<#toHex,string>`_ for the reverse operation


```nim
runnableExamples:
  let
    a = "41"
    b = "3161"
    c = "00ff"
  doAssert parseHexStr(a) == "A"
  doAssert parseHexStr(b) == "1a"
  doAssert parseHexStr(c) == "\0\255"
```

____

## parseBool*

```nim
proc parseBool*(s: string): bool =
```

Parses a value into a `bool`. 

 If ``s`` is one of the following values: ``y, yes, true, 1, on``, then returns `true`. If ``s`` is one of the following values: ``n, no, false, 0, off``, then returns `false`.  If ``s`` is something else a ``ValueError`` exception is raised.


```nim
runnableExamples:
  let a = "n"
  doAssert parseBool(a) == false
```

____

## parseEnum*[T: enum]

```nim
proc parseEnum*[T: enum](s: string): T =
```

Parses an enum ``T``. 

 Raises ``ValueError`` for an invalid value in `s`. The comparison is done in a style insensitive way.


```nim
runnableExamples:
  type
    MyEnum = enum
      first = "1st",
      second,
      third = "3rd"
```

____

## parseEnum*[T: enum]

```nim
proc parseEnum*[T: enum](s: string, default: T): T =
```

Parses an enum ``T``. 

 Uses `default` for an invalid value in `s`. The comparison is done in a style insensitive way.


```nim
runnableExamples:
  type
    MyEnum = enum
      first = "1st",
      second,
      third = "3rd"
```

____

## repeat*

```nim
proc repeat*(c: char, count: Natural): string {.noSideEffect, rtl, extern: "nsuRepeatChar".} =
```

Returns a string of length `count` consisting only of the character `c`.


```nim
runnableExamples:
  let a = 'z'
  doAssert a.repeat(5) == "zzzzz"
```

____

## repeat*

```nim
proc repeat*(s: string, n: Natural): string {.noSideEffect, rtl, extern: "nsuRepeatStr".} =
```

Returns string `s` concatenated `n` times.


```nim
runnableExamples:
  doAssert "+ foo +".repeat(3) == "+ foo ++ foo ++ foo +"
```

____

## spaces*

```nim
proc spaces*(n: Natural): string {.inline.} =
```

Returns a string with `n` space characters. You can use this proc to left align strings. 

 

See also: 
* `align proc<#align,string,Natural,char>`_ 
* `alignLeft proc<#alignLeft,string,Natural,char>`_ 
* `indent proc<#indent,string,Natural,string>`_ 
* `center proc<#center,string,int,char>`_


```nim
runnableExamples:
  let
    width = 15
    text1 = "Hello user!"
    text2 = "This is a very long string"
  doAssert text1 & spaces(max(0, width - text1.len)) & "|" ==
           "Hello user!    |"
  doAssert text2 & spaces(max(0, width - text2.len)) & "|" ==
           "This is a very long string|"
```

____

## align*

```nim
proc align*(s: string, count: Natural, padding = ' '): string {. noSideEffect, rtl, extern: "nsuAlignString".} =
```

Aligns a string `s` with `padding`, so that it is of length `count`. 

 `padding` characters (by default spaces) are added before `s` resulting in right alignment. If ``s.len >= count``, no spaces are added and `s` is returned unchanged. If you need to left align a string use the `alignLeft proc <#alignLeft,string,Natural,char>`_. 

 

See also: 
* `alignLeft proc<#alignLeft,string,Natural,char>`_ 
* `spaces proc<#spaces,Natural>`_ 
* `indent proc<#indent,string,Natural,string>`_ 
* `center proc<#center,string,int,char>`_


```nim
runnableExamples:
  assert align("abc", 4) == " abc"
  assert align("a", 0) == "a"
  assert align("1232", 6) == "  1232"
  assert align("1232", 6, '#') == "##1232"
  result = newString(count)
  let spaces = count - s.len
  for i in 0..spaces-1: result[i] = padding
  for i in spaces..count-1: result[i] = s[i-spaces]
  result = s
```

____

## alignLeft*

```nim
proc alignLeft*(s: string, count: Natural, padding = ' '): string {. noSideEffect.} =
```

Left-Aligns a string `s` with `padding`, so that it is of length `count`. 

 `padding` characters (by default spaces) are added after `s` resulting in left alignment. If ``s.len >= count``, no spaces are added and `s` is returned unchanged. If you need to right align a string use the `align proc <#align,string,Natural,char>`_. 

 

See also: 
* `align proc<#align,string,Natural,char>`_ 
* `spaces proc<#spaces,Natural>`_ 
* `indent proc<#indent,string,Natural,string>`_ 
* `center proc<#center,string,int,char>`_


```nim
runnableExamples:
  assert alignLeft("abc", 4) == "abc "
  assert alignLeft("a", 0) == "a"
  assert alignLeft("1232", 6) == "1232  "
  assert alignLeft("1232", 6, '#') == "1232##"
  result = newString(count)
  if s.len > 0:
    result[0 .. (s.len - 1)] = s
  for i in s.len ..< count:
    result[i] = padding
  result = s
```

____

## center*

```nim
proc center*(s: string, width: int, fillChar: char = ' '): string {. noSideEffect, rtl, extern: "nsuCenterString".} =
```

Return the contents of `s` centered in a string `width` long using `fillChar` (default: space) as padding. 

 The original string is returned if `width` is less than or equal to `s.len`. 

 

See also: 
* `align proc<#align,string,Natural,char>`_ 
* `alignLeft proc<#alignLeft,string,Natural,char>`_ 
* `spaces proc<#spaces,Natural>`_ 
* `indent proc<#indent,string,Natural,string>`_


```nim
runnableExamples:
  let a = "foo"
  doAssert a.center(2) == "foo"
  doAssert a.center(5) == " foo "
  doAssert a.center(6) == " foo  "
  charsLeft = (width - s.len)
  leftPadding = charsLeft div 2
  if i >= leftPadding and i < leftPadding + s.len:
    # we are where the string should be located
    result[i] = s[i-leftPadding]
  else:
    # we are either before or after where
    # the string s should go
    result[i] = fillChar
```

____

## indent*

```nim
proc indent*(s: string, count: Natural, padding: string = " "): string {.noSideEffect, rtl, extern: "nsuIndent".} =
```

Indents each line in ``s`` by ``count`` amount of ``padding``. 

 
**Note:** This does not preserve the new line characters used in ``s``. 

 

See also: 
* `align proc<#align,string,Natural,char>`_ 
* `alignLeft proc<#alignLeft,string,Natural,char>`_ 
* `spaces proc<#spaces,Natural>`_ 
* `unindent proc<#unindent,string,Natural,string>`_


```nim
runnableExamples:
  doAssert indent("First line\c\l and second line.", 2) ==
           "  First line\l   and second line."
  if i != 0:
    result.add("\n")
  for j in 1..count:
    result.add(padding)
  result.add(line)
  i.inc
```

____

## unindent*

```nim
proc unindent*(s: string, count: Natural, padding: string = " "): string {.noSideEffect, rtl, extern: "nsuUnindent".} =
```

Unindents each line in ``s`` by ``count`` amount of ``padding``. Sometimes called `dedent`:idx: 

 
**Note:** This does not preserve the new line characters used in ``s``. 

 

See also: 
* `align proc<#align,string,Natural,char>`_ 
* `alignLeft proc<#alignLeft,string,Natural,char>`_ 
* `spaces proc<#spaces,Natural>`_ 
* `indent proc<#indent,string,Natural,string>`_


```nim
runnableExamples:
  doAssert unindent("  First line\l   and second line", 3) ==
           "First line\land second line"
  if i != 0:
    result.add("\n")
  var indentCount = 0
  for j in 0..<count.int:
    indentCount.inc
    if j + padding.len-1 >= line.len or line[j .. j + padding.len-1] != padding:
      indentCount = j
      break
  result.add(line[indentCount*padding.len .. ^1])
  i.inc
```

____

## unindent*

```nim
proc unindent*(s: string): string {.noSideEffect, rtl, extern: "nsuUnindentAll".} =
```

Removes all indentation composed of whitespace from each line in ``s``. 

 

See also: 
* `align proc<#align,string,Natural,char>`_ 
* `alignLeft proc<#alignLeft,string,Natural,char>`_ 
* `spaces proc<#spaces,Natural>`_ 
* `indent proc<#indent,string,Natural,string>`_


```nim
runnableExamples:
  let x = """
    Hello
    There
  """.unindent()
```

____

## delete*

```nim
proc delete*(s: var string, first, last: int) {.noSideEffect, rtl, extern: "nsuDelete".} =
```

Deletes in `s` (must be declared as ``var``) the characters at positions ``first ..last`` (both ends included). 

 This modifies `s` itself, it does not return a copy.


```nim
runnableExamples:
  var a = "abracadabra"
```

____

## startsWith*

```nim
proc startsWith*(s: string, prefix: char): bool {.noSideEffect, inline.} =
```

Returns true if ``s`` starts with character ``prefix``. 

 

See also: 
* `endsWith proc<#endsWith,string,char>`_ 
* `continuesWith proc<#continuesWith,string,string,Natural>`_ 
* `removePrefix proc<#removePrefix,string,char>`_


```nim
runnableExamples:
  let a = "abracadabra"
  doAssert a.startsWith('a') == true
  doAssert a.startsWith('b') == false
```

____

## startsWith*

```nim
proc startsWith*(s, prefix: string): bool {.noSideEffect, rtl, extern: "nsuStartsWith".} =
```

Returns true if ``s`` starts with string ``prefix``. 

 If ``prefix == ""`` true is returned. 

 

See also: 
* `endsWith proc<#endsWith,string,string>`_ 
* `continuesWith proc<#continuesWith,string,string,Natural>`_ 
* `removePrefix proc<#removePrefix,string,string>`_


```nim
runnableExamples:
  let a = "abracadabra"
  doAssert a.startsWith("abra") == true
  doAssert a.startsWith("bra") == false
  if i >= prefix.len: return true
  if i >= s.len or s[i] != prefix[i]: return false
  inc(i)
```

____

## endsWith*

```nim
proc endsWith*(s: string, suffix: char): bool {.noSideEffect, inline.} =
```

Returns true if ``s`` ends with ``suffix``. 

 

See also: 
* `startsWith proc<#startsWith,string,char>`_ 
* `continuesWith proc<#continuesWith,string,string,Natural>`_ 
* `removeSuffix proc<#removeSuffix,string,char>`_


```nim
runnableExamples:
  let a = "abracadabra"
  doAssert a.endsWith('a') == true
  doAssert a.endsWith('b') == false
```

____

## endsWith*

```nim
proc endsWith*(s, suffix: string): bool {.noSideEffect, rtl, extern: "nsuEndsWith".} =
```

Returns true if ``s`` ends with ``suffix``. 

 If ``suffix == ""`` true is returned. 

 

See also: 
* `startsWith proc<#startsWith,string,string>`_ 
* `continuesWith proc<#continuesWith,string,string,Natural>`_ 
* `removeSuffix proc<#removeSuffix,string,string>`_


```nim
runnableExamples:
  let a = "abracadabra"
  doAssert a.endsWith("abra") == true
  doAssert a.endsWith("dab") == false
  if s[i+j] != suffix[i]: return false
  inc(i)
```

____

## continuesWith*

```nim
proc continuesWith*(s, substr: string, start: Natural): bool {.noSideEffect, rtl, extern: "nsuContinuesWith".} =
```

Returns true if ``s`` continues with ``substr`` at position ``start``. 

 If ``substr == ""`` true is returned. 

 

See also: 
* `startsWith proc<#startsWith,string,string>`_ 
* `endsWith proc<#endsWith,string,string>`_


```nim
runnableExamples:
  let a = "abracadabra"
  doAssert a.continuesWith("ca", 4) == true
  doAssert a.continuesWith("ca", 5) == false
  doAssert a.continuesWith("dab", 6) == true
  if i >= substr.len: return true
  if i+start >= s.len or s[i+start] != substr[i]: return false
  inc(i)
```

____

## removePrefix*

```nim
proc removePrefix*(s: var string, chars: set[char] = Newlines) {. rtl, extern: "nsuRemovePrefixCharSet".} =
```

Removes all characters from `chars` from the start of the string `s` (in-place). 

 

See also: 
* `removeSuffix proc<#removeSuffix,string,set[char]>`_


```nim
runnableExamples:
  var userInput = "\r\n*~Hello World!"
  userInput.removePrefix
  doAssert userInput == "*~Hello World!"
  userInput.removePrefix({'~', '*'})
  doAssert userInput == "Hello World!"
```

____

## removePrefix*

```nim
proc removePrefix*(s: var string, c: char) {. rtl, extern: "nsuRemovePrefixChar".} =
```

Removes all occurrences of a single character (in-place) from the start of a string. 

 

See also: 
* `removeSuffix proc<#removeSuffix,string,char>`_ 
* `startsWith proc<#startsWith,string,char>`_


```nim
runnableExamples:
  var ident = "pControl"
  ident.removePrefix('p')
  doAssert ident == "Control"
```

____

## removePrefix*

```nim
proc removePrefix*(s: var string, prefix: string) {. rtl, extern: "nsuRemovePrefixString".} =
```

Remove the first matching prefix (in-place) from a string. 

 

See also: 
* `removeSuffix proc<#removeSuffix,string,string>`_ 
* `startsWith proc<#startsWith,string,string>`_


```nim
runnableExamples:
  var answers = "yesyes"
  answers.removePrefix("yes")
  doAssert answers == "yes"
  s.delete(0, prefix.len - 1)
```

____

## removeSuffix*

```nim
proc removeSuffix*(s: var string, chars: set[char] = Newlines) {. rtl, extern: "nsuRemoveSuffixCharSet".} =
```

Removes all characters from `chars` from the end of the string `s` (in-place). 

 

See also: 
* `removePrefix proc<#removePrefix,string,set[char]>`_


```nim
runnableExamples:
  var userInput = "Hello World!*~\r\n"
  userInput.removeSuffix
  doAssert userInput == "Hello World!*~"
  userInput.removeSuffix({'~', '*'})
  doAssert userInput == "Hello World!"
```

____

## removeSuffix*

```nim
proc removeSuffix*(s: var string, c: char) {. rtl, extern: "nsuRemoveSuffixChar".} =
```

Removes all occurrences of a single character (in-place) from the end of a string. 

 

See also: 
* `removePrefix proc<#removePrefix,string,char>`_ 
* `endsWith proc<#endsWith,string,char>`_


```nim
runnableExamples:
  var table = "users"
  table.removeSuffix('s')
  doAssert table == "user"
```

____

## removeSuffix*

```nim
proc removeSuffix*(s: var string, suffix: string) {. rtl, extern: "nsuRemoveSuffixString".} =
```

Remove the first matching suffix (in-place) from a string. 

 

See also: 
* `removePrefix proc<#removePrefix,string,string>`_ 
* `endsWith proc<#endsWith,string,string>`_


```nim
runnableExamples:
  var answers = "yeses"
  answers.removeSuffix("es")
  doAssert answers == "yes"
  newLen -= len(suffix)
  s.setLen(newLen)
```

____

## addSep*

```nim
proc addSep*(dest: var string, sep = ", ", startLen: Natural = 0) {.noSideEffect, inline.} =
```

Adds a separator to `dest` only if its length is bigger than `startLen`. 

 A shorthand for: 


```nim
 if dest.len > startLen: add(dest, sep)
```
 

 This is often useful for generating some code where the items need to be *separated* by `sep`. `sep` is only added if `dest` is longer than `startLen`. The following example creates a string describing an array of integers.


```nim
runnableExamples:
  var arr = "["
  for x in items([2, 3, 5, 7, 11]):
    addSep(arr, startLen = len("["))
    add(arr, $x)
  add(arr, "]")
  doAssert arr == "[2, 3, 5, 7, 11]"
```

____

## allCharsInSet*

```nim
proc allCharsInSet*(s: string, theSet: set[char]): bool =
```

Returns true if every character of `s` is in the set `theSet`.


```nim
runnableExamples:
  doAssert allCharsInSet("aeea", {'a', 'e'}) == true
  doAssert allCharsInSet("", {'a', 'e'}) == true
```

____

## abbrev*

```nim
proc abbrev*(s: string, possibilities: openArray[string]): int =
```

Returns the index of the first item in ``possibilities`` which starts with ``s``, if not ambiguous. 

 Returns -1 if no item has been found and -2 if multiple items match.


```nim
runnableExamples:
  doAssert abbrev("fac", ["college", "faculty", "industry"]) == 1
  doAssert abbrev("foo", ["college", "faculty", "industry"]) == -1 # Not found
  doAssert abbrev("fac", ["college", "faculty", "faculties"]) == -2 # Ambiguous
  doAssert abbrev("college", ["college", "colleges", "industry"]) == 0
```

____

## join*

```nim
proc join*(a: openArray[string], sep: string = ""): string {. noSideEffect, rtl, extern: "nsuJoinSep".} =
```

Concatenates all strings in the container `a`, separating them with `sep`.


```nim
runnableExamples:
  doAssert join(["A", "B", "Conclusion"], " -> ") == "A -> B -> Conclusion"
```

____

## join*[T: not string]

```nim
proc join*[T: not string](a: openArray[T], sep: string = ""): string {. noSideEffect, rtl.} =
```

Converts all elements in the container `a` to strings using `$`, and concatenates them with `sep`.


```nim
runnableExamples:
  doAssert join([1, 2, 3], " -> ") == "1 -> 2 -> 3"
```

____

## initSkipTable*

```nim
proc initSkipTable*(a: var SkipTable, sub: string) {.noSideEffect, rtl, extern: "nsuInitSkipTable".} =
```

Preprocess table `a` for `sub`.


____

## find*

```nim
proc find*(a: SkipTable, s, sub: string, start: Natural = 0, last = 0): int {.noSideEffect, rtl, extern: "nsuFindStrA".} =
```

Searches for `sub` in `s` inside range `start`..`last` using preprocessed table `a`. If `last` is unspecified, it defaults to `s.high` (the last element). 

 Searching is case-sensitive. If `sub` is not in `s`, -1 is returned.


____

## find*

```nim
proc find*(s: string, sub: char, start: Natural = 0, last = 0): int {.noSideEffect, rtl, extern: "nsuFindChar".} =
```

Searches for `sub` in `s` inside range ``start..last`` (both ends included). If `last` is unspecified, it defaults to `s.high` (the last element). 

 Searching is case-sensitive. If `sub` is not in `s`, -1 is returned. Otherwise the index returned is relative to ``s[0]``, not ``start``. Use `s[start..last].rfind` for a ``start``-origin index. 

 

See also: 
* `rfind proc<#rfind,string,char,Natural,int>`_ 
* `replace proc<#replace,string,char,char>`_


____

## find*

```nim
proc find*(s: string, chars: set[char], start: Natural = 0, last = 0): int {.noSideEffect, rtl, extern: "nsuFindCharSet".} =
```

Searches for `chars` in `s` inside range ``start..last`` (both ends included). If `last` is unspecified, it defaults to `s.high` (the last element). 

 If `s` contains none of the characters in `chars`, -1 is returned. Otherwise the index returned is relative to ``s[0]``, not ``start``. Use `s[start..last].find` for a ``start``-origin index. 

 

See also: 
* `rfind proc<#rfind,string,set[char],Natural,int>`_ 
* `multiReplace proc<#multiReplace,string,varargs[]>`_


____

## find*

```nim
proc find*(s, sub: string, start: Natural = 0, last = 0): int {.noSideEffect, rtl, extern: "nsuFindStr".} =
```

Searches for `sub` in `s` inside range ``start..last`` (both ends included). If `last` is unspecified, it defaults to `s.high` (the last element). 

 Searching is case-sensitive. If `sub` is not in `s`, -1 is returned. Otherwise the index returned is relative to ``s[0]``, not ``start``. Use `s[start..last].find` for a ``start``-origin index. 

 

See also: 
* `rfind proc<#rfind,string,string,Natural,int>`_ 
* `replace proc<#replace,string,string,string>`_


____

## rfind*

```nim
proc rfind*(s: string, sub: char, start: Natural = 0, last = -1): int {.noSideEffect, rtl, extern: "nsuRFindChar".} =
```

Searches for `sub` in `s` inside range ``start..last`` (both ends included) in reverse -- starting at high indexes and moving lower to the first character or ``start``.  If `last` is unspecified, it defaults to `s.high` (the last element). 

 Searching is case-sensitive. If `sub` is not in `s`, -1 is returned. Otherwise the index returned is relative to ``s[0]``, not ``start``. Use `s[start..last].find` for a ``start``-origin index. 

 

See also: 
* `find proc<#find,string,char,Natural,int>`_


____

## rfind*

```nim
proc rfind*(s: string, chars: set[char], start: Natural = 0, last = -1): int {.noSideEffect, rtl, extern: "nsuRFindCharSet".} =
```

Searches for `chars` in `s` inside range ``start..last`` (both ends included) in reverse -- starting at high indexes and moving lower to the first character or ``start``.  If `last` is unspecified, it defaults to `s.high` (the last element). 

 If `s` contains none of the characters in `chars`, -1 is returned. Otherwise the index returned is relative to ``s[0]``, not ``start``. Use `s[start..last].rfind` for a ``start``-origin index. 

 

See also: 
* `find proc<#find,string,set[char],Natural,int>`_


____

## rfind*

```nim
proc rfind*(s, sub: string, start: Natural = 0, last = -1): int {.noSideEffect, rtl, extern: "nsuRFindStr".} =
```

Searches for `sub` in `s` inside range ``start..last`` (both ends included) included) in reverse -- starting at high indexes and moving lower to the first character or ``start``.   If `last` is unspecified, it defaults to `s.high` (the last element). 

 Searching is case-sensitive. If `sub` is not in `s`, -1 is returned. Otherwise the index returned is relative to ``s[0]``, not ``start``. Use `s[start..last].rfind` for a ``start``-origin index. 

 

See also: 
* `find proc<#find,string,string,Natural,int>`_


____

## count*

```nim
proc count*(s: string, sub: char): int {.noSideEffect, rtl, extern: "nsuCountChar".} =
```

Count the occurrences of the character `sub` in the string `s`. 

 

See also: 
* `countLines proc<#countLines,string>`_


____

## count*

```nim
proc count*(s: string, subs: set[char]): int {.noSideEffect, rtl, extern: "nsuCountCharSet".} =
```

Count the occurrences of the group of character `subs` in the string `s`. 

 

See also: 
* `countLines proc<#countLines,string>`_


____

## count*

```nim
proc count*(s: string, sub: string, overlapping: bool = false): int {. noSideEffect, rtl, extern: "nsuCountString".} =
```

Count the occurrences of a substring `sub` in the string `s`. Overlapping occurrences of `sub` only count when `overlapping` is set to true (default: false). 

 

See also: 
* `countLines proc<#countLines,string>`_


____

## countLines*

```nim
proc countLines*(s: string): int {.noSideEffect, rtl, extern: "nsuCountLines".} =
```

Returns the number of lines in the string `s`. 

 This is the same as ``len(splitLines(s))``, but much more efficient because it doesn't modify the string creating temporal objects. Every `character literal <manual.html#lexical-analysis-character-literals>`_ newline combination (CR, LF, CR-LF) is supported. 

 In this context, a line is any string separated by a newline combination. A line can be an empty string. 

 

See also: 
* `splitLines proc<#splitLines,string>`_


```nim
runnableExamples:
  doAssert countLines("First line\l and second line.") == 2
  case s[i]
  of '\c':
    if i+1 < s.len and s[i+1] == '\l': inc i
    inc result
  of '\l': inc result
  else: discard
  inc i
```

____

## contains*

```nim
proc contains*(s, sub: string): bool {.noSideEffect.} =
```

Same as ``find(s, sub) >= 0``. 

 

See also: 
* `find proc<#find,string,string,Natural,int>`_


____

## contains*

```nim
proc contains*(s: string, chars: set[char]): bool {.noSideEffect.} =
```

Same as ``find(s, chars) >= 0``. 

 

See also: 
* `find proc<#find,string,set[char],Natural,int>`_


____

## replace*

```nim
proc replace*(s, sub: string, by = ""): string {.noSideEffect, rtl, extern: "nsuReplaceStr".} =
```

Replaces `sub` in `s` by the string `by`. 

 

See also: 
* `find proc<#find,string,string,Natural,int>`_ 
* `replace proc<#replace,string,char,char>`_ for replacing single characters 
* `replaceWord proc<#replaceWord,string,string,string>`_ 
* `multiReplace proc<#multiReplace,string,varargs[]>`_


____

## replace*

```nim
proc replace*(s: string, sub, by: char): string {.noSideEffect, rtl, extern: "nsuReplaceChar".} =
```

Replaces `sub` in `s` by the character `by`. 

 Optimized version of `replace <#replace,string,string,string>`_ for characters. 

 

See also: 
* `find proc<#find,string,char,Natural,int>`_ 
* `replaceWord proc<#replaceWord,string,string,string>`_ 
* `multiReplace proc<#multiReplace,string,varargs[]>`_


____

## replaceWord*

```nim
proc replaceWord*(s, sub: string, by = ""): string {.noSideEffect, rtl, extern: "nsuReplaceWord".} =
```

Replaces `sub` in `s` by the string `by`. 

 Each occurrence of `sub` has to be surrounded by word boundaries (comparable to ``\b`` in regular expressions), otherwise it is not replaced.


____

## multiReplace*

```nim
proc multiReplace*(s: string, replacements: varargs[(string, string)]): string {.noSideEffect.} =
```

Same as replace, but specialized for doing multiple replacements in a single pass through the input string. 

 `multiReplace` performs all replacements in a single pass, this means it can be used to swap the occurrences of "a" and "b", for instance. 

 If the resulting string is not longer than the original input string, only a single memory allocation is required. 

 The order of the replacements does matter. Earlier replacements are preferred over later replacements in the argument list.


____

## insertSep*

```nim
proc insertSep*(s: string, sep = '_', digits = 3): string {.noSideEffect, rtl, extern: "nsuInsertSep".} =
```

Inserts the separator `sep` after `digits` characters (default: 3) from right to left. 

 Even though the algorithm works with any string `s`, it is only useful if `s` contains a number.


```nim
runnableExamples:
  doAssert insertSep("1000000") == "1_000_000"
```

____

## escape*

```nim
proc escape*(s: string, prefix = "\"", suffix = "\""): string {.noSideEffect, rtl, extern: "nsuEscape".} =
```

Escapes a string `s`. See `system.addEscapedChar <system.html#addEscapedChar,string,char>`_ for the escaping scheme. 

 The resulting string is prefixed with `prefix` and suffixed with `suffix`. Both may be empty strings. 

 

See also: 
* `unescape proc<#unescape,string,string,string>`_ for the opposite operation


____

## unescape*

```nim
proc unescape*(s: string, prefix = "\"", suffix = "\""): string {.noSideEffect, rtl, extern: "nsuUnescape".} =
```

Unescapes a string `s`. 

 This complements `escape proc<#escape,string,string,string>`_ as it performs the opposite operations. 

 If `s` does not begin with ``prefix`` and end with ``suffix`` a ValueError exception will be raised.


____

## validIdentifier*

```nim
proc validIdentifier*(s: string): bool {.noSideEffect, rtl, extern: "nsuValidIdentifier".} =
```

Returns true if `s` is a valid identifier. 

 A valid identifier starts with a character of the set `IdentStartChars` and is followed by any number of characters of the set `IdentChars`.


```nim
runnableExamples:
  doAssert "abc_def08".validIdentifier
```

____

## formatBiggestFloat*

```nim
proc formatBiggestFloat*(f: BiggestFloat, format: FloatFormatMode = ffDefault, noSideEffect, rtl, extern: "nsu$1".} =
```

Converts a floating point value `f` to a string. 

 If ``format == ffDecimal`` then precision is the number of digits to be printed after the decimal point. If ``format == ffScientific`` then precision is the maximum number of significant digits to be printed. `precision`'s default value is the maximum number of meaningful digits after the decimal point for Nim's ``biggestFloat`` type. 

 If ``precision == -1``, it tries to format it nicely.


```nim
runnableExamples:
  let x = 123.456
  doAssert x.formatBiggestFloat() == "123.4560000000000"
  doAssert x.formatBiggestFloat(ffDecimal, 4) == "123.4560"
  doAssert x.formatBiggestFloat(ffScientific, 2) == "1.23e+02"
  var precision = precision
  if precision == -1:
    # use the same default precision as c_sprintf
    precision = 6
  var res: cstring
  case format
  of ffDefault:
    {.emit: "`res` = `f`.toString();".}
  of ffDecimal:
    {.emit: "`res` = `f`.toFixed(`precision`);".}
  of ffScientific:
    {.emit: "`res` = `f`.toExponential(`precision`);".}
  result = $res
  if 1.0 / f == -Inf:
    # JavaScript removes the "-" from negative Zero, add it back here
    result = "-" & $res
  for i in 0 ..< result.len:
    # Depending on the locale either dot or comma is produced,
    # but nothing else is possible:
    if result[i] in {'.', ','}: result[i] = decimalsep
  const floatFormatToChar: array[FloatFormatMode, char] = ['g', 'f', 'e']
  var
    frmtstr {.noinit.}: array[0..5, char]
    buf {.noinit.}: array[0..2500, char]
    L: cint
  frmtstr[0] = '%'
  if precision >= 0:
    frmtstr[1] = '#'
    frmtstr[2] = '.'
    frmtstr[3] = '*'
    frmtstr[4] = floatFormatToChar[format]
    frmtstr[5] = '\0'
    when defined(nimNoArrayToCstringConversion):
      L = c_sprintf(addr buf, addr frmtstr, precision, f)
    else:
      L = c_sprintf(buf, frmtstr, precision, f)
  else:
    frmtstr[1] = floatFormatToChar[format]
    frmtstr[2] = '\0'
    when defined(nimNoArrayToCstringConversion):
      L = c_sprintf(addr buf, addr frmtstr, f)
    else:
      L = c_sprintf(buf, frmtstr, f)
  result = newString(L)
  for i in 0 ..< L:
    # Depending on the locale either dot or comma is produced,
    # but nothing else is possible:
    if buf[i] in {'.', ','}: result[i] = decimalSep
    else: result[i] = buf[i]
  when defined(windows):
    # VS pre 2015 violates the C standard: "The exponent always contains at
    # least two digits, and only as many more digits as necessary to
    # represent the exponent." [C11 §7.21.6.1]
    # The following post-processing fixes this behavior.
    if result.len > 4 and result[^4] == '+' and result[^3] == '0':
      result[^3] = result[^2]
      result[^2] = result[^1]
      result.setLen(result.len - 1)
```

____

## formatFloat*

```nim
proc formatFloat*(f: float, format: FloatFormatMode = ffDefault, noSideEffect, rtl, extern: "nsu$1".} =
```

Converts a floating point value `f` to a string. 

 If ``format == ffDecimal`` then precision is the number of digits to be printed after the decimal point. If ``format == ffScientific`` then precision is the maximum number of significant digits to be printed. `precision`'s default value is the maximum number of meaningful digits after the decimal point for Nim's ``float`` type. 

 If ``precision == -1``, it tries to format it nicely.


```nim
runnableExamples:
  let x = 123.456
  doAssert x.formatFloat() == "123.4560000000000"
  doAssert x.formatFloat(ffDecimal, 4) == "123.4560"
  doAssert x.formatFloat(ffScientific, 2) == "1.23e+02"
```

____

## trimZeros*

```nim
proc trimZeros*(x: var string) {.noSideEffect.} =
```

Trim trailing zeros from a formatted floating point value `x` (must be declared as ``var``). 

 This modifies `x` itself, it does not return a copy.


```nim
runnableExamples:
  var x = "123.456000000"
  x.trimZeros()
  doAssert x == "123.456"
  if x.contains('e'):
    spl = x.split('e')
    x = spl[0]
  while x[x.high] == '0':
    x.setLen(x.len-1)
  if x[x.high] in [',', '.']:
    x.setLen(x.len-1)
  if spl.len > 0:
    x &= "e" & spl[1]
```

____

## formatSize*

```nim
proc formatSize*(bytes: int64, includeSpace = false): string {.noSideEffect.} =
```

Rounds and formats `bytes`. 

 By default, uses the IEC/ISO standard binary prefixes, so 1024 will be formatted as 1KiB.  Set prefix to `bpColloquial` to use the colloquial names from the SI standard (e.g. k for 1000 being reused as 1024). 

 `includeSpace` can be set to true to include the (SI preferred) space between the number and the unit (e.g. 1 KiB). 

 

See also: 
* strformat module [(link)](https://nim-lang.org/docs/strformat.html) for string interpolation and formatting


```nim
runnableExamples:
  doAssert formatSize((1'i64 shl 31) + (300'i64 shl 20)) == "2.293GiB"
  doAssert formatSize((2.234*1024*1024).int) == "2.234MiB"
  doAssert formatSize(4096, includeSpace = true) == "4 KiB"
  doAssert formatSize(4096, prefix = bpColloquial, includeSpace = true) == "4 kB"
  doAssert formatSize(4096) == "4KiB"
  doAssert formatSize(5_378_934, prefix = bpColloquial, decimalSep = ',') == "5,13MB"
```

____

## formatEng*

```nim
proc formatEng*(f: BiggestFloat, useUnitSpace = false): string {.noSideEffect.} = proc getPrefix(exp: int): char =
```

Converts a floating point value `f` to a string using engineering notation. 

 Numbers in of the range -1000.0<f<1000.0 will be formatted without an exponent. Numbers outside of this range will be formatted as a significand in the range -1000.0<f<1000.0 and an exponent that will always be an integer multiple of 3, corresponding with the SI prefix scale k, M, G, T etc for numbers with an absolute value greater than 1 and m, μ, n, p etc for numbers with an absolute value less than 1. 

 The default configuration (`trim=true` and `precision=10`) shows the 
**shortest** form that precisely (up to a maximum of 10 decimal places) displays the value. For example, 4.100000 will be displayed as 4.1 (which is mathematically identical) whereas 4.1000003 will be displayed as 4.1000003. 

 If `trim` is set to true, trailing zeros will be removed; if false, the number of digits specified by `precision` will always be shown. 

 `precision` can be used to set the number of digits to be shown after the decimal point or (if `trim` is true) the maximum number of digits to be shown. 


```nim
  formatEng(0, 2, trim=false) == "0.00"
  formatEng(0, 2) == "0"
  formatEng(0.053, 0) == "53e-3"
  formatEng(52731234, 2) == "52.73e6"
  formatEng(-52731234, 2) == "-52.73e6"
```
 

 If `siPrefix` is set to true, the number will be displayed with the SI prefix corresponding to the exponent. For example 4100 will be displayed as "4.1 k" instead of "4.1e3". Note that `u` is used for micro- in place of the greek letter mu (μ) as per ISO 2955. Numbers with an absolute value outside of the range 1e-18<f<1000e18 (1a<f<1000E) will be displayed with an exponent rather than an SI prefix, regardless of whether `siPrefix` is true. 

 If `useUnitSpace` is true, the provided unit will be appended to the string (with a space as required by the SI standard). This behaviour is slightly different to appending the unit to the result as the location of the space is altered depending on whether there is an exponent. 


```nim
  formatEng(4100, siPrefix=true, unit="V") == "4.1 kV"
  formatEng(4.1, siPrefix=true, unit="V") == "4.1 V"
  formatEng(4.1, siPrefix=true) == "4.1" # Note lack of space
  formatEng(4100, siPrefix=true) == "4.1 k"
  formatEng(4.1, siPrefix=true, unit="") == "4.1 " # Space with unit=""
  formatEng(4100, siPrefix=true, unit="") == "4.1 k"
  formatEng(4100) == "4.1e3"
  formatEng(4100, unit="V") == "4.1e3 V"
  formatEng(4100, unit="", useUnitSpace=true) == "4.1e3 " # Space with useUnitSpace=true
```
 

 `decimalSep` is used as the decimal separator. 

 

See also: 
* strformat module [(link)](https://nim-lang.org/docs/strformat.html) for string interpolation and formatting Get the SI prefix for a given exponent 

 Assumes exponent is a multiple of 3; returns ' ' if no prefix found


____

## findNormalized

```nim
proc findNormalized(x: string, inArray: openArray[string]): int =
```




____

## invalidFormatString

```nim
proc invalidFormatString() {.noinline.} =
```




____

## addf*

```nim
proc addf*(s: var string, formatstr: string, a: varargs[string, `$`]) {. noSideEffect, rtl, extern: "nsuAddf".} =
```

The same as ``add(s, formatstr % a)``, but more efficient.


____

## `%` *

```nim
proc `%` *(formatstr: string, a: openArray[string]): string {.noSideEffect, rtl, extern: "nsuFormatOpenArray".} =
```

Interpolates a format string with the values from `a`. 

 The `substitution`:idx: operator performs string substitutions in `formatstr` and returns a modified `formatstr`. This is often called `string interpolation`:idx:. 

 This is best explained by an example: 


```nim
 "$1 eats $2." % ["The cat", "fish"]
```
 

 Results in: 


```nim
 "The cat eats fish."
```
 

 The substitution variables (the thing after the ``$``) are enumerated from 1 to ``a.len``. To produce a verbatim ``$``, use ``$$``. The notation ``$#`` can be used to refer to the next substitution variable: 


```nim
 "$# eats $#." % ["The cat", "fish"]
```
 

 Substitution variables can also be words (that is ``[A-Za-z_]+[A-Za-z0-9_]*``) in which case the arguments in `a` with even indices are keys and with odd indices are the corresponding values. An example: 


```nim
 "$animal eats $food." % ["animal", "The cat", "food", "fish"]
```
 

 Results in: 


```nim
 "The cat eats fish."
```
 

 The variables are compared with `cmpIgnoreStyle`. `ValueError` is raised if an ill-formed format string has been passed to the `%` operator. 

 

See also: 
* strformat module [(link)](https://nim-lang.org/docs/strformat.html) for string interpolation and formatting


____

## `%` *

```nim
proc `%` *(formatstr, a: string): string {.noSideEffect, rtl, extern: "nsuFormatSingleElem".} =
```

This is the same as ``formatstr % [a]`` (see `% proc<#%25,string,openArray[string]>`_).


____

## format*

```nim
proc format*(formatstr: string, a: varargs[string, `$`]): string {.noSideEffect, rtl, extern: "nsuFormatVarargs".} =
```

This is the same as ``formatstr % a`` (see `% proc<#%25,string,openArray[string]>`_) except that it supports auto stringification. 

 

See also: 
* strformat module [(link)](https://nim-lang.org/docs/strformat.html) for string interpolation and formatting


____

## strip*

```nim
proc strip*(s: string, leading = true, trailing = true, {.noSideEffect, rtl, extern: "nsuStrip".} =
```

Strips leading or trailing `chars` (default: whitespace characters) from `s` and returns the resulting string. 

 If `leading` is true (default), leading `chars` are stripped. If `trailing` is true (default), trailing `chars` are stripped. If both are false, the string is returned unchanged. 

 

See also: 
* `stripLineEnd proc<#stripLineEnd,string>`_


```nim
runnableExamples:
  let a = "  vhellov   "
  let b = strip(a)
  doAssert b == "vhellov"
```

____

## stripLineEnd*

```nim
proc stripLineEnd*(s: var string) =
```

Returns ``s`` stripped from one of these suffixes: ``\r, \n, \r\n, \f, \v`` (at most once instance). For example, can be useful in conjunction with ``osproc.execCmdEx``. aka: `chomp`:idx:


```nim
runnableExamples:
  var s = "foo\n\n"
  s.stripLineEnd
  doAssert s == "foo\n"
  s = "foo\r\n"
  s.stripLineEnd
  doAssert s == "foo"
```

____

## editDistance*

```nim
proc editDistance*(a, b: string): int {.noSideEffect, deprecated: "use editdistance.editDistanceAscii instead".} =
```

Returns the edit distance between `a` and `b`. 

 This uses the `Levenshtein`:idx: distance algorithm with only a linear memory overhead.


____

## isNilOrEmpty*

```nim
proc isNilOrEmpty*(s: string): bool {.noSideEffect, procvar, rtl, deprecated: "use 'x.len == 0' instead".} =
```

Checks if `s` is nil or empty.


____

## isNilOrWhitespace*

```nim
proc isNilOrWhitespace*(s: string): bool {.noSideEffect, procvar, rtl, extern: "nsuIsNilOrWhitespace".} =
```

Checks if `s` is nil or consists entirely of whitespace characters.


____

## isAlphaAscii*

```nim
proc isAlphaAscii*(s: string): bool {.noSideEffect, procvar, deprecated: "Deprecated since version 0.20 since its semantics are unclear".} =
```

Checks whether or not `s` is alphabetical. 

 This checks a-z, A-Z ASCII characters only. Returns true if all characters in `s` are alphabetic and there is at least one character in `s`. Use Unicode module [(link)](https://nim-lang.org/docs/unicode.html) for UTF-8 support.


```nim
runnableExamples:
  doAssert isAlphaAscii("fooBar") == true
  doAssert isAlphaAscii("fooBar1") == false
  doAssert isAlphaAscii("foo Bar") == false
```

____

## isAlphaNumeric*

```nim
proc isAlphaNumeric*(s: string): bool {.noSideEffect, procvar, deprecated: "Deprecated since version 0.20 since its semantics are unclear".} =
```

Checks whether or not `s` is alphanumeric. 

 This checks a-z, A-Z, 0-9 ASCII characters only. Returns true if all characters in `s` are alpanumeric and there is at least one character in `s`. Use Unicode module [(link)](https://nim-lang.org/docs/unicode.html) for UTF-8 support.


```nim
runnableExamples:
  doAssert isAlphaNumeric("fooBar") == true
  doAssert isAlphaNumeric("fooBar1") == true
  doAssert isAlphaNumeric("foo Bar") == false
```

____

## isDigit*

```nim
proc isDigit*(s: string): bool {.noSideEffect, procvar, deprecated: "Deprecated since version 0.20 since its semantics are unclear".} =
```

Checks whether or not `s` is a numeric value. 

 This checks 0-9 ASCII characters only. Returns true if all characters in `s` are numeric and there is at least one character in `s`.


```nim
runnableExamples:
  doAssert isDigit("1908") == true
  doAssert isDigit("fooBar1") == false
```

____

## isSpaceAscii*

```nim
proc isSpaceAscii*(s: string): bool {.noSideEffect, procvar, deprecated: "Deprecated since version 0.20 since its semantics are unclear".} =
```

Checks whether or not `s` is completely whitespace. 

 Returns true if all characters in `s` are whitespace characters and there is at least one character in `s`.


```nim
runnableExamples:
  doAssert isSpaceAscii("   ") == true
  doAssert isSpaceAscii("") == false
```

____

## isLowerAscii*

```nim
proc isLowerAscii*(s: string, skipNonAlpha: bool): bool {. deprecated: "Deprecated since version 0.20 since its semantics are unclear".} =
```

Checks whether ``s`` is lower case. 

 This checks ASCII characters only. 

 If ``skipNonAlpha`` is true, returns true if all alphabetical characters in ``s`` are lower case.  Returns false if none of the characters in ``s`` are alphabetical. 

 If ``skipNonAlpha`` is false, returns true only if all characters in ``s`` are alphabetical and lower case. 

 For either value of ``skipNonAlpha``, returns false if ``s`` is an empty string. Use Unicode module [(link)](https://nim-lang.org/docs/unicode.html) for UTF-8 support.


```nim
runnableExamples:
  doAssert isLowerAscii("1foobar", false) == false
  doAssert isLowerAscii("1foobar", true) == true
  doAssert isLowerAscii("1fooBar", true) == false
```

____

## isUpperAscii*

```nim
proc isUpperAscii*(s: string, skipNonAlpha: bool): bool {. deprecated: "Deprecated since version 0.20 since its semantics are unclear".} =
```

Checks whether ``s`` is upper case. 

 This checks ASCII characters only. 

 If ``skipNonAlpha`` is true, returns true if all alphabetical characters in ``s`` are upper case.  Returns false if none of the characters in ``s`` are alphabetical. 

 If ``skipNonAlpha`` is false, returns true only if all characters in ``s`` are alphabetical and upper case. 

 For either value of ``skipNonAlpha``, returns false if ``s`` is an empty string. Use Unicode module [(link)](https://nim-lang.org/docs/unicode.html) for UTF-8 support.


```nim
runnableExamples:
  doAssert isUpperAscii("1FOO", false) == false
  doAssert isUpperAscii("1FOO", true) == true
  doAssert isUpperAscii("1Foo", true) == false
```

____

## wordWrap*

```nim
proc wordWrap*(s: string, maxLineWidth = 80, deprecated: "use wrapWords in std/wordwrap instead".} =
```

Word wraps `s`.


____

# Templates

## template toImpl

```nim
template toImpl(call) =
```




____

## template stringHasSep

```nim
template stringHasSep(s: string, index: int, seps: set[char]): bool =
```




____

## template stringHasSep

```nim
template stringHasSep(s: string, index: int, sep: char): bool =
```




____

## template stringHasSep

```nim
template stringHasSep(s: string, index: int, sep: string): bool =
```




____

## template splitCommon

```nim
template splitCommon(s, sep, maxsplit, sepLen) =
```

Common code for split procs


____

## template oldSplit

```nim
template oldSplit(s, seps, maxsplit) =
```




____

## template accResult

```nim
template accResult(iter: untyped) =
```




____

## template rsplitCommon

```nim
template rsplitCommon(s, sep, maxsplit, sepLen) =
```

Common code for rsplit functions


____

## template isImpl

```nim
template isImpl(call) =
```




____

## template isCaseImpl

```nim
template isCaseImpl(s, charProc, skipNonAlpha) =
```




____

# Iterators

## iterator split*

```nim
iterator split*(s: string, sep: char, maxsplit: int = -1): string =
```

Splits the string `s` into substrings using a single separator. 

 Substrings are separated by the character `sep`. The code: 


```nim
 for word in split(";;this;is;an;;example;;;", ';'):
   writeLine(stdout, word)
```
 

 Results in: 


```nim
 ""
 ""
 "this"
 "is"
 "an"
 ""
 "example"
 ""
 ""
 ""
```
 

 

See also: 
* `rsplit iterator<#rsplit.i,string,char,int>`_ 
* `splitLines iterator<#splitLines.i,string>`_ 
* `splitWhitespace iterator<#splitWhitespace.i,string,int>`_ 
* `split proc<#split,string,char,int>`_


____

## iterator split*

```nim
iterator split*(s: string, seps: set[char] = Whitespace, maxsplit: int = -1): string =
```

Splits the string `s` into substrings using a group of separators. 

 Substrings are separated by a substring containing only `seps`. 


```nim
 for word in split("this\lis an\texample"):
   writeLine(stdout, word)
```
 

 ...generates this output: 


```nim
 "this"
 "is"
 "an"
 "example"
```
 

 And the following code: 


```nim
 for word in split("this:is;an$example", {';', ':', '$'}):
   writeLine(stdout, word)
```
 

 ...produces the same output as the first example. The code: 


```nim
 let date = "2012-11-20T22:08:08.398990"
 let separators = {' ', '-', ':', 'T'}
 for number in split(date, separators):
   writeLine(stdout, number)
```
 

 ...results in: 


```nim
 "2012"
 "11"
 "20"
 "22"
 "08"
 "08.398990"
```
 

 

See also: 
* `rsplit iterator<#rsplit.i,string,set[char],int>`_ 
* `splitLines iterator<#splitLines.i,string>`_ 
* `splitWhitespace iterator<#splitWhitespace.i,string,int>`_ 
* `split proc<#split,string,set[char],int>`_


____

## iterator split*

```nim
iterator split*(s: string, sep: string, maxsplit: int = -1): string =
```

Splits the string `s` into substrings using a string separator. 

 Substrings are separated by the string `sep`. The code: 


```nim
 for word in split("thisDATAisDATAcorrupted", "DATA"):
   writeLine(stdout, word)
```
 

 Results in: 


```nim
 "this"
 "is"
 "corrupted"
```
 

 

See also: 
* `rsplit iterator<#rsplit.i,string,string,int,bool>`_ 
* `splitLines iterator<#splitLines.i,string>`_ 
* `splitWhitespace iterator<#splitWhitespace.i,string,int>`_ 
* `split proc<#split,string,string,int>`_


____

## iterator rsplit*

```nim
iterator rsplit*(s: string, sep: char, maxsplit: int = -1): string =
```

Splits the string `s` into substrings from the right using a string separator. Works exactly the same as `split iterator <#split.i,string,char,int>`_ except in reverse order. 


```nim
 for piece in "foo:bar".rsplit(':'):
   echo piece
```
 

 Results in: 


```nim
 "bar"
 "foo"
```
 

 Substrings are separated from the right by the char `sep`. 

 

See also: 
* `split iterator<#split.i,string,char,int>`_ 
* `splitLines iterator<#splitLines.i,string>`_ 
* `splitWhitespace iterator<#splitWhitespace.i,string,int>`_ 
* `rsplit proc<#rsplit,string,char,int>`_


____

## iterator rsplit*

```nim
iterator rsplit*(s: string, seps: set[char] = Whitespace, maxsplit: int = -1): string =
```

Splits the string `s` into substrings from the right using a string separator. Works exactly the same as `split iterator <#split.i,string,char,int>`_ except in reverse order. 


```nim
 for piece in "foo bar".rsplit(WhiteSpace):
   echo piece
```
 

 Results in: 


```nim
 "bar"
 "foo"
```
 

 Substrings are separated from the right by the set of chars `seps` 

 

See also: 
* `split iterator<#split.i,string,set[char],int>`_ 
* `splitLines iterator<#splitLines.i,string>`_ 
* `splitWhitespace iterator<#splitWhitespace.i,string,int>`_ 
* `rsplit proc<#rsplit,string,set[char],int>`_


____

## iterator rsplit*

```nim
iterator rsplit*(s: string, sep: string, maxsplit: int = -1, keepSeparators: bool = false): string =
```

Splits the string `s` into substrings from the right using a string separator. Works exactly the same as `split iterator <#split.i,string,string,int>`_ except in reverse order. 


```nim
 for piece in "foothebar".rsplit("the"):
   echo piece
```
 

 Results in: 


```nim
 "bar"
 "foo"
```
 

 Substrings are separated from the right by the string `sep` 

 

See also: 
* `split iterator<#split.i,string,string,int>`_ 
* `splitLines iterator<#splitLines.i,string>`_ 
* `splitWhitespace iterator<#splitWhitespace.i,string,int>`_ 
* `rsplit proc<#rsplit,string,string,int>`_


____

## iterator splitLines*

```nim
iterator splitLines*(s: string, keepEol = false): string =
```

Splits the string `s` into its containing lines. 

 Every `character literal <manual.html#lexical-analysis-character-literals>`_ newline combination (CR, LF, CR-LF) is supported. The result strings contain no trailing end of line characters unless parameter ``keepEol`` is set to ``true``. 

 Example: 


```nim
 for line in splitLines("\nthis\nis\nan\n\nexample\n"):
   writeLine(stdout, line)
```
 

 Results in: 


```nim
 ""
 "this"
 "is"
 "an"
 ""
 "example"
 ""
```
 

 

See also: 
* `splitWhitespace iterator<#splitWhitespace.i,string,int>`_ 
* `splitLines proc<#splitLines,string>`_


____

## iterator splitWhitespace*

```nim
iterator splitWhitespace*(s: string, maxsplit: int = -1): string =
```

Splits the string ``s`` at whitespace stripping leading and trailing whitespace if necessary. If ``maxsplit`` is specified and is positive, no more than ``maxsplit`` splits is made. 

 The following code: 


```nim
 let s = "  foo \t bar  baz  "
 for ms in [-1, 1, 2, 3]:
   echo "------ maxsplit = ", ms, ":"
   for item in s.splitWhitespace(maxsplit=ms):
     echo '"', item, '"'
```
 

 ...results in: 


```nim
 ------ maxsplit = -1:
 "foo"
 "bar"
 "baz"
 ------ maxsplit = 1:
 "foo"
 "bar  baz  "
 ------ maxsplit = 2:
 "foo"
 "bar"
 "baz  "
 ------ maxsplit = 3:
 "foo"
 "bar"
 "baz"
```
 

 

See also: 
* `splitLines iterator<#splitLines.i,string>`_ 
* `splitWhitespace proc<#splitWhitespace,string,int>`_


____

## iterator tokenize*

```nim
iterator tokenize*(s: string, seps: set[char] = Whitespace): tuple[ token: string, isSep: bool] =
```

Tokenizes the string `s` into substrings. 

 Substrings are separated by a substring containing only `seps`. Example: 


```nim
 for word in tokenize("  this is an  example  "):
   writeLine(stdout, word)
```
 

 Results in: 


```nim
 ("  ", true)
 ("this", false)
 (" ", true)
 ("is", false)
 (" ", true)
 ("an", false)
 ("  ", true)
 ("example", false)
 ("  ", true)



____

