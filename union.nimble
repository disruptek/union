# Package

version       = "0.1.3"
author        = "Leorize"
description   = "Anonymous unions in Nim"
license       = "MIT"

# Dependencies

requires "nim >= 1.5.1"

task test, "Run test suite":
  when (compiles do: import balls):
    when defined(windows):
      exec "balls.cmd"
    else:
      exec "balls"
  else:
    echo "You'll need the `balls` unittest module to run the tests."
    echo "You might copy and paste the following to install it:"
    echo "nimble install -y https://github.com/disruptek/balls"
