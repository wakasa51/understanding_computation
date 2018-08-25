require_relative 'small_step_meaning.rb'
class Number
  def evaluate(environment)
    self
  end
end
class Boolean
  def evaluate(environment)
    self
  end
end
class Variable
  def evaluate(environment)
    environment[name]
  end
end
class Add
  def evaluate(environment)
    Number.new(left.evaluate(environment).value + right.evaluate(environment).value)
  end
end
class Multiply
  def evaluate(environment)
    Number.new(left.evaluate(environment).value * right.evaluate(environment).value)
  end
end
class LessThan
  def evaluate(environment)
    Boolean.new(left.evaluate(environment).value < right.evaluate(environment).value)
  end
end
class Assign
  def evaluate(environment)
    environment.merge({ name => expression.evaluate(environment) })
  end
end
class DoNothing
  def evaluate(environment)
    environment
  end
end
class If
  def evaluate(environment)
    case condition.evaluate(environment)
    when Boolean.new(true)
      consequence.evaluate(environment)
    when Boolean.new(false)
      alternative.evaluate(environment)
    end
  end
end
class Sequence
  def evaluate(environment)
    second.evaluate(first.evaluate(environment))
  end
end
class While
  def evaluate(environment)
    case condition.evaluate(environment)
    when Boolean.new(true)
      evaluate(body.evaluate(environment))
    when Boolean.new(false)
      environment
    end
  end
end
class Number
  def to_ruby
    "-> e { #{value.inspect} }"
  end
end
class Boolean
  def to_ruby
    "-> e { #{value.inspect} }"
  end
end
class Variable
  def to_ruby
    "-> e { e[#{name.inspect}] }"
  end
end
class Add
  def to_ruby
    "-> e { (#{left.to_ruby}).call(e) + (#{right.to_ruby}.call(e)) }"
  end
end
class Multiply
  def to_ruby
    "-> e { (#{left.to_ruby}).call(e) * (#{right.to_ruby}.call(e)) }"
  end
end
class LessThan
  def to_ruby
    "-> e { (#{left.to_ruby}).call(e) < (#{right.to_ruby}.call(e)) }"
  end
end
statement = While.new(
  LessThan.new(Variable.new(:x), Number.new(5)),
  Assign.new(:x, Multiply.new(Variable.new(:x), Number.new(3)))
)
p statement.evaluate({ x: Number.new(1) })
