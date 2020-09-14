#! /usr/bin/env ruby

$:.unshift File.join(File.dirname(__FILE__), '../..', 'lib')


require 'comment_strip'

require 'xqsr3/extensions/test/unit'

require 'test/unit'

class Test_strip_1 < Test::Unit::TestCase

    include ::CommentStrip

    def test_nil

        assert_nil strip(nil, 'C')
    end

    def test_unrecognised_families

        unrecognised_families = %w{

            Python
            Perl
            Ruby

            Java
            Kotlin
            Scala

            Rust
        }

        unrecognised_families.each do |family|

            assert_raise_with_message(::RuntimeError, /family.*unrecognised/) { strip('', family) }
        end
    end

    def test_empty

        assert_equal "", strip('', 'C')
    end

    def test_simple_main

        input = <<-EOF_main
#include <stdio.h>
int main(int argc, char* argv[])
{
    return 0;
}
EOF_main
        expected = input

        assert_equal expected, strip(input, 'C')
    end

    def test_simple_main_with_trailing_cppcomment

        input = <<-EOF_main
#include <stdio.h>
int main(int argc, char* argv[])
{
    return 0; // same as EXIT_SUCCESS
}
EOF_main
        expected = <<-EOF_main
#include <stdio.h>
int main(int argc, char* argv[])
{
    return 0; 
}
EOF_main

        assert_equal expected, strip(input, 'C')
    end

    def test_simple_main_with_trailing_cppcomment_and_divide_maths

        input = <<-EOF_main
#include <stdio.h>
int main(int argc, char* argv[])
{
    return 0 / 1; // same as EXIT_SUCCESS
}
EOF_main
        expected = <<-EOF_main
#include <stdio.h>
int main(int argc, char* argv[])
{
    return 0 / 1; 
}
EOF_main

        assert_equal expected, strip(input, 'C')
    end

    def test_simple_main_with_ccomment

        input = <<-EOF_main
#include <stdio.h>
int main(int argc, char* argv[])
{
    return 2; /* same as EXIT_SUCCESS */
}
EOF_main
        expected = <<-EOF_main
#include <stdio.h>
int main(int argc, char* argv[])
{
    return 2; 
}
EOF_main

        assert_equal expected, strip(input, 'C')
    end

    def test_ccomment_inline

        input = 'int i = func(/*x=*/x, /*y=*/y);'
        expected = 'int i = func(x, y);'

        assert_equal expected, strip(input, 'C')
    end

    def test_multiline_1

        input = <<-EOF_main

/** Some function description
 */
int func();
EOF_main
        expected = <<-EOF_main


int func();
EOF_main

        assert_equal expected, strip(input, 'C')
    end

    def test_multiline_2

        input = <<-EOF_main

/** Some function description
 */
int func();

/** Some other function description
 */
int fn();
EOF_main
        expected = <<-EOF_main


int func();


int fn();
EOF_main

        assert_equal expected, strip(input, 'C')
    end
end

# ############################## end of file ############################# #

