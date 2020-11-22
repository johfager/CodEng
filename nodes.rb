

##### Scope #####
$current_scope = 0
$highest_scope = 0
$current_scope_list = [0]
$var_list = [{}]
# $func_list is is created in order for functions to be saved
$func_list = {}
##### Scope functions #####

#Returns value of variable found in var_list. if nothing is found returns nil.
def find_variable(variable)
  for scope in $current_scope_list.sort{|a, b| b <=> a}
    if $var_list[scope][variable] != nil
      return $var_list[scope][variable]
    end
  end
  return nil
end

#Returns an index to the scope which the given variable can be found
def create_variable(variable)
  for i in $current_scope_list.sort{|a, b| b <=> a}
    if $var_list[i][variable] != nil
      return i
    end
  end
  return $current_scope_list[-1]
end

#Is called when a new scope is created
def add_scope()
  $highest_scope += 1
  $current_scope_list << $highest_scope
  $var_list << {}
end

#is called when we want to close scope
def close_scope()
  $highest_scope -= 1
  $current_scope_list.pop
end

#is called when we want to close scope when exiting ex: functions
def close_var_list()
  $var_list.pop
  close_scope()
end


##### Useable functions #####
#Node for round function. Round numbers to the nearest specified amount of decimals.
 class Round_func_node
   def initialize(value, decimals, direction = nil)
     @value = value
     @decimals = decimals
     @direction = direction
   end

   def eval()
     if @decimals.is_a?(Variable_node)
       @decimals = @decimals.eval
     end
     if @value.is_a?(Variable_node)
       scope = create_variable(@value.id())
       result_value = @value.eval
       if @direction != nil
          $var_list[scope][@value.id()] = result_value.to_f.round(@decimals, half: @direction)
      else
        $var_list[scope][@value.id()] = result_value.to_f.round(@decimals)
      end
    elsif @direction != nil
      @value.to_f.round(@decimals, half: @direction)
    else
      @value.to_f.round(@decimals)
    end
  end
end
##### Statements #####
#Node for handling statements. Statements are used in loops/if-else and functions.
class Statement_node
  def initialize(*stmts)
    @stmts = stmts
  end

  def eval()
    for stmt in @stmts
      ret = stmt.eval
      if stmt.is_a? Retrieve_node
        break
      end
    end
    return ret
  end
end
#Node for expressions. Are used within functions parameters.
class Expression_node
  def initialize(nn)
    @next_node = nn
  end

  def eval()
    @next_node.eval
  end
end

##### Functions #####
#Node for creating functions.
class Func_create_node
  def initialize(name, params, stmts)
    @name = name
    @params = params
    @stmts = stmts
  end

  def eval()
    $func_list[@name] = @stmts,@params
  end
end
#Node for using functions.
class Func_use_node
  def initialize(name, params)
    @name = name
    @params = params
  end

  def eval()
    if $func_list[@name]
      stmts = $func_list[@name][0]
    else
      raise "Function #{@name} not declared"
    end

    add_scope()

    if @params
      @params.eval($func_list[@name][1])
    end

    result_value = stmts.eval()
    close_var_list()
    return result_value
end
  end
#Used when calling functions. Is used for calling the function with parameters.
class Call_param_node
  def initialize(*params)
    @params = params
  end

  def eval(vars)
    vars.eval(@params)
  end
end
#Used to create parameters for functions.
class Create_param_node
  def initialize(*params)
    @params = params
  end

  def id()
    return nil
  end

  def eval(values)
    index = 0
    for param in @params
      if param.id() == nil
        if values[index]
          values[index].eval(param)
        else
          raise "Wrong number of arguments"
        end
      else
        $var_list[$highest_scope][param.id()] = values[index].eval()
      end
      index += 1
    end
  end
end

##### if/else ######
#Node for If statements.
class If_node
  def initialize(trueValue, stmt)
    @trueValue = trueValue
    @stmt = stmt
  end

  def eval()
    if @trueValue.eval
      result_value = @stmt.eval
      return result_value
    end
  end
end
#Node for Elsif and else statements.
class IfElse_node
  def initialize(trueValue, stmt, stmt2)
    @trueValue = trueValue
    @stmt = stmt
    @stmt2 = stmt2
  end

  def eval()
    if @trueValue.eval
      result_value = @stmt.eval
      return result_value
      # @stmt.eval
    else
      result_value = @stmt2.eval
      return result_value
    end
  end
end

###### Iterators ######
#Node for creating for loops.
class For_node
  def initialize(range, stmt, start = 0, variable = nil)
    @range = range
    @stmt = stmt
    @start = start
    @variable = variable
  end

  def eval()
    if @variable
      $var_list[$current_scope][@variable.id()] = 0
    end

    iterations = @range.eval
    if @start != 0
      @start = @start.eval
    end
    while(@start < iterations)
      iterations -= 1
      if @variable
        $var_list[$current_scope][@variable.id()] = @variable.eval() + 1
      end
      result_value = @stmt.eval
    end
    return result_value
  end
end
#Node for creating while loops.
class While_node
  def initialize(stmt, whileLog)
    @stmt = stmt
    @whileLog = whileLog
  end

  def eval()
    while(@whileLog.eval)
      result_value = @stmt.eval
    end
    return result_value
  end
end

###### Logicals ######
#Node for when using multiple expressions and both needing to return true.
class And_node
  def initialize(exp1, exp2)
    @exp1 = exp1
    @exp2 = exp2
  end

  def eval()
    res = @exp1.eval && @exp2.eval
    res
  end
end
#Node for when calling two expressions. Atleast one expression needs to return true.
class Or_node
  def initialize(exp1, exp2)
    @exp1 = exp1
    @exp2 = exp2
  end

  def eval()
    res = @exp1.eval || @exp2.eval
    res
  end
end
#Node for the value True.
class True_node
  def initialize()
    @value = true
  end

  def eval()
    @value
  end
end
#Node for the value False.
class False_node
  def initialize()
    @value = false
  end

  def eval()
    @value
  end
end
#Node for using the operator ">".
class Greaters_node
  def initialize(a, b)
    @a = a
    @b = b
  end

  def eval()
    @a.eval > @b.eval
  end
end
#Node for using the operator "<".
class Smallers_node
  def initialize(a, b)
    @a = a
    @b = b
  end

  def eval()
    @a.eval < @b.eval
  end
end
#Node for using the operator ">=".
class Greater_node
  def initialize(a, b)
    @a = a
    @b = b
  end

  def eval()
    @a.eval >= @b.eval
  end
end
#Node for using the operator "<=".
class Smaller_node
  def initialize(a, b)
    @a = a
    @b = b
  end

  def eval()
    @a.eval <= @b.eval
  end
end
#Node for using the operator "==".
class Equals_node
  def initialize(a, b)
    @a = a
    @b = b
  end

  def eval()
    @a.eval == @b.eval
  end
end

#Node for using the operator "!=".
class Not_node
  def initialize(a, b)
    @a = a
    @b = b
  end

  def eval()
    @a.eval != @b.eval
  end
end
##### Maths #####
#Node for using addition.
class Addition_node
  def initialize(a, b)
    @a = a
    @b = b
  end

  def eval()
    # print("ADDITION_NODE RESULT: ", @a.eval + @b.eval)
    @a.eval + @b.eval
  end
end
#Node for using subtraction.
class Subtraction_node
  def initialize(a, b)
    @a = a
    @b = b
  end

  def eval()
    @a.eval - @b.eval
  end
end
#Node for using the multiplication.
class Multiplication_node
  def initialize(a, b)
    @a = a
    @b = b
  end

  def eval()
    @a.eval * @b.eval
  end
end
#Node for using the division.
class Division_node
  def initialize(a, b)
    @a = a
    @b = b
  end

  def eval()
    @a.eval / @b.eval
  end
end
#Node for incrementing Integers and Floats.
class Increment_node
  def initialize(a)
    @a = a
  end

  def eval()
    if @a.eval.is_a?(Integer)
      $var_list[$highest_scope][@a.id()] = @a.eval() + 1
      @a.eval
    end
  end
end
#Node for decrementing Integers and Floats.
class Decrement_node
  def initialize(a)
    @a = a
  end

  def eval()
    if @a.eval.is_a?(Integer)
      $var_list[$highest_scope][@a.id()] = @a.eval() - 1
      @a.eval
    end
  end
end

#################################
#Node for printing variables, values, operators.
class Print_node
  def initialize(statement)
    @to_print = statement
  end

  def eval()
    result = @to_print.eval
    if result == nil
      raise "ERROR: Variable has not been declared in this scope"
    else
      puts "#{result}" # #{} is used in for arrays to printed as well.
    end
  end
end

##### Assign/Return #####
#Node for variable assignment.
class Assign_node
  def initialize(a, b)
    @a = a
    @b = b
  end

  def eval()
    scope = create_variable(@a.id())
    $var_list[scope][@a.id()] = @b.eval
  end
end
#Node for Returning values or variables.
class Retrieve_node
  def initialize(var)
    @variable = var
  end

  def eval()
    @variable.eval
  end
end
#Node for taking a user input from the terminal.
class Input_node
  def initialize()
    @ret = nil
  end

  def eval()
    @ret = STDIN.gets()
    int = Integer(@ret) rescue nil
    float = Float(@ret) rescue nil
    if int
      return int
    elsif float
      return float
    else
    return @ret
  end
  end
end
##### Variables #####
#Node for variables.
class Variable_node
  def initialize(var)
    @variable = var
  end

  def eval()
    find_variable(@variable)
  end

  def id()
    @variable
  end
end
#Node for datatype array.
class Array_node
  def initialize(lst)
    @lst = lst
  end

  def eval()
    if @lst
     @lst.each_with_index{|element, index| @lst[index] = element.eval()}
     @lst
   else
     []
   end
  end
end
#Node for specific values in an array.
class Array_value_node
  def initialize(arr, pos)
    @arr = arr
    @pos = pos
  end

  def eval()
    if @arr.is_a? Variable_node
      @arr = @arr.eval
    end
    return @arr[@pos]
  end
end
#Node for adding values to list.
class Array_add_node
  def initialize(val, arr)
    @arr = arr
    @val = val
  end

  def eval()
    @arr.eval().append @val.eval()
  end
end
#Node for removing values from list.
class Array_remove_node
  def initialize(val, arr, by_value)
    @arr = arr
    @val = val
    @by_value = by_value
  end

  def eval()
    if @by_value
      @arr.eval().delete(@val.eval())
    else
      @arr.eval().delete_at(@val)
    end
  end
end

#Node for datatype Integers.
class Int_node
  def initialize(i, negative = nil)
    @number = i
    @negative = negative
  end

  def eval()
    if @negative
      @number * -1
    else
      @number
    end
  end
end
#Node for datatype Floats.
class Float_node
  def initialize(i, negative = nil)
    @number = i
    @negative = negative
  end

  def eval()
    if @negative
      @number * -1
    else
      @number
    end
  end
end
#Node for datatype Strings.
class String_node
  def initialize(s)
    @string = s
  end

  def eval()
    @string
  end
end
#Used for comments
class Empty_node
  def eval()
  end
end
