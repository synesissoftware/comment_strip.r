#! /usr/bin/env ruby

require 'comment_strip'

stripped = CommentStrip.strip($stdin.read, 'C')

puts "Stripped form of input:\n#{stripped}"
