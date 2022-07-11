#! /usr/bin/env ruby

$:.unshift File.join(__dir__, '../..', 'lib')


require 'comment_strip'

require 'xqsr3/extensions/test/unit'

require 'test/unit'

class Test_version < Test::Unit::TestCase

    def test_has_VERSION

        assert defined? CommentStrip::VERSION
    end

    def test_has_VERSION_MAJOR

        assert defined? CommentStrip::VERSION_MAJOR
    end

    def test_has_VERSION_MINOR

        assert defined? CommentStrip::VERSION_MINOR
    end

    def test_has_VERSION_REVISION

        assert defined? CommentStrip::VERSION_REVISION
    end

    def test_VERSION_has_consistent_format

        assert_equal CommentStrip::VERSION.split('.')[0..2].join('.'), "#{CommentStrip::VERSION_MAJOR}.#{CommentStrip::VERSION_MINOR}.#{CommentStrip::VERSION_REVISION}"
    end
end

# ############################## end of file ############################# #

