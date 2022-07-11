# ######################################################################## #
# File:         comment_strip/strip.rb
#
# Purpose:      Definition of strip() function
#
# Created:      14th September 2020
# Updated:      11th July 2022
#
# Home:         http://github.com/synesissoftware/comment_strip.r
#
# Copyright (c) 2020-2022, Matthew Wilson and Synesis Information Systems
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

    # Strips comments from an input string, according to the rules and
    # conventions of a given language-family
    #
    # === Signature
    #
    # * *Parameters:*
    #   - +s+ (::String) the source code
    #   - +lf+ (::String) the name of the language family. Currently only
    #      the value +'C'+ is accepted
    #   - +options+ (::Hash) options that moderate the behaviour
    #
    # * *Options:*
    # None currently defined.
    #
    def self.strip s, lf, **options

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

        cc_lines =   0

        s.each_char do |c|

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
                when :c_comment, :c_comment_star

                    cc_lines += 1

                    state = :c_comment
                when :cpp_comment

                    state = :text
                when :sq_string, :sq_string_escape, :sq_string_closing

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
                            end
                        when '*'

                            case state
                            when :slash_start

                                state = :c_comment
                            when :c_comment

                                state = :c_comment_star
                            else

                            end

                        when ?\'

                            case state
                            when :text

                                state = :sq_string_open
                            when :sq_string_closing

                                state = :text
                            else

                            end
                        when '"'

                            case state
                            when :text

                                state = :dq_string
                            when :dq_string

                                state = :text
                            else
                            end
                        when ?\\

                            case state
                            when :sq_string_open

                                state = :sq_string_escape
                            when :sq_string_escape

                                state = :sq_string
                            when :dq_string

                                state = :dq_string_escape
                            else

                            end
                        else

                            case state
                            when :sq_string_escape

                                state = :sq_string_closing
                            else

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

            else

                r << c unless skip
            end
        end

        r
    end

    # Strips comments
    def strip s, lf, **options

        ::CommentStrip.strip s, lf, **options
    end

end # module CommentStrip

# ############################## end of file ############################# #

