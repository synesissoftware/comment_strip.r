#! /usr/bin/env ruby

# ######################################################################## #
# File:     examples/read_c_family_source.rb
#
# Purpose:  Illustrates use of `strip()` via `include` operating on the
#           contents read from `$stdin`
#
# ######################################################################## #


# ######################################################################## #
# requires

require 'comment_strip'


# ######################################################################## #
# includes

include CommentStrip


# ######################################################################## #
# command-line handling

ARGV.empty? or abort "USAGE: #$0"


# ######################################################################## #
# main

stripped_form = strip($stdin.read, :C)

puts "stripped form of contents of input:\n#{stripped_form}"


# ############################## end of file ############################# #

