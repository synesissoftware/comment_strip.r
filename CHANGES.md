# comment_strip.r - Changes <!-- omit in toc -->


## 0.2.1 - 19th August 2026

* renamed **comment_strip.gemspec** to **comment_strip-ruby.gemspec** so the filename stem matches `spec.name`;
* **comment_strip-ruby.gemspec**: `required_ruby_version` is the range `>= 2.0` (dropped `< 4`); **Gemfile.lock** and **.ruby-version** excluded from `spec.files`; `spec.summary` matches the README tagline; packaged **AUTHORS**, **CHANGES**, **CONTRIBUTING**, **EXAMPLES**, **FAQ**, **INSTALL**, **NEWS**, **SECURITY**, **TODO**; runtime **xqsr3** is `>= 0.39.5`, `< 1.0`;
* **Gemfile** sets `lockfile false` when Bundler supports it; stop tracking **Gemfile.lock**;
* CI uses `bundler-cache: false` and explicit `bundle install`; **Warnings** job on Ruby **3.4**; `gem build comment_strip-ruby.gemspec`;
* **README.md**: tagline before badges; canonical five-badge row; TOC after badges; nested **Dependencies** (Efferent / Afferent);
* **EXAMPLES.md** catalogues **./examples/read_c_family_source.rb** and **./examples/read_c_family_source_from_stdin.rb**;
* library source `Home:` URLs now use `https`;
* **lib/** language-family `strip` methods build the result with `String.new` so frozen string literals (Ruby **3.4** / `# frozen_string_literal: true`) do not raise `FrozenError`;
* updated **run_all_unit_tests.sh** (from https://github.com/synesissoftware/misc-dev-scripts) to skip **tput** when **$TERM** is unset or stdout is not a TTY;


## 0.2.0.1 - 11th April 2024

* added `# frozen_string_literal: true` to all **lib/** sources;
* various boilerplate improvements;
* fixed an unused test;


## 0.2.0 - 31st March 2024

* added `:hash_line` language-family support;
* tidied `LanguageFamilies::C#strip()`;


## 0.1.2.1 - 1st December 2023

* updated dependencies;


## 0.1.2 - 11th July 2022

* prepared for supporting multiple languages;


## 0.1.1 - 11th February 2021

* removed currently unneeded dependencies;
* added **.ruby-version-exclusions** (for `--rbenv-versions`);


## 0.1.0 - 10th February 2021

* added `strip()` as a module method (exposed method);


## 0.0.13 - 14th September 2020

* more test cases;


## 0.0.7 - 14th September 2020

* more work for multiline C-comments;


<!-- ########################### end of file ########################### -->
