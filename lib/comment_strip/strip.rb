# ######################################################################## #
# File:         comment_strip/strip.rb
#
# Purpose:      Definition of strip() function
#
# Created:      14th September 2020
# Updated:      14th September 2020
#
# Home:         http://github.com/synesissoftware/comment_strip.r
#
# Copyright (c) 2020, Matthew Wilson and Synesis Information Systems
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



=begin
=end

module CommentStrip

# Strips comments
def strip s, lf, *options

    case lf.upcase
    when 'C'

        ;
    else

        raise "language family '#{lf}' unrecognised"
    end

    return nil if s.nil?
    return s if s.empty?

    line    =   0
    column  =   0

    state   =   :text

    r       =   ''

    c_lines =   0

    s.each_char do |c|

        skip = false

        case c
        when ?\r, ?\n

            line += 1
            column = 0

            case state
            when :c_comment, :c_comment_star

                c_lines += 1
            end

            case state
            when :cpp_comment

                state = :text
            end
        else

            column += 1

            case c
            when '/'

                case state
                when :text

                    state = :slash_start
                when :slash_start

                    state = :cpp_comment
                when :c_comment_star

                    r << ?\n * c_lines
                    c_lines = 0

                    state = :text
                    skip = true
                end
            when '*'

                case state
                when :slash_start

                    state = :c_comment
                when :c_comment

                    state = :c_comment_star
                else

                end
            else

                case state
                when :slash_start

                    state = :text
                    r << '/'
                when :c_comment_star

                    state = :c_comment
                else

                end
            end
        end

        case state
        when :slash_start
        when :cpp_comment
        when :c_comment
        when :c_comment_star

        else

            r << c unless skip
        end
    end

    r
end

end # module CommentStrip

# ############################## end of file ############################# #

