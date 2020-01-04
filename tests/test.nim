import std/sha1, osproc, strutils, unittest

test "complex to md5":
  discard execCmd("./src/nimtomd -o:tests/complex.md -ow tests/complex.nim")
  check secureHashFile("tests/complex.md") == parseSecureHash("FAE6854CAB76F6583C1CFF9D4F2B722302D5F9DC")

test "standard lib strutils to md5":
  discard execCmd("./src/nimtomd -o:tests/strutils.md -ow tests/strutils.nim")
  check secureHashFile("tests/strutils.md") == parseSecureHash("E171D12BFD0CE2D43E16A0A91D04FCEDB01476B9")