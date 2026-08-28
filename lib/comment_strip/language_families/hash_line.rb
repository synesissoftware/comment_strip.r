# frozen_string_literal: true
# ######################################################################## #
# File:     comment_strip/language_families/hash_line.rb
#
# Purpose:  Definition of strip() function for languages that support single
#           line comments beginning at the # character.
#
# Created:  1st December 2023
# Updated:  28th August 2026
#
# Home:     https://github.com/synesissoftware/comment_strip.r
#
# Copyright (c) 2023-2026, Matthew Wilson and Synesis Information Systems
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

module HashLine

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
    # - :dq_string            - within a double-quoted string
    # - :dq_string_escape     - within a double-quoted string when just received a '"', e.g. from immediately after '"the next word is quoted \'
    # - :hash_comment         - in a #-comment, i.e. from immediately after "#"
    # - :heredoc_body         - within a Ruby heredoc body
    # - :heredoc_header       - within a Ruby heredoc header
    # - :percent_string       - within a Ruby percent string
    # - :percent_string_open  - waiting for the opening delimiter of a Ruby percent string
    # - :sq_string_closing    - waiting for final '\'' in a single-quoted string
    # - :sq_string_escape     - within a escaped single-quoted string, i.e. from immediately after "'\"
    # - :sq_string_open       - within a single-quoted string, i.e. from immediately after "'"
    # - :text                 - regular part of the code

    state   =   :text

    r       =   String.new(encoding: input.encoding)

    percent_open = nil
    percent_closing = nil
    heredoc_terminator = nil
    at_line_start = true

    i = 0
    while i < input.length
      c = input[i]
      percent_start = false

      if :text == state && '%' == c
        percent_type = input[i + 1]
        percent_delimiter = input[i + 2]

        if [ 'q', 'w', ].include?(percent_type) && percent_delimiter
          percent_open = percent_delimiter
          percent_closing = case percent_delimiter
                            when '{' then '}'
                            when '[' then ']'
                            when '(' then ')'
                            else percent_open
                            end
          percent_start = true
        end
      end

      if :text == state && '<' == c && '<' == input[i + 1]
        heredoc_offset = i + 2
        heredoc_offset += 1 if '~' == input[heredoc_offset]
        heredoc_quote = input[heredoc_offset]
        heredoc_quote = nil unless [ '\'', '"', ].include?(heredoc_quote)
        heredoc_offset += 1 if [ '\'', '"', ].include?(heredoc_quote)
        heredoc_start = heredoc_offset

        while heredoc_offset < input.length && identifier_character?(input[heredoc_offset])
          heredoc_offset += 1
        end

        if heredoc_start < heredoc_offset && (!heredoc_quote || heredoc_quote == input[heredoc_offset])
          heredoc_terminator = input[heredoc_start...heredoc_offset]
          state = :heredoc_header
        end
      end

      case c
      when ?\r, ?\n

        line += 1
        column = 0
      else

        column += 1
      end

      skip = false

      case c
      when ?\r, ?\n

        case state
        when :hash_comment

          state = :text
        when :sq_string_escape, :sq_string_closing

          state = :text
        when :dq_string_escape

          state = :dq_string
        when :heredoc_header

          state = :heredoc_body
        end
      else

        # special cases:
        #
        # - for escaped single/double quote
        # - for slash-start

        case state
        when :heredoc_body

          if at_line_start
            heredoc_match = true
            heredoc_index = 0

            while heredoc_index < heredoc_terminator.length
              heredoc_match = false unless input[i + heredoc_index] ==
                                            heredoc_terminator[heredoc_index]
              heredoc_index += 1
            end

            if heredoc_match && [ nil, ?\r, ?\n, ].include?(input[i + heredoc_terminator.length])
              state = :text
            end
          end
        when :percent_string_open

          state = :percent_string if c == percent_open
        when :percent_string

          state = :text if c == percent_closing
        when :sq_string_open

          case c
          when ?\\
            state = :sq_string_escape
          when ?\'
            state = :text
          end
        when :sq_string_escape

          state = :sq_string_open
        when :dq_string_escape

          state = :dq_string
        else

          case c
          when '#'

            case state
            when :text

              state = :hash_comment
            else

              ;
            end
          when ?\'

            case state
            when :text

              state = :sq_string_open
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


      case state
      when :hash_comment

        ;
      else

        r << c unless skip
      end

      state = :percent_string_open if percent_start
      at_line_start = ?\r == c || ?\n == c
      i += 1
    end

    r
  end
end # module HashLine

end # module LanguageFamilies
end # module CommentStrip

# ############################## end of file ############################# #

