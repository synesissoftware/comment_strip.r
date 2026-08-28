# comment_strip.r - TODO <!-- omit in toc -->


## Functional improvements

* [ ] `**C**`:
  * [ ] preserve a trailing lone `/` at EOF (pending `:slash_start` must flush; see **test/unit/tc_strip_c_defects.rb**);
  * [ ] unterminated `/* …` must still emit buffered newlines under the line-preserving policy (see **tc_strip_c_defects.rb**);
  * [ ] count `\r\n` inside block comments as one line break when restoring newlines (CRLF currently doubles `cc_lines`; see **tc_strip_c_defects.rb**);
  * [ ] treat C++14 digit separators (`1'000`) as digits, not character literals, so following `//` / `/*` still strip (see **tc_strip_c_defects.rb**);
  * [ ] apply backslash-newline splicing (translation phase 2) before comment recognition (see **tc_strip_c_defects.rb**);
  * [ ] either implement — or stop claiming — Go raw `` `…` ``, C# verbatim `@"…"`, Rust lifetimes, and C++ raw `R"(…)"` quoting (see **tc_strip_c_defects.rb** and rdoc on `CommentStrip.strip`);
  * [ ] **C / dispatch:** fix `strip` unrecognised-family message typo (`supported1` → `supported`; see **tc_strip_c_defects.rb**);
* [ ] `**Hash_Line**`:
  * [ ] replace the C one-character `'` machine with real single-quoted string lexing so `''`, `'alice'`, and `'it\'s'` close correctly and a following `#` is a comment (see **test/unit/tc_strip_hash_line_defects.rb**);
  * [ ] protect `#` inside Python `'''…'''` / document limits if triple-quoting stays out of scope (see **tc_strip_hash_line_defects.rb**);
  * [ ] protect `#` inside Ruby `%q{…}` / `%q(…)` / `%w[…]` (or narrow the README family claim; see **tc_strip_hash_line_defects.rb**);
  * [ ] protect `#` inside Ruby heredocs (or narrow the README family claim; see **tc_strip_hash_line_defects.rb**);
* [ ] **other**:
  * [ ] quiet the assigned-but-unused variable warning in **lib/comment_strip/language_families/hash_line.rb** (`cc_lines`, `line`, `column`, `skip`; Ruby 3.4 `-W` / CI **Warnings** job);
  * [ ] quiet the duplicate `when :hash_comment` warning in **lib/comment_strip/language_families/hash_line.rb** (Ruby 3.4 `-W` / CI **Warnings** job);
  * [ ] quiet the assigned-but-unused variable warning in **lib/comment_strip/language_families/c.rb** (`line`, `column`; Ruby 3.4 `-W` / CI **Warnings** job);
  * [ ] quiet the assigned-but-unused variable warning in **test/unit/tc_strip_c.rb** (`actual`; Ruby 3.4 `-W` / CI **Warnings** job);


## Performance improvements

* \<none>


## Packaging improvements

* [x] ~~~Rename gemspec so the filename stem matches `spec.name` (`comment_strip.gemspec` → **comment_strip-ruby.gemspec**)~~~;
* [x] ~~~updated **run_all_unit_tests.sh** (from **misc-dev-scripts**) to skip `tput` when `$TERM` is unset or stdout is not a TTY~~~;
* [x] ~~~**Gemfile** `lockfile false`; stop tracking **Gemfile.lock**; CI `bundler-cache: false`~~~;
* [x] ~~~gemspec polish: README tagline as `spec.summary`, drop `< 4` upper bound, package docs, exclude **Gemfile.lock** / **.ruby-version**~~~;
* [x] ~~~README canonical structure (tagline before badges; **Dependencies**; CI badge → **ruby.yml**)~~~;
* [x] ~~~after the packaging/boilerplate/CI baseline: bump **VERSION** to **0.2.1** and align **CHANGES**/**NEWS**~~~;


<!-- ########################### end of file ########################### -->
