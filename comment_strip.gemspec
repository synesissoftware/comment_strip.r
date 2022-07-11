# gemspec for comment_strip

$:.unshift File.join(__dir__, 'lib')

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

	spec.files          =   Dir[ 'Rakefile', '{bin,examples,lib,man,spec,test}/**/*', 'README*', 'LICENSE*' ] & `git ls-files -z`.split("\0")

	bin_dir				=	File.join(__dir__, 'bin')

	spec.executables    =   Dir.entries(bin_dir).select { |f| File.file?(File.join(bin_dir, f)) }.reject { |f| f =~ /\.cmd$/i }.reject { |f| %w{ .keepdir .keep-dir }.include? f }

	spec.required_ruby_version = '~> 2'

	spec.add_runtime_dependency 'xqsr3', [ '~> 0.37', '>= 0.37.2' ]
end

