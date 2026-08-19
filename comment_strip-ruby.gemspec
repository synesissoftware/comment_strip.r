# ######################################################################## #
# File:     comment_strip-ruby.gemspec
#
# Purpose:  Gemspec for comment_strip.r library
#
# Created:  14th September 2020
# Updated:  19th August 2026
#
# ######################################################################## #


$:.unshift File.join(File.dirname(__FILE__), 'lib')

require 'comment_strip/version'


Gem::Specification.new do |spec|

  spec.name         = 'comment_strip-ruby'
  spec.summary      = 'Comment Strip, for Ruby'
  spec.version      = CommentStrip::VERSION
  spec.description  = <<END_DESC
Source code comment stripping library
END_DESC

  spec.authors      = [
    'Matt Wilson',
  ]
  spec.email        = [
    'matthew@synesis.com.au',
  ]
  spec.homepage     = 'https://github.com/synesissoftware/comment_strip.r'
  spec.license      = 'BSD-3-Clause'

  spec.required_ruby_version = [ '>= 2.0' ]

  spec.add_runtime_dependency "xqsr3", [ '>= 0.39.5', '< 1.0' ]

  spec.metadata = {
    'bug_tracker_uri' => 'https://github.com/synesissoftware/comment_strip.r/issues',
    'changelog_uri' => 'https://github.com/synesissoftware/comment_strip.r/blob/master/CHANGES.md',
    'homepage_uri' => 'https://github.com/synesissoftware/comment_strip.r',
    'source_code_uri' => 'https://github.com/synesissoftware/comment_strip.r',
  }

  spec.files = Dir[
    'Rakefile',
    '{bin,examples,lib,man,spec,test}/**/*',
    'AUTHORS*',
    'CHANGES*',
    'CONTRIBUTING*',
    'EXAMPLES*',
    'FAQ*',
    'INSTALL*',
    'LICENSE*',
    'NEWS*',
    'README*',
    'SECURITY*',
    'TODO*',
  ] & `git ls-files -z`.split("\0")
  spec.files -= [
    '.ruby-version',
    'Gemfile.lock',
  ]
end


# ############################## end of file ############################# #
