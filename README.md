# comment_strip.r <!-- omit in toc -->

Comment Strip, for Ruby

![Language](https://img.shields.io/badge/Ruby-CC342D?style=flat&logo=ruby&logoColor=white)
[![License](https://img.shields.io/badge/License-BSD_3--Clause-blue.svg)](https://opensource.org/licenses/BSD-3-Clause)
[![Gem Version](https://badge.fury.io/rb/comment_strip-ruby.svg)](https://badge.fury.io/rb/comment_strip-ruby)
[![Last Commit](https://img.shields.io/github/last-commit/synesissoftware/comment_strip.r)](https://github.com/synesissoftware/comment_strip.r/commits/master)
[![Ruby](https://github.com/synesissoftware/comment_strip.r/actions/workflows/ruby.yml/badge.svg)](https://github.com/synesissoftware/comment_strip.r/actions/workflows/ruby.yml)


## Table of Contents <!-- omit in toc -->

- [Introduction](#introduction)
- [Installation](#installation)
- [Components](#components)
- [Examples](#examples)
- [Project Information](#project-information)
  - [Where to get help](#where-to-get-help)
  - [Contribution guidelines](#contribution-guidelines)
  - [Dependencies](#dependencies)
    - [Efferent (fan-out)](#efferent-fan-out)
      - [Runtime Dependencies (aka "Normal Dependencies")](#runtime-dependencies-aka-normal-dependencies)
      - [Development Dependencies](#development-dependencies)
    - [Afferent (fan-in)](#afferent-fan-in)
      - [Runtime dependents](#runtime-dependents)
      - [Development dependents](#development-dependents)
  - [Related projects](#related-projects)
  - [License](#license)


## Introduction

**comment_strip.r** strips comments from source text for a small set of language families. Call `CommentStrip.strip(input, language_family)` (or the equivalent instance API) with a recognised family such as `:C` or `:Hash_Line`; the library returns the input with comments removed according to that family's rules.


## Installation

Install via **gem** as in:

```
gem install comment_strip-ruby
```

or add it to your `Gemfile`.


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

Examples are provided in the ```examples``` directory. A detailed list TOC of them is provided in [EXAMPLES.md](./EXAMPLES.md).


## Project Information


### Where to get help

[GitHub Page](https://github.com/synesissoftware/comment_strip.r "GitHub Page")


### Contribution guidelines

Defect reports, feature requests, and pull requests are welcome on https://github.com/synesissoftware/comment_strip.r.


### Dependencies


#### Efferent (fan-out)

Libraries upon which **comment_strip.r** depends:


##### Runtime Dependencies (aka "Normal Dependencies")

* [**xqsr3**](https://github.com/synesissoftware/xqsr3);


##### Development Dependencies

* [**rake**](https://rubygems.org/gems/rake);
* [**test-unit**](https://rubygems.org/gems/test-unit);


#### Afferent (fan-in)

Projects that depend on **comment_strip.r**:


##### Runtime dependents

* \<none>;


##### Development dependents

* \<none>;


### Related projects

* \<none> — no sibling-language **comment_strip** ports are published in freelibs at present;


### License

**comment_strip.r** is released under the 3-clause BSD license. See [LICENSE](./LICENSE) for details.


<!-- ########################### end of file ########################### -->
