#! /usr/bin/env ruby

$:.unshift File.join(__dir__, '../..', 'lib')


require 'comment_strip'

require 'xqsr3/extensions/test/unit'

require 'test/unit'

# Contractual / line-preserving expectations that currently fail against
# LanguageFamilies::C. These cases document known defects; do not weaken the
# expectations to match the buggy output — fix the scanner instead.
class Test_C_strip_defects < Test::Unit::TestCase

  include ::CommentStrip


  # --- End-of-input / unterminated constructs --------------------------------

  def test_trailing_slash_at_eof_is_preserved_after_identifier

    # A lone '/' that never becomes '//' or '/*' must remain in the output.
    assert_equal 'a/', strip('a/', 'C')
  end

  def test_trailing_slash_at_eof_alone_is_preserved

    assert_equal '/', strip('/', 'C')
  end

  def test_trailing_slash_at_eof_after_spaces_is_preserved

    assert_equal 'x = y /', strip('x = y /', 'C')
  end

  def test_unterminated_block_comment_preserves_embedded_newlines

    # Line-preserving policy: newlines inside an open /* … */ that never
    # closes should still appear in the output (as blank lines), matching the
    # behaviour used when the comment *does* close.
    input = "before/*\nline2\nline3"
    expected = "before\n\n"

    assert_equal expected, strip(input, 'C')
  end


  # --- CRLF / line-ending fidelity ------------------------------------------

  def test_crlf_inside_block_comment_counts_as_one_line_break

    # One Windows line break inside a block comment must contribute one
    # preserved newline, not one per CR and LF byte.
    input = "a/*\r\nb*/c"
    expected = "a\nc"

    assert_equal expected, strip(input, 'C')
  end

  def test_crlf_only_block_comment_body_preserves_single_blank_line

    input = "/*\r\n*/\r\nint x;\r\n"
    expected = "\n\r\nint x;\r\n"

    assert_equal expected, strip(input, 'C')
  end

  def test_multiple_crlf_lines_inside_block_comment

    input = "start/*\r\none\r\ntwo\r\n*/end"
    expected = "start\n\n\nend"

    assert_equal expected, strip(input, 'C')
  end


  # --- C++ digit separators (apostrophe is not a character literal) ---------

  def test_cxx14_digit_separator_does_not_swallow_following_line_comment

    # 1'000 uses '\'' as a digit separator between digits — there is no
    # closing quote. The trailing // comment must still be stripped.
    input = "int x = 1'000; // one thousand\n"
    expected = "int x = 1'000; \n"

    assert_equal expected, strip(input, 'C')
  end

  def test_cxx14_digit_separator_does_not_swallow_following_block_comment

    input = "long y = 1'000; /* million */\n"
    expected = "long y = 1'000; \n"

    assert_equal expected, strip(input, 'C')
  end


  # --- Translation-phase / line-splice fidelity (C family claim) ------------

  def test_backslash_newline_splices_before_line_comment_recognition

    # In C/C++, backslash-newline is removed in translation phase 2, before
    # comments are recognised. So the following is one // comment spanning
    # both physical lines; `int x;` must not survive as code.
    input = "// comment continues \\\nint x;\n"
    expected = "\n"

    assert_equal expected, strip(input, 'C')
  end

  def test_backslash_newline_inside_block_comment_does_not_invent_extra_lines

    # After splicing, this is a single-line block comment with no newline.
    input = "a/* foo \\\n bar */b"
    expected = "ab"

    assert_equal expected, strip(input, 'C')
  end


  # --- Documented family breadth (rdoc / README list C#, Go, Java, Rust) ----

  def test_go_raw_string_backticks_protect_comment_markers

    # Go raw strings use `…`; // and /* inside them are not comments.
    input = "s := `// not a comment /* nor this */`; // real\n"
    expected = "s := `// not a comment /* nor this */`; \n"

    assert_equal expected, strip(input, 'C')
  end

  def test_csharp_verbatim_string_backslash_is_not_an_escape

    # In C# @"…", backslash is literal. @"\"; ends the string after one
    # backslash character; the following // is a real comment.
    input = "s = @\"\\\"; // real\n"
    expected = "s = @\"\\\"; \n"

    assert_equal expected, strip(input, 'C')
  end

  def test_rust_lifetime_then_line_comment

    # A lone Rust lifetime `'a` is not a C character literal. Stuck in the
    # one-character-literal state, // must still be recognised afterwards.
    input = "fn f<'a>() {} // lifetime\n"
    expected = "fn f<'a>() {} \n"

    assert_equal expected, strip(input, 'C')
  end

  def test_cxx_raw_string_embedded_double_quote_does_not_end_string

    # C++ R"(…)" may contain " without ending the literal.
    input = "s = R\"(\")\"; // real\n"
    expected = "s = R\"(\")\"; \n"

    assert_equal expected, strip(input, 'C')
  end


  # --- Dispatch / diagnostics -----------------------------------------------

  def test_unrecognised_family_message_has_no_typo

    begin
      strip('', 'NotAFamily')
      flunk 'expected RuntimeError'
    rescue RuntimeError => x

      assert_match(/unrecognised or not supported\z/, x.message)
      assert_no_match(/supported1/, x.message)
    end
  end
end

# ############################## end of file ############################# #
