# comment_strip.r - TODO <!-- omit in toc -->


## Functional improvements

* [ ] quiet the assigned-but-unused variable warning in **lib/comment_strip/language_families/hash_line.rb** (`cc_lines`; Ruby 3.4 `-W` / CI **Warnings** job);
* [ ] quiet the duplicate `when :hash_comment` warning in **lib/comment_strip/language_families/hash_line.rb** (Ruby 3.4 `-W` / CI **Warnings** job);
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
