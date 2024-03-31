# ######################################################################## #
# File:     comment_strip/language_families/hash_line.rb
#
# Purpose:  Definition of strip() function for languages that support single
#           line comments beginning at the # character.
#
# Created:  1st December 2023
# Updated:  31st March 2024
#
# Home:     http://github.com/synesissoftware/comment_strip.r
#
# Copyright (c) 2023-2024, Matthew Wilson and Synesis Information Systems
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

  def self.strip input, lf, **options

    return input if input.nil?
    return input if input.empty?

    line    =   0
    column  =   0

    # States:
    #
    # - :dq_string          - within a double-quoted string
    # - :dq_string_escape   - within a double-quoted string when just received a '"', e.g. from immediately after '"the next word is quoted \'
    # - :hash_comment       - in a #-comment, i.e. from immediately after "#"
    # - :sq_string_closing  - waiting for final '\'' in a single-quoted string
    # - :sq_string_escape   - within a escaped single-quoted string, i.e. from immediately after "'\"
    # - :sq_string_open     - within a single-quoted string, i.e. from immediately after "'"
    # - :text               - regular part of the code

    state   =   :text

    r       =   ''

    cc_lines =   0

    input.each_char do |c|

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
        when :hash_comment

          state = :text
        end
      else

        # special cases:
        #
        # - for escaped single/double quote
        # - for slash-start

        case state
        when :sq_string_open

          state = (?\\ == c) ? :sq_string_escape : :sq_string_closing
        when :sq_string_escape

          state = :sq_string_closing
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


      case state
      when :hash_comment

        ;
      else

        r << c unless skip
      end
    end

    r
  end
end # module HashLine

end # module LanguageFamilies
end # module CommentStrip

# ############################## end of file ############################# #

