# gemspec for comment_strip

$:.unshift File.join(File.dirname(__FILE__), 'lib')

require 'comment_strip'

require 'date'

Gem::Specification.new do |spec|

    spec.name           =   'comment_strip-ruby'
    spec.version        =   CommentStrip::VERSION
    spec.date           =   Date.today.to_s
    spec.summary        =   'comment_strip.r'
    spec.description    =   <<END_DESC
Source code comment stripping library

END_DESC
    spec.authors        =   [ 'Matt Wilson' ]
    spec.email          =   'matthew@synesis.com.au'
    spec.homepage       =   'https://github.com/synesissoftware/comment_strip.r'
    spec.license        =   'BSD-3-Clause'

    spec.required_ruby_version = '~> 2'

=begin

    spec.add_runtime_dependency 'clasp-ruby', [ '~> 0.22' ]
    spec.add_runtime_dependency 'libclimate-ruby', [ '~> 0.15' ]
    spec.add_runtime_dependency 'recls-ruby', [ '~> 2' ]
    spec.add_runtime_dependency 'xqsr3', [ '~> 0.36' ]
=end

    spec.files          =   Dir[ 'Rakefile', '{bin,examples,lib,man,spec,test}/**/*', 'README*', 'LICENSE*' ] & `git ls-files -z`.split("\0")
end

