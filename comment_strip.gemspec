# ######################################################################## #
# File:     comment_strip.gemspec
#
# Purpose:  Gemspec for comment_strip.r library
#
# Created:  14th September 2020
# Updated:  15th August 2026
#
# ######################################################################## #


$:.unshift File.join(__dir__, 'lib')

require 'comment_strip/version'


Gem::Specification.new do |spec|

  spec.name         = 'comment_strip-ruby'
  spec.version      = CommentStrip::VERSION
  spec.summary      = 'comment_strip.r'
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

  spec.required_ruby_version = [ '>= 2.0', '< 4' ]

  spec.metadata = {
    'bug_tracker_uri' => 'https://github.com/synesissoftware/comment_strip.r/issues',
    'changelog_uri' => 'https://github.com/synesissoftware/comment_strip.r/blob/master/CHANGES.md',
    'homepage_uri' => 'https://github.com/synesissoftware/comment_strip.r',
    'source_code_uri' => 'https://github.com/synesissoftware/comment_strip.r',
  }

  spec.files        = Dir[ 'Rakefile', '{bin,examples,lib,man,spec,test}/**/*', 'README*', 'LICENSE*' ] & `git ls-files -z`.split("\0")

  spec.add_runtime_dependency "xqsr3", [ '>= 0.39.1', '< 1.0' ]
end


# ############################## end of file ############################# #
