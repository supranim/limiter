# Package

version       = "0.1.0"
author        = "George Lemon"
description   = "A simple to use HTTP rate limiting library to limit any action during a specific period of time."
license       = "MIT"
srcDir        = "src"


# Dependencies

requires "nim >= 1.4.0"

task tests, "Run tests":
    exec "testament p 'tests/*.nim'"