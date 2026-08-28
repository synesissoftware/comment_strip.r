#! /usr/bin/env ruby

$:.unshift File.join(__dir__, '../..', 'lib')


require 'comment_strip'

require 'xqsr3/extensions/test/unit'

require 'test/unit'

# Contractual expectations that currently fail against
# LanguageFamilies::HashLine. These cases document known defects for the
# README-claimed Ruby / Python / shell family; do not weaken the expectations
# to match buggy output — fix the scanner instead.
class Test_HashLine_strip_defects < Test::Unit::TestCase

  include ::CommentStrip


  # --- Empty and escaped single-quoted strings ------------------------------
  #
  # The scanner reuses the C one-character-literal machine for `'…'`, which
  # is wrong for Ruby / Python / shell string literals.

  def test_empty_single_quoted_string_then_hash_comment

    # '' must open and immediately close a string; the following # is a
    # comment.
    input = "x='' # comment\n"
    expected = "x='' \n"

    assert_equal expected, strip(input, :Hash_Line)
  end

  def test_empty_single_quoted_string_mid_statement_then_hash_comment

    input = "a=''; b=2 # comment\n"
    expected = "a=''; b=2 \n"

    assert_equal expected, strip(input, :Hash_Line)
  end

  def test_escaped_quote_inside_single_quoted_string_then_hash_comment

    # Ruby / Python-style escaped quote inside '...'; # after the closing
    # quote is a comment.
    input = "s='it\\'s' # comment\n"
    expected = "s='it\\'s' \n"

    assert_equal expected, strip(input, :Hash_Line)
  end

  def test_adjacent_empty_single_quoted_strings_then_hash_comment

    # ''+'' must be two empty strings; # after them is a comment. The
    # one-character-literal machine treats the second quote of each '' as
    # the character body and never returns to :text for the #.
    input = "x = ''+'' # comment\n"
    expected = "x = ''+'' \n"

    assert_equal expected, strip(input, :Hash_Line)
  end


  # --- Language-specific quoting claimed by README (Ruby / Python / shell) --

  def test_python_triple_single_quotes_protect_hash

    input = "s = '''a # b'''\n"
    expected = "s = '''a # b'''\n"

    assert_equal expected, strip(input, :Hash_Line)
  end

  def test_python_triple_single_quotes_then_real_comment

    input = "s = '''a # b''' # real\n"
    expected = "s = '''a # b''' \n"

    assert_equal expected, strip(input, :Hash_Line)
  end

  def test_ruby_percent_q_braces_protect_hash

    input = "s = %q{a # b}\n"
    expected = "s = %q{a # b}\n"

    assert_equal expected, strip(input, :Hash_Line)
  end

  def test_ruby_percent_q_braces_then_real_comment

    input = "s = %q{a # b} # real\n"
    expected = "s = %q{a # b} \n"

    assert_equal expected, strip(input, :Hash_Line)
  end

  def test_ruby_percent_w_brackets_protect_hash

    input = "a = %w[one # two]\n"
    expected = "a = %w[one # two]\n"

    assert_equal expected, strip(input, :Hash_Line)
  end

  def test_ruby_percent_q_parentheses_protect_hash

    input = "s = %q(a # b)\n"
    expected = "s = %q(a # b)\n"

    assert_equal expected, strip(input, :Hash_Line)
  end

  def test_ruby_heredoc_protects_hash

    input = <<-EOF
s = <<~TXT
a # not comment
TXT
# real comment
EOF
    expected = <<-EOF
s = <<~TXT
a # not comment
TXT

EOF

    assert_equal expected, strip(input, :Hash_Line)
  end

  def test_ruby_heredoc_single_quoted_protects_hash

    input = <<-EOF
s = <<~'TXT'
a # not comment
TXT
x = 1 # real
EOF
    expected = <<-EOF
s = <<~'TXT'
a # not comment
TXT
x = 1 
EOF

    assert_equal expected, strip(input, :Hash_Line)
  end
end

# ############################## end of file ############################# #
