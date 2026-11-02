# Test results:

Run with `tests\run_tests.bat` from the project root.

Each expected file was written before running the scanner. Output rows are TOKEN TYPE, LEXEME, LINE, COLUMN (positions start at 1). In the "Expected" column, "tokens" means valid tokens and "ERROR rows" means unexpected characters reported.

## Normal tests (6)

| ID | Input (file `tests/inputs/ID.txt`) | What it proves | Expected | Actual | Result |
|---|---|---|---|---|---|
| N01 | `total=12.5+qty*2;` | The sample from the proposal works | 8 tokens, 0 ERROR rows | Same as expected | PASS |
| N02 | `x=(a+b)*3;` newline `y=x/2;` | Several statements, brackets, line counting | 16 tokens, 0 ERROR rows | Same as expected | PASS |
| N03 | `  price<TAB>=   19.99  ;` | Extra spaces and a tab are skipped but still count for columns | 4 tokens, 0 ERROR rows | Same as expected | PASS |
| N04 | `a=1;` newline `b=2;` newline `c=a+b;` | Three statements on three lines | 14 tokens, 0 ERROR rows | Same as expected | PASS |
| N05 | `total_cost=(unit_price-discount)/qty;` | Names with underscores, operators and brackets | 10 tokens, 0 ERROR rows | Same as expected | PASS |
| N06 | `result=(a+b)*(c-d)/2;` | A longer realistic expression | 16 tokens, 0 ERROR rows | Same as expected | PASS |

## Boundary and competing-rule tests (5)

| ID | Input (file `tests/inputs/ID.txt`) | What it proves | Expected | Actual | Result |
|---|---|---|---|---|---|
| B01 | `12.5` (no newline at the end) | DECIMAL beats INTEGER by longest match, and the scanner ends cleanly at end of input | 1 token: DECIMAL `12.5` at line 1, column 1 | Same as expected | PASS |
| B02 | `a>=b>c` | GE beats GT by longest match, and a plain `>` still works | 5 tokens: IDENTIFIER, GE, IDENTIFIER, GT, IDENTIFIER | Same as expected | PASS |
| B03 | empty file | Empty input prints only the header | Header only, 0 tokens | Same as expected | PASS |
| B04 | `a+b*2-c/d` | Adjacent tokens with no spaces are separated correctly | 9 tokens, 0 ERROR rows | Same as expected | PASS |
| B05 | `12abc 7up` | Digits followed by letters split into INTEGER plus IDENTIFIER | 4 tokens: INTEGER `12`, IDENTIFIER `abc`, INTEGER `7`, IDENTIFIER `up` | Same as expected | PASS |

## Invalid-input tests (4)

| ID | Input (file `tests/inputs/ID.txt`) | What it proves | Expected | Actual | Result |
|---|---|---|---|---|---|
| E01 | `7 @ 8` | An unsupported character between valid tokens is reported and scanning continues | 2 tokens, 1 ERROR row (`@` at line 1, column 3) | Same as expected | PASS |
| E02 | `rate=7#2;` | An unsupported character with no spaces around it | 5 tokens, 1 ERROR row (`#` at line 1, column 7) | Same as expected | PASS |
| E03 | `3.` newline `.5` | A dot without digits on both sides is rejected | 2 tokens, 2 ERROR rows (`.` at line 1, column 2 and `.` at line 2, column 1) | Same as expected | PASS |
| E04 | `$$$` | Several errors in a row give one ERROR row per character | 0 tokens, 3 ERROR rows (columns 1, 2 and 3) | Same as expected | PASS |

## Summary

| Kind | Tests | Passed |
|---|---|---|
| Normal | 6 | 6 |
| Boundary or competing rule | 5 | 5 |
| Invalid | 4 | 4 |
| **Total** | **15** | **15** |