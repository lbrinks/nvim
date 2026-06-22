# Vim Regex & Substitute Reference

## Basic Substitute Command

```vim
:[range]s/pattern/replacement/[flags]
```

| Part | Meaning |
|------|---------|
| `range` | Which lines to operate on |
| `s` | Substitute command |
| `pattern` | What to find |
| `replacement` | What to put in its place |
| `flags` | Modifiers for the command |

---

## Range

| Range | Meaning |
|-------|---------|
| (none) | Current line only |
| `%` | Entire file |
| `5,10` | Lines 5 through 10 |
| `.,$` | Current line to end of file |
| `1,.` | Start of file to current line |
| `'<,'>` | Visual selection (auto-inserted) |
| `.,.+4` | Current line + next 4 lines |

---

## Flags

| Flag | Meaning |
|------|---------|
| `g` | All matches on the line (not just first) |
| `c` | Confirm each replacement |
| `i` | Case insensitive |
| `I` | Case sensitive |
| `n` | Count matches only, don't replace |
| `e` | Suppress "pattern not found" error |

---

## Magic Modes

| Mode | Syntax | Effect |
|------|--------|--------|
| Default (magic) | `/\v` not used | Must escape `(`, `)`, `+`, `{`, `}`, `|` |
| Very magic | `\v` | Almost everything is special (like PCRE) |
| No magic | `\V` | Everything is literal except `\` |

Recommendation: use `\v` to avoid escape hell.

---

## Groups & Backreferences

**Capture groups** save matched text for reuse in the replacement.

Very magic (`\v`):
```vim
:%s/\v(foo)(bar)/\2\1/g
```

Default magic:
```vim
:%s/\(foo\)\(bar\)/\2\1/g
```

- `(...)` — capture group (numbered left to right)
- `\1`, `\2`, ... — backreference in replacement
- `%(...)` — non-capturing group (doesn't get a number)

---

## Lookahead & Lookbehind

Assertions check context without consuming characters.

| Syntax | Name | Meaning |
|--------|------|---------|
| `(foo)@=` | Positive lookahead | `foo` MUST follow |
| `(foo)@!` | Negative lookahead | `foo` must NOT follow |
| `(foo)@<=` | Positive lookbehind | `foo` MUST precede |
| `(foo)@<!` | Negative lookbehind | `foo` must NOT precede |

How to read it: group first, then `@` + assertion type.

Example: match `./` but NOT when followed by `upload`:
```vim
/\v\.\/(upload)@!
```

---

## Quantifiers

| Quantifier | Meaning |
|------------|---------|
| `*` | 0 or more (greedy) |
| `+` | 1 or more (greedy) — `\+` without `\v` |
| `?` or `=` | 0 or 1 — `\?` or `\=` without `\v` |
| `{n,m}` | Between n and m |
| `{-}` | 0 or more (non-greedy) |
| `{-n,m}` | Between n and m (non-greedy) |

Non-greedy is `{-}` in Vim (not `*?` like PCRE).

---

## Character Classes

| Class | Meaning |
|-------|---------|
| `.` | Any character (except newline) |
| `\w` | Word character `[a-zA-Z0-9_]` |
| `\W` | Non-word character |
| `\d` | Digit `[0-9]` |
| `\s` | Whitespace |
| `\S` | Non-whitespace |
| `[abc]` | Any of a, b, c |
| `[^abc]` | Anything except a, b, c |
| `[a-z]` | Range |

---

## Special Replacement Tokens

| Token | Meaning |
|-------|---------|
| `\0` or `&` | Entire match |
| `\1`..`\9` | Capture group n |
| `\r` | Newline in replacement |
| `\t` | Tab |
| `\u` | Uppercase next character |
| `\U` | Uppercase until `\e` or `\E` |
| `\l` | Lowercase next character |
| `\L` | Lowercase until `\e` or `\E` |

---

## Useful Patterns

Match a path starting with `./` excluding `./upload`:
```vim
/\v\.\/(upload)@!([^"' ]+)
```

Replace relative with absolute, keeping filename:
```vim
:%s/\v\.\/(upload)@!([^"' ]+)/\/absolute\/path\/\2/g
```

Swap two words:
```vim
:%s/\v(word1)(.*)(word2)/\3\2\1/g
```

Delete trailing whitespace:
```vim
:%s/\s\+$//g
```

---

## Workflow Tips

1. **Search first** — test your pattern with `/pattern` before substituting
2. **Use `c` flag** — confirm interactively until you trust the pattern
3. **Use `n` flag** — count matches without changing anything
4. **Visual select** — highlight lines, then `:s/` auto-scopes to selection
