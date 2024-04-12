#! /usr/bin/env ruby

# ######################################################################## #
# File:     examples/read_c_family_source.rb
#
# Purpose:  Illustrates use of `strip()` via `include` operating on the
#           contents read from a named source file
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

input_path = ARGV[0] or abort "#$0 <C-family-source-file-path>"


# ######################################################################## #
# main

stripped_form = strip(File.read(input_path), :C)

puts "stripped form of contents of '#{input_path}':\n#{stripped_form}"


# ############################## end of file ############################# #

