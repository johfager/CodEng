require './parser.rb'
require 'test/unit'
# This file is run in the terminal with the following command:
# "ruby test.rb"
# Due to testcases being executed in a different way then using "run.rb" with a file
# Some functionality can't be optimally tested (for example functions).
# The "Språkdokumentation" should include examples for all functionality however.

class TestFaculty < Test::Unit::TestCase
    def test_assign
        parser = CodEng.new()
        parser.test('Make first equal to 5.') # hej = 5
        assert_equal(5, (parser.test("Return the value of first.")))
        parser.test('Make x equal to first.')

        assert_equal(5, parser.test("Return the value of first."))

        assert_equal("first", parser.test("Return the value of x."))

        parser.test('Make x2 equal to the value of first.') # x2 = 5
        assert_equal(5, parser.test('Return the value of x2.'))

        parser.test('Make abc equal to bengt.')
        assert_equal("bengt", parser.test('Return the value of abc.'))
    end

    def test_add
      parser = CodEng.new()

      parser.test("Make x equal to 5.")
      parser.test("Make x equal to the result of the value of x plus 5.")# varname + value
      assert_equal(10, parser.test("Return the value of x."))

      parser.test("Make x equal to the result of 10 plus 5.")# value + value
      assert_equal(15, parser.test("Return the value of x."))

      parser.test("Make x equal to the result of 10 plus 5 plus 5.")# add + value
      assert_equal(20, parser.test("Return the value of x."))
    end

    #FUNKAR
    def test_sub
      parser = CodEng.new()
      parser.test("Make x equal to 5.")
      assert_equal(5, parser.test("Return the value of x."))

      parser.test("Make x equal to the result of the value of x minus 2.")
      assert_equal(3, parser.test("Return the value of x."))

      parser.test("Make x equal to the result of the value of x minus 2 minus 1.")
      assert_equal(0, parser.test("Return the value of x."))
    end

    #FUNKAR
    def test_multiply
      parser = CodEng.new()
      parser.test("Make x equal to 5.")
      assert_equal(5, parser.test("Return the value of x."))

      parser.test("Make x equal to the result of the value of x multiplied with 5.")
      assert_equal(25, parser.test("Return the value of x."))

      parser.test("Make x equal to 5.")
      parser.test("Make x equal to the result of the value of x multiplied with 5 multiplied with 2.")
      assert_equal(50, parser.test("Return the value of x."))
    end

    # #FUNKAR
    def test_divide
      parser = CodEng.new()
      parser.test("Make x equal to 5.")
      assert_equal(5, parser.test("Return the value of x."))

      parser.test("Make x equal to the result of the value of x divided with 5.")
      assert_equal(1, parser.test("Return the value of x."))

      parser.test("Make x equal to 10.")
      parser.test("Make x equal to the result of the value of x divided with 5 divided with 1.")
      assert_equal(2, parser.test("Return the value of x."))
    end
    #
    # # # WIP Lägg till längre kedjor av operationer
    def test_addsub
      parser = CodEng.new()
      parser.test("Make x equal to the result of 10 plus 5 minus 5.")# +-
      assert_equal(10, parser.test("Return the value of x."))

      parser.test("Make x equal to the result of 10 minus 5 plus 5.")# -+
      assert_equal(10, parser.test("Return the value of x."))
    end

    def test_muldiv
      parser = CodEng.new()
      parser.test("Make x equal to the result of 10 multiplied with 5 divided with 10.")# */
      assert_equal(5, parser.test("Return the value of x."))

      parser.test("Make x equal to the result of 10 divided with 5 multiplied with 10.")# /*
      assert_equal(20, parser.test("Return the value of x."))
    end

    def test_addsubmuldiv
      parser = CodEng.new()
      #ALLA DESSA TESTER KÄNNS KONSTIGT ATT DEM FUNKAR ->>>> INTE LÄNGRE??
      parser.test("Make y equal to the result of 5 plus 5 multiplied with 6.") #
      assert_equal(35, parser.test("Return the value of y."))
      parser.test("Make y equal to the result of 5 plus 10 divided with 2.") #
      assert_equal(10, parser.test("Return the value of y."))

      parser.test("Make y equal to the result of 40 minus 5 multiplied with 6.") #
      assert_equal(10, parser.test("Return the value of y."))
      parser.test("Make y equal to the result of 40 minus 10 divided with 2.") #
      assert_equal(35, parser.test("Return the value of y."))

      parser.test("Make y equal to the result of 5 multiplied with 5 plus 2.") #
      assert_equal(27, parser.test("Return the value of y."))
      parser.test("Make y equal to the result of 5 multiplied with 5 minus 2.") #
      assert_equal(23, parser.test("Return the value of y."))

      parser.test("Make y equal to the result of 10 divided with 5 plus 1.") #
      assert_equal(3, parser.test("Return the value of y."))
      parser.test("Make y equal to the result of 10 divided with 5 minus 1.") #
      assert_equal(1, parser.test("Return the value of y."))
    end

    def test_parentheses
      parser = CodEng.new()
      parser.test("Make x equal to the result of (10 multiplied with 5) minus 1.")
      assert_equal(49, parser.test("Return the value of x."))

      parser.test("Make y equal to the result of (5 plus 5) multiplied with 6.")
      assert_equal(60, parser.test("Return the value of y."))

      parser.test("Make y equal to the result of 5 multiplied with 6 plus (2 multiplied with 5).")
      assert_equal(40, parser.test("Return the value of y."))

      parser.test("Make y equal to the result of 5 multiplied with 6 minus (2 multiplied with 5).")
      assert_equal(20, parser.test("Return the value of y."))

      parser.test("Make y equal to the result of 5 multiplied with (2 minus 1).")
      assert_equal(5, parser.test("Return the value of y."))

      parser.test("Make y equal to the result of 5 multiplied with (6 minus 1).")
      assert_equal(25, parser.test("Return the value of y."))

      parser.test("Make y equal to the result of 16 divided with (3 plus 1).")
      assert_equal(4, parser.test("Return the value of y."))

      parser.test("Make y equal to the result of 10 divided with (3 minus 1).")
      assert_equal(5, parser.test("Return the value of y."))
      parser.test("Make y equal to 5.")
      assert_equal(5, parser.test("Return the value of y."))

      parser.test("Make x equal to the value of y.")
      assert_equal(5, parser.test("Return the value of x."))

      parser.test("Make y equal to the result of the value of y plus 1.")
      assert_equal(6, parser.test("Return the value of y."))

      parser.test("Make y equal to the result of the value of y multiplied with 2.")
      assert_equal(12, parser.test("Return the value of y."))

      parser.test("Make y equal to the result of the value of y divided with 3.")
      assert_equal(4, parser.test("Return the value of y."))

      parser.test("Make y equal to the result of the value of y multiplied with 6 plus (2 multiplied with 5).")
      assert_equal(34, parser.test("Return the value of y."))

      parser.test("Make y equal to the result of 10 divided with (1 plus 1).")
      assert_equal(5, parser.test("Return the value of y."))
    end


    ######################
    def test_increment
      parser = CodEng.new()
      parser.test("Make x equal to 5.")
      assert_equal(5, parser.test("Return the value of x."))
      parser.test("Increment x.")
      assert_equal(6, parser.test("Return the value of x."))
    end

    def test_decrement
      parser = CodEng.new()
      parser.test("Make x equal to 5.")
      assert_equal(5, parser.test("Return the value of x."))
      parser.test("Decrement x.")
      assert_equal(4, parser.test("Return the value of x."))
    end
    ####################

    def test_print
      parser = CodEng.new()
      parser.test("Make x equal to 5.")
      parser.test("Print the value of x.")

      parser.test("Print the result of 5 plus 4.")
      parser.test("Print the result of 5 plus 4 plus 5 plus 4.")
      parser.test("Print the result of 5 multiplied with 4 plus 5 plus 4.")
    end
    #
    #####logops

    def test_greater
      parser = CodEng.new()
      parser.test("Make x equal to 5.")
      assert_equal(5, parser.test("Return the value of x."))
      assert_equal(true, parser.test("Return the result of the value of x greater than or equal to 4."))
      assert_equal(false, parser.test("Return the result of 3 greater than or equal to 4."))
      assert_equal(true, parser.test("Return the result of 4 greater than or equal to 4."))
      assert_equal(false, parser.test("Return the result of 4 greater than 4."))
      assert_equal(true, parser.test("Return the result of 6 greater than or equal to the value of x."))
    end

    def test_smaller
      parser = CodEng.new()
      parser.test("Make x equal to 5.")
      assert_equal(5, parser.test("Return the value of x."))
      assert_equal(false, parser.test("Return the result of the value of x smaller than or equal to 4."))
      assert_equal(true, parser.test("Return the result of 3 smaller than 4."))
      assert_equal(false, parser.test("Return the result of 6 smaller than the value of x."))
    end

    def test_equal
      parser = CodEng.new()
      parser.test("Make x equal to 5.")
      parser.test("Make y equal to 5.")
      assert_equal(5, parser.test("Return the value of x."))
      assert_equal(false, parser.test("Return the result of the value of x equal to 4."))
      assert_equal(false, parser.test("Return the result of 3 equal to 4."))
      assert_equal(true, parser.test("Return the result of 5 equal to the value of x."))
      assert_equal(true, parser.test("Return the result of the value of y equal to the value of x."))
    end

    def test_and
      parser = CodEng.new()
      parser.test("Make x equal to 5.")
      parser.test("Make y equal to 5.")
      assert_equal(true, parser.test("Return the result of the value of x equal to the value of y and the value of y equal to the value of x."))
    end

    # testerna ska fungera även med scope implementerat
    def test_if
      parser = CodEng.new()
      parser.test("Make x equal to 5.")
      parser.test("Make y equal to 5.")
      parser.test("If the value of x equal to 5 then:
                    Make x equal to 6.
                    stop.")
      assert_equal(6, parser.test("Return the value of x."))
      parser.test("If x equal to 7 then:
                    Make x equal to 8.
                    stop.")
      assert_equal(6, parser.test("Return the value of x."))
      parser.test("If the value of x equal to 6 then:
                    Make x equal to 8.
                    Make y equal to 6.
                    stop.")
      assert_equal(8, parser.test("Return the value of x."))
      assert_equal(6, parser.test("Return the value of y."))
      parser.test("If the value of x equal to 6 then:
                    Make y equal to 8.
                    stop.
                    Make x equal to 9.")
      assert_equal(9, parser.test("Return the value of x."))
      assert_equal(6, parser.test("Return the value of y."))
    end

    def test_else
      parser = CodEng.new()
      parser.test("Make x equal to 5.")
      parser.test("If the value of x equal to 6 then:
                    Make x equal to 6.
                    stop.
                  Otherwise:
                    Make x equal to 7.
                    stop.")
      assert_equal(7, parser.test("Return the value of x."))

      parser.test("If the value of x equal to 6 then:
                    Make x equal to 6.
                    stop.
                  Otherwise If the value of x equal to 9 then:
                    Make x equal to 7.
                    stop.
                  Otherwise:
                    Make x equal to 8.
                    stop.")

      assert_equal(8, parser.test("Return the value of x."))
    end

    def test_forloop
      parser = CodEng.new()
      parser.test("Make x equal to 5.")
      parser.test("Repeat 4 times: Increment x. stop.")
      assert_equal(9, parser.test("Return the value of x."))

      parser.test("Repeat in range 0 to 2 times: Increment x. stop.")
      assert_equal(11, parser.test("Return the value of x."))

      parser.test("Repeat with variable i 3 times: Make x equal to the result of the value of x plus the value of i. stop.")
      assert_equal(17, parser.test("Return the value of x."))
    end

    def test_whileloop
      parser = CodEng.new()
      parser.test("Make x equal to 5.")
      parser.test("Do: Increment x. As long as: the value of x not equal to 10.")
      assert_equal(10, parser.test("Return the value of x."))

      parser.test("Make x equal to 5.")
      parser.test("Do: Increment x. As long as: the value of x not equal to 5.")
      assert_equal(5, parser.test("Return the value of x."))
    end

    def round_func
      parser = CodEng.new()
      assert_equal(2.6, parser.test("Return the result of Round 2.59999 with number of decimals equal to: 1."))

      assert_equal(2.5, parser.test("Return the result of Round down 2.55 with number of decimals equal to: 1."))

      parser.test("Make x equal to 5.55.")
      assert_equal(5.6, parser.test("Return the result of Round up x with number of decimals equal to: 1"))
    end
end
