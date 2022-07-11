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


require File.join(__dir__, 'language_families', 'c')

require 'xqsr3/quality/parameter_checking'

=begin
=end

module CommentStrip

    include ::Xqsr3::Quality::ParameterChecking

    # Strips comments from an input string, according to the rules and
    # conventions of a given language-family
    #
    # === Signature
    #
    # * *Parameters:*
    #   - +input+ (::String, +nil+) the input source code
    #   - +lf+ (::String) the name of the language family. Currently only
    #      the value +'C'+ is accepted
    #   - +options+ (::Hash) options that moderate the behaviour
    #
    # * *Options:*
    # None currently defined.
    #
    # === Signature
    # (String) The stripped for of the input.
    def strip input, lf, **options

        check_parameter input, 'input', responds_to: [ :each_char, :empty?, :nil?, ], nil: true
        check_parameter lf, 'lf', types: [ ::String, ::Symbol ]

        case lf.to_s.upcase
        when 'C'

            LanguageFamilies::C.strip input, lf, **options
        else

            raise "language family '#{lf}' unrecognised or not supported1"
        end
    end

    extend self
end # module CommentStrip

# ############################## end of file ############################# #

