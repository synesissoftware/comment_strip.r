# frozen_string_literal: true
# ######################################################################## #
# File:     comment_strip/language_families/c.rb
#
# Purpose:  Definition of strip() function for C-family languages.
#
# Created:  14th September 2020
# Updated:  30th August 2026
#
# Home:     https://github.com/synesissoftware/comment_strip.r
#
# Copyright (c) 2020-2026, Matthew Wilson and Synesis Information Systems
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
#
# * Redistributions of source code must retain the above copyright notice,
#   this list of conditions and the following disclaimer.
#
# * Redistributions in binary form must reproduce the above copyright
#   notice, this list of conditions and the following disclaimer in the
#   documentation and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
# IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
# THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
# PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
# CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
# EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
# PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
# LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
# NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
# ######################################################################## #


require 'xqsr3/quality/parameter_checking'

=begin
=end

module CommentStrip
module LanguageFamilies

module C

  def self.decimal_digit? character

    character && character >= ?0 && character <= ?9
  end

  def self.identifier_character? character

    return false unless character

    case character
    when ?a..?z, ?A..?Z, ?0..?9, '_'
      true
    else
      false
    end
  end

  def self.strip input, lf, **options

    return input if input.nil?
    return input if input.empty?

    line    =   0
    column  =   0

    # States:
    #
    # - :c_comment              - in a C comment, i.e. from immediately after "/*"
    # - :c_comment_star         - in a C comment when just received '*', e.g. from immediately after "/* comment *"
    # - :cpp_comment            - in a C++ comment, i.e. from immediately after "//"
    # - :dq_string              - within a double-quoted string
    # - :dq_string_escape       - within a double-quoted string when just received a '"', e.g. from immediately after '"the next word is quoted \'
    # - :raw_string             - within a C++ raw string
    # - :raw_string_closing     - waiting for the final '"' in a C++ raw string
    # - :backtick_string        - within a Go raw string
    # - :backtick_string_open   - waiting for the opening '`' in a Go raw string
    # - :lifetime               - within a Rust lifetime name
    # - :verbatim_string        - within a C# verbatim string
    # - :verbatim_string_open   - waiting for the opening '"' in a C# verbatim string
    # - :verbatim_string_quote  - waiting to determine whether a C# quote is doubled
    # - :slash_start            - having found a slash (not in a string)
    # - :sq_string_closing      - waiting for final '\'' in a single-quoted string
    # - :sq_string_escape       - within a escaped single-quoted string, i.e. from immediately after "'\"
    # - :sq_string_open         - within a single-quoted string, i.e. from immediately after "'"
    # - :text                   - regular part of the code

    state   =   :text

    r       =   String.new
    r.force_encoding input.encoding

    cc_lines =   0
    previous_was_cr = false

    i = 0
    while i < input.length
      c = input[i]

      if ?\\ == c
        next_c = input[i + 1]

        if ?\n == next_c
          i += 2
          previous_was_cr = false
          next
        elsif ?\r == next_c
          i += 2
          previous_was_cr = false

          if ?\n == input[i]
            i += 1
            next
          end

          next if i >= input.length

          c = input[i]
        end
      end

      case c
      when ?\r, ?\n

        line += 1 unless ?\n == c && previous_was_cr
        column = 0
      else

        column += 1
      end

      skip = false

      if :text == state && 'R' == c && '"' == input[i + 1] && '(' == input[i + 2]
        state = :raw_string
      elsif :text == state && '@' == c && '"' == input[i + 1]
        state = :verbatim_string_open
      elsif :text == state && i > 0 && '<' == input[i - 1] && input[i + 1] && input[i + 1] >= ?a && input[i + 1] <= ?z
        state = :lifetime
      elsif :text == state && '`' == c
        state = :backtick_string_open
      end

      case c
      when ?\r, ?\n

        case state
        when :c_comment, :c_comment_star

          cc_lines += 1 unless ?\n == c && previous_was_cr

          state = :c_comment
        when :cpp_comment

          state = :text
        when :sq_string_escape, :sq_string_closing

          state = :text
        when :dq_string_escape

          state = :dq_string
        when :slash_start

          r << '/'

          state = :text
        end
      else

        # special cases:
        #
        # - for escaped single/double quote
        # - for slash-start
        # - for comment-star

        case state
        when :backtick_string_open

          state = :backtick_string if '`' == c
        when :backtick_string

          state = :text if '`' == c
        when :lifetime

          if !identifier_character?(c)
            state = :text
          elsif !identifier_character?(input[i + 1])
            state = :text
          end
        when :verbatim_string_open

          state = :verbatim_string if '"' == c
        when :verbatim_string

          if '"' == c
            state = :verbatim_string_quote if '"' == input[i + 1]
            state = :text unless '"' == input[i + 1]
          end
        when :verbatim_string_quote

          state = :verbatim_string if '"' == c
        when :raw_string

          state = :raw_string_closing if ')' == c && '"' == input[i + 1]
        when :raw_string_closing

          state = :text if '"' == c
        when :sq_string_open

          state = (?\\ == c) ? :sq_string_escape : :sq_string_closing
        when :sq_string_escape

          state = :sq_string_closing
        when :dq_string_escape

          state = :dq_string
        when :c_comment_star

          case c
          when ?/

            r << ?\n * cc_lines
            cc_lines = 0

            state = :text
            skip = true
          when '*'

            ;
          else

            state = :c_comment
          end
        else

          if false
          elsif state == :slash_start && ('/' != c && '*' != c)

            state = :text
            r << '/'
          else

            case c
            when '/'

              case state
              when :text

                state = :slash_start
              when :slash_start

                state = :cpp_comment
              when :c_comment_star

                r << ?\n * cc_lines
                cc_lines = 0

                state = :text
                skip = true
              else

                ;
              end
            when '*'

              case state
              when :slash_start

                state = :c_comment
              when :c_comment

                state = :c_comment_star
              else

                ;
              end
            when ?\'

              case state
              when :text

                if i > 0 && decimal_digit?(input[i - 1]) && decimal_digit?(input[i + 1])
                  ;
                else
                  state = :sq_string_open
                end
              when :sq_string_closing

                state = :text
              else

                ;
              end
            when '"'

              case state
              when :text

                state = :dq_string
              when :dq_string

                state = :text
              else

                ;
              end
            when ?\\

              case state
              when :sq_string_open

                state = :sq_string_escape
              when :sq_string_escape

                state = :sq_string_closing
              when :dq_string

                state = :dq_string_escape
              else

                ;
              end
            else

              case state
              when :sq_string_escape

                state = :sq_string_closing
              else

                ;
              end
            end
          end
        end
      end


      case state
      when :slash_start
      when :cpp_comment
      when :c_comment
      when :c_comment_star

        ;
      else

        r << c unless skip
      end

      previous_was_cr = ?\r == c
      i += 1
    end

    r << '/' if :slash_start == state
    r << ?\n * cc_lines if [ :c_comment, :c_comment_star, ].include?(state)

    r
  end
end # module C

end # module LanguageFamilies
end # module CommentStrip

# ############################## end of file ############################# #

