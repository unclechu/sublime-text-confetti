# Confetti syntax for bat and Sublime Text

A generic [Confetti 1.0](https://confetti.hgs3.me/specification/) syntax
definition for [`bat`](https://github.com/sharkdp/bat) and Sublime Text.

The grammar is independent of the application interpreting Confetti directives,
just like
[confetti-vim-syntax](https://github.com/unclechu/confetti-vim-syntax) and
[tree-sitter-confetti](https://github.com/unclechu/tree-sitter-confetti).

## Highlighting

- Directive names, including names with underscores and hyphens, when they
  resemble identifiers
- `#` comments
- Ordinary double-quoted strings, triple-quoted multiline strings, and escapes
- Curly braces and semicolon separators
- Operator-looking arguments, including `+`, `==`, `&&`, and `||`
- Numeric-looking arguments such as
  `42`, `-1.5`, `.125`, `1_000`, `3s`, `1e-3`, `1920x1080`, and `1.2.3`
- Backslash–newline continuations, including in ordinary strings

Other bare arguments, such as `init.c`, remain unhighlighted. Operators and
numbers are classified by their spelling, not by application-specific meaning.
This is syntax highlighting, not Confetti validation.

## Install for bat

Copy `Confetti.sublime-syntax` into `bat`’s custom syntaxes directory and
rebuild the syntax cache:

```sh
BAT_CONFIG_DIR=$(bat --config-dir)
mkdir -p -- "${BAT_CONFIG_DIR}/syntaxes"
cp Confetti.sublime-syntax -- "${BAT_CONFIG_DIR}/syntaxes/"
bat cache --build
```

On distributions where the executable is named `batcat`, substitute `batcat`
for `bat`.

Verify that the syntax is loaded:

```sh
bat --list-languages | grep -i confetti
bat --language confetti --style=plain examples/core.confetti
```

`bat` also automatically recognizes files ending in `.confetti`.

The custom syntax is local to the current `bat` installation. Rebuild the cache
after changing the grammar:

```sh
bat cache --build
```

To discard the entire custom cache and return to built-in assets, use
`bat cache --clear`. This doesn’t remove the custom syntax file itself.

## Install for Sublime Text

Put `Confetti.sublime-syntax` in a package directory, for example
`Packages/User/Confetti.sublime-syntax`. Sublime Text will then recognize
`.confetti` files. The file uses syntax features compatible with older Sublime
Text syntax definitions to remain suitable for `bat`’s `syntect` parser.

To run the syntax tests in Sublime Text, place `syntax_test_confetti.confetti`
alongside the grammar under `Packages` and invoke **Tools → Build** with the
syntax test open.

## Tests

`syntax_test_confetti.confetti` exercises comments, strings, escapes, directive
names, operators, numbers, blocks, adjacent directives, and continued lines.

There is also a standalone integration smoke test that creates a temporary
`bat` configuration, builds the syntax cache, and checks that
`--language confetti` works without changing your normal configuration:

```sh
sh tests/check.sh
```

The test needs `bat` (or `batcat`) to be installed and available on `PATH`.

## License

Released into the public domain under [The Unlicense](https://unlicense.org/).
