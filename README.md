# comment_strip.r <!-- omit in toc -->

Comment Strip, for Ruby

[![Gem Version](https://badge.fury.io/rb/comment_strip-ruby.svg)](https://badge.fury.io/rb/comment_strip-ruby)
[![Ruby](https://github.com/synesissoftware/comment_strip.r/actions/workflows/ruby.yml/badge.svg)](https://github.com/synesissoftware/comment_strip.r/actions/workflows/ruby.yml)


## Introduction

**comment_strip.r** strips comments from source text for a small set of language families. Call `CommentStrip.strip(input, language_family)` (or the equivalent instance API) with a recognised family such as `:C` or `:Hash_Line`; the library returns the input with comments removed according to that family's rules.


## Table of Contents

1. [Introduction](#introduction)
2. [Installation](#installation)
3. [Components](#components)
4. [Project Information](#project-information)


## Installation

Install directly:

```bash
$ gem install comment_strip-ruby
```

or add it to your `Gemfile`:

```plaintext
gem 'comment_strip-ruby'
```

## Components

Current version supports following language families:

* `'C'` - C-family languages, recognising `//` line and `/* … */` block comments;
* `'Hash_Line'` - Generic support for `#` line comments, as found in shell scripts and languages such as **Perl**, **Python**, and **Ruby**. **NOTE**: Does not yet provide any language-specific smarts such as she-bang comments and directive comments;


## Examples

It is as simple as the following:

```Ruby
require 'comment_strip'

stripped = CommentStrip.strip($stdin.read, :C)

puts "Stripped form of input:\n#{stripped}"
```

Several examples are provided under the **examples/** directory.


## Project Information

### RubyGems page

[**comment_strip-ruby**](https://rubygems.org/gems/comment_strip-ruby/)


### Where to get help

[GitHub Page](https://github.com/synesissoftware/comment_strip.r "GitHub Page")


### Contribution guidelines

Defect reports, feature requests, and pull requests are welcome on https://github.com/synesissoftware/comment_strip.r.


### Dependencies

+ [**xqsr3**](https://github.com/synesissoftware/xqsr3);


#### Test-only dependencies

\<none>


### Related projects

* \<none> — no sibling-language **comment_strip** ports are published in freelibs at present;


### License

**comment_strip.r** is released under the 3-clause BSD license. See [LICENSE](./LICENSE) for details.


<!-- ########################### end of file ########################### -->

