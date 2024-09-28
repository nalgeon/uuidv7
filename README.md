# UUIDv7 in N languages

UUIDv7 is a 128-bit unique identifier like its older siblings, such as the widely used UUIDv4. But unlike v4, UUIDv7 is time-sortable with 1 ms precision. By combining the timestamp and the random parts, UUIDv7 becomes an excellent choice for record identifiers in databases, including distributed ones.

This repo provides zero-dependency UUIDv7 implementations in various languages. If you spot a bug — please submit a pull request. PRs for other languages are also welcome!

## Structure

UUIDv7 looks like this when represented as a string:

```
0190163d-8694-739b-aea5-966c26f8ad91
└─timestamp─┘ │└─┤ │└───rand_b─────┘
             ver │var
              rand_a
```

The 128-bit value consists of several parts:

-   `timestamp` (48 bits) is a Unix timestamp in milliseconds.
-   `ver` (4 bits) is a UUID version (`7`).
-   `rand_a` (12 bits) is randomly generated.
-   `var`\* (2 bits) is equal to `10`.
-   `rand_b` (62 bits) is randomly generated.

\* In string representation, each symbol encodes 4 bits as a hex number, so the `a` in the example is `1010`, where the first two bits are the fixed variant (`10`) and the next two are random. So the resulting hex number can be either `8` (`1000`), `9` (`1001`), `a` (`1010`) or `b` (`1011`).

See [RFC 9652](https://www.rfc-editor.org/rfc/rfc9562#name-uuid-version-7) for details.

## Implementations

[C](src/uuidv7.c) •
[C#](src/uuidv7.cs) •
[C++](src/uuidv7.cpp) •
[Clojure](src/uuidv7.clj) •
[Crystal](src/uuidv7.cr) •
[Dart](src/uuidv7.dart) •
[Emacs Lisp](src/uuidv7.el) •
[Elixir](src/uuidv7.exs) •
[Erlang](src/uuidv7.erl) •
[F#](src/uuidv7.fsx) •
[Gleam](src/uuidv7.gleam) •
[Go](src/uuidv7.go) •
[Inko](src/uuidv7.inko) •
[Java](src/uuidv7.java) •
[JavaScript](src/uuidv7.js) •
[Julia](src/uuidv7.jl) •
[Kotlin](src/uuidv7.kt) •
[Lua](src/uuidv7.lua) •
[Nim](src/uuidv7.nim) •
[Nushell](src/uuidv7.nu) •
[Perl](src/uuidv7.pl) •
[PHP](src/uuidv7.php) •
[Pascal](src/uuidv7.pas) •
[PowerShell](src/uuidv7.ps1) •
[Python](src/uuidv7.py) •
[R](src/uuidv7.r) •
[Racket](src/uuidv7.rkt) •
[Ruby](src/uuidv7.rb) •
[Rust](src/uuidv7.rs) •
[Shell](src/uuidv7.sh) •
[SQL](src/uuidv7.sql) •
[SQL Server](src/uuidv7.tsql) •
[Swift](src/uuidv7.swift) •
[Tcl](src/uuidv7.tcl) •
[V](src/uuidv7.v) •
[Vimscript](src/uuidv7.vim) •
[Zig](src/uuidv7.zig)

## License

The Unlicense.
