# ######################################################################## #
# File:     comment_strip/version.rb
#
# Purpose:  Version for comment_strip.r library
#
# Created:  14th September 2020
# Updated:  11th April 2024
#
# Home:     http://github.com/synesissoftware/comment_strip.r
#
# Copyright (c) 2020-2024, Matthew Wilson and Synesis Information Systems
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

    # Current version of the comment_strip.r library
    VERSION                 =   '0.2.0.1'

    private
    VERSION_PARTS_          =   VERSION.split(/[.]/).collect { |n| n.to_i } # :nodoc:
    public
    # Major version of the comment_strip.r library
    VERSION_MAJOR           =   VERSION_PARTS_[0] # :nodoc:
    # # Minor version of the comment_strip.r library
    VERSION_MINOR           =   VERSION_PARTS_[1] # :nodoc:
    # # Revision version of the comment_strip.r library
    VERSION_REVISION        =   VERSION_PARTS_[2] # :nodoc:

end # module CommentStrip

# ############################## end of file ############################# #

