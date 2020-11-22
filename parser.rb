#!/usr/bin/env ruby
require './rdparse.rb'
require './nodes.rb'
# Defines the language

class CodEng
  def initialize
    @codeEngParser = Parser.new("CodEng") do
      # Start Tokens

      token(/Make/) {|m| m }
      token(/equal to/) {|m| m }

      token(/the value of/) {|m| m }
      token(/the result of/) {|m| m }

      token(/input/) {|m| m}

      token(/Print/) {|m| m}
      token(/Return/) {|m| m}

      token(/plus/) {|m| m}
      token(/minus/) {|m| m}
      token(/multiplied with/) {|m| m}
      token(/divided with/) {|m| m}

      token(/Do:/) {|m| m}
      token(/As long as:/) {|m| m}

      token(/Repeat in range/) {|m| m}
      token(/Repeat with variable/) {|m| m}
      token(/Repeat/) {|m| m}
      token(/to/) {|m| m}
      token(/times:/) {|m| m}

      token(/List:/) {|m| m}
      token(/:End List/) {|m| m}
      token(/the position:/) {|m| m}
      token(/in/) {|m| m}

      token(/If/) {|m| m}
      token(/then:/) {|m| m}
      token(/Otherwise:/) {|m| m} # for else
      token(/Otherwise/) {|m| m} # for else if
      token(/stop/) {|m| m}

      token(/Start Sentence:(.*?):End Sentence/) {|m|m}

      token(/True/) {|m| m}
      token(/False/) {|m| m}

      token(/and/) {|m| m}
      token(/or/) {|m| m}

      token(/Increment/) {|m| m}
      token(/Decrement/) {|m| m}
      token(/negative/) {|m| m}

      token(/greater than/) {|m| m}
      token(/smaller than/) {|m| m}
      token(/equals/) {|m| m}
      token(/not equal to/) {|m| m}

      token(/Create/) {|m| m}
      token(/with the instructions:/) {|m| m}
      token(/with the parameters:/) {|m| m}


      token(/Round down/) {|m| m}
      token(/Round up/) {|m| m}
      token(/Round/) {|m| m}
      token(/with number of decimals equal to:/) {|m| m}

      token(/[(]/) {|m| m}
      token(/[)]/) {|m| m}

      token(/[0-9]+\.{1}[0-9]+/) {|m| m.to_f}
      token(/\d+/) {|m| m.to_i}
      token(/[\w]+/) {|m| m }
      token(/\s+/)

      token(/#[\s\S]*?$/) {|m| m}

      token(/\./) {|m| m}

      # Start Rules

      start :run do
        match(:statements)
      end

      ##### STATEMENTS ######

      rule :statements do
        match(:statement, :statements) {|a, b| Statement_node.new(a, b) }
        match(:statement)
      end

      rule :statement do
        match(:ifStatement, :end)
        match(:assign, :end)
        match(:print, :end)
        match(:increment, :end)
        match(:decrement, :end)
        match(:return, :end)
        match(:logical, :end)
        match(:math, :end)
        match(:arrayOps, :end)
        match(:ForStatement, :end)
        match(:WhileStatement, :end)
        match(:createFunction, :end)
        match(:callFunction, :end)
        match(:functions, :end)
        match(:comment)
      end

      # In code comments
      rule :comment do
        match(/#[\s\S]*?$/) {| a | Empty_node.new()}
      end

      ##### Useable functions#####
      rule :functions do
        match(:roundNumbers)
      end

      rule :roundNumbers do
        match("Round up", :varname, "with number of decimals equal to:", Integer) {|_, a, _, b| Round_func_node.new(a, b, :up)}
        match("Round up", Float, "with number of decimals equal to:", Integer) {|_, a, _, b| Round_func_node.new(a, b, :up)}
        match("Round up", Integer, "with number of decimals equal to:", Integer) {|_, a, _, b| Round_func_node.new(a, b, :up)}

        match("Round down", :varname, "with number of decimals equal to:", Integer) {|_, a, _, b| Round_func_node.new(a, b, :down)}
        match("Round down", Float, "with number of decimals equal to:", Integer) {|_, a, _, b| Round_func_node.new(a, b, :down)}
        match("Round down", Integer, "with number of decimals equal to:", Integer) {|_, a, _, b| Round_func_node.new(a, b, :down)}

        match("Round", :varname, "with number of decimals equal to:", Integer) {|_, a, _, b| Round_func_node.new(a, b)}
        match("Round", Float, "with number of decimals equal to:", Integer) {|_, a, _, b| Round_func_node.new(a, b)}
        match("Round", Integer, "with number of decimals equal to:", Integer) {|_, a, _, b| Round_func_node.new(a, b)}
      end

      ##### Functions #####

      rule :createFunction do
        match("Create", :funcName, "with the instructions:", :statements, "stop") {|_, a, _, b| Func_create_node.new(a, nil, b)}
        match("Create", :funcName, "with the parameters:", :createParameters,
              "with the instructions:", :statements,"stop") {|_, a, _, b, _, c| Func_create_node.new(a, b, c)}
      end

      rule :callFunction do
        match("Use", :funcName, "with the parameters:", :callParameters) {|_, a, _, b| Func_use_node.new(a, b)}
        match("Use", :funcName) {|_, a| Func_use_node.new(a, nil)}
      end

      rule :funcName do
        match(String) {|a| a }
      end

      rule :createParameters do
        match(:varname, "and", :createParameters) {|a, _, b| Create_param_node.new(a, b)}
        match(:varname) {|a, _, b| Create_param_node.new(a) }
      end

      rule :callParameters do
        match(:parameter, "and", :callParameters) {|a, _, b| Call_param_node.new(a, b)}
        match(:parameter) {|a, _, b| Call_param_node.new(a) }
      end

      rule :parameter do
        match(:values) {|a| Expression_node.new(a) }
      end

      ##### Iterators #####

      rule :WhileStatement do
        match("Do:", :statements, "As long as:", :logical) {|_, a, _, b| While_node.new(a, b)}
      end

      rule :ForStatement do
        match("Repeat with variable", :varname, :value, "times:", :statements, "stop") {|_, a, b, _, c, _| For_node.new(b, c, 0, a)}
        match("Repeat in range", :value, "to", :value, "times:", :statements, "stop") {|_, a, _, b, _, c, _| For_node.new(b, c, a)}
        match("Repeat", :value, "times:", :statements, "stop") {|_, a, _, b, _| For_node.new(a, b)}
      end

      ##### if #####

      rule :ifStatement do
        match("If", :logical,"then:", :statements, "stop", :end,
            :elseStatement) {|_, a, _ , b, _, _, c| IfElse_node.new(a, b, c) }

        match("If", :logical,"then:", :statements, "stop") {|_, a, _ , b, _| If_node.new(a, b) }
      end

      rule :elseStatement do
        match("Otherwise", :ifStatement) {|_, a| Statement_node.new(a) }
        match("Otherwise:", :statements, "stop") {|_, a| Statement_node.new(a) }
      end

      ##### Assign/return #####

      rule :assign do
        match("Make", :varname, "equal to", :input) {|_, a, _, b| Assign_node.new(a, b) }
        match("Make", :varname, "equal to", :values) {|_, a, _, b| Assign_node.new(a, b) }
      end

      rule :return do
        match("Return", :values) {|_, a| Retrieve_node.new(a) }
      end

      rule :input do
        match("user","input") {|_| Input_node.new()}
      end

      ###### logicals ######

      rule :logical do
        match(:and)
        match(:or)
        match(:operator)
        match(:trueFalseClass)
      end

      rule :and do
        match(:operator, "and", :logical) {|a, _, b| And_node.new(a, b) }
      end

      rule :or do
        match(:operator, "or", :logical) {|a, _, b| Or_node.new(a, b) }
      end

      rule :trueFalseClass do
        match("True") {|_| True_node.new()}
        match("False"){|_| False_node.new()}
      end

      ###### operators ######

      rule :operator do
        match(:greaters)
        match(:smallers)
        match(:equals)
        match(:not)
      end

      rule :greaters do
        match(:values, "greater than",  "or", "equal to", :values) {|a, _, _, _, b| Greater_node.new(a, b) }

        match(:values, "greater than", :values) {|a, _, b| Greaters_node.new(a, b) }
      end

      rule :smallers do
        match(:values, "smaller than", "or", "equal to", :values) {|a, _, _, _, b| Smaller_node.new(a, b) }

        match(:values, "smaller than", :values) {|a, _, b| Smallers_node.new(a, b) }
      end

      rule :equals do
        match(:values, "equal to", :values) {|a, _, b| Equals_node.new(a, b) }
      end

      rule :not do
        match(:values, "not equal to", :values) {|a, _, b| Not_node.new(a, b) }
      end
      ####################################

      rule :print do
        match("Print", :values) {|_, a| Print_node.new(a) }
      end

      ##### maths #####

      rule :math do
        match(:addsub)
        match(:muldiv)
      end

      rule :addsub do
        # Addition
        match(:values, "plus", :muldiv) {|a, _, b| Addition_node.new(a, b) }
        match(:addsub, "plus", :expr) {|a, _, b| Addition_node.new(a, b) }
        match(:addsub, "plus", :values) {|a, _, b| Addition_node.new(a, b) }
        match(:values, "plus", :values) {|a, _, b| Addition_node.new(a, b) }

        # Subtraction
        match(:values, "minus", :muldiv) {|a, _, b| Subtraction_node.new(a, b) }
        match(:addsub, "minus", :expr) {|a, _, b| Subtraction_node.new(a, b) }
        match(:addsub, "minus", :values) {|a, _, b| Subtraction_node.new(a, b) }
        match(:values, "minus", :values) {|a, _, b| Subtraction_node.new(a, b) }

        match(:muldiv)
      end

      rule :muldiv do
        # Multiplication
        match(:muldiv, "multiplied with", :expr) {|a, _, b| Multiplication_node.new(a, b) }
        match(:muldiv, "multiplied with", :values) {|a, _, b| Multiplication_node.new(a, b) }
        match(:values, "multiplied with", :expr) {|a, _, b| Multiplication_node.new(a, b) }
        match(:values, "multiplied with", :values) {|a, _, b| Multiplication_node.new(a, b) }

        # Division
        match(:muldiv, "divided with", :expr) {|a, _, b| Division_node.new(a, b) }
        match(:muldiv, "divided with", :values) {|a, _, b| Division_node.new(a, b) }
        match(:values, "divided with", :expr) {|a, _, b|  Division_node.new(a, b) }
        match(:values, "divided with", :values) {|a, _, b|  Division_node.new(a, b) }

        match(:expr)
      end

      rule :expr do
        match('(', :math, ')') {|_, a, _| Expression_node.new(a)}
        match("the result of", :callFunction) {|_, a| Expression_node.new(a)}
      end

      ###### inc/decr ######

      rule:increment do
        match("Increment", :varname) {|_, a| Increment_node.new(a)}
      end

      rule:decrement do
        match("Decrement", :varname) {|_, a| Decrement_node.new(a)}
      end

      ##### arrays #####

      rule :arrayOps do
        match(:arrayAdd)
        match(:arrayRemove)
      end

      rule :arrayAdd do
        match("Add", :value, "to", :varname) {|_, a, _, b| Array_add_node.new(a, b) }
      end

      rule :arrayRemove do
        match("Remove", :value, "from", :varname) {|_, a, _, b| Array_remove_node.new(a, b, true)}
        match("Remove", "the position:", Integer, "in", :varname) {|_, _, a, _, b| Array_remove_node.new(a, b, false)}
        match("Remove", "the position:", "the value of", :varname, "in", :varname) {|_, _, _, a, _, b| Array_remove_node.new(a, b, false)}
      end

      rule :arrayValue do
        match("the position:", "the value of", :varname, "in", :array) {|_, _, a, _, b| Array_value_node.new(b, a) }
        match("the position:", "the value of", :varname, "in", :varname) {|_, _, a, _, b| Array_value_node.new(b, a) }
        match("the position:", Integer, "in", :array) {|_, a, _, b| Array_value_node.new(b, a) }
        match("the position:", Integer, "in", :varname) {|_, a, _, b| Array_value_node.new(b, a) }
      end

      rule :array do
        match("List:", ":End List") {|| Array_node.new(nil) }
        match("List:", :arrayValues,":End List") {|_, a| Array_node.new(a) }
      end

      rule :arrayValues do
        match("the value of", :varname, "and", :arrayValues) {|_, a, _, b| [a,b].flatten(1) }
        match(:value, "and", :arrayValues) {|a, _, b| [a,b].flatten(1) }
        match("the value of", :varname) {|_, a| [a].flatten(1) }
        match(:value) {|a| [a].flatten(1) }
      end

      ###### variables ######

      rule :values do
        match("the result of", :callFunction) {|_, a| a }
        match("the result of", :functions) {|_, a| a }
        match("the result of", :math) {|_, a| a }
        match("the result of", :logical) {|_, a| a }
        match("the value of", :varname) {|_, a| a }
        match(:value)
      end

      rule :varname do
        match(String) {|a| Variable_node.new(a)}
      end

      rule :value do
        match("negative", Float) {|a, b| Float_node.new(b, a)}
        match("negative", Integer) {|a, b| Int_node.new(b, a)}
        match(:trueFalseClass) # Boolean
        match(:array)
        match(:arrayValue)
        match(/Start Sentence:(.*?):End Sentence/){ |a| String_node.new(CodEng.strip_string(a))} # String - regular string
        match(String){ |a| String_node.new(a)} # Char - Can contain one character
        match(Integer){ |a| Int_node.new(a) }
        match(Float){ |a| Float_node.new(a)}
      end

      rule :end do
        match(".")
      end
    end
  end

  def self.strip_string(str)
    str.slice! "Start Sentence:"
    str.slice! ":End Sentence"
    str.strip!
    return str
  end

  # TEST FUNCS
  def done(str)
    ["quit","exit","bye",""].include?(str.chomp)
  end

  def run
    print "[codeng] "
    str = gets
    if done(str) then
      puts "Bye."
    else
      root_node = @codeEngParser.parse str
      puts "=> #{root_node.eval}"
      run
    end
  end

  def test(str)
    root_node = @codeEngParser.parse str
    @@current_scope_list = [0]
    return root_node.eval
  end
end
