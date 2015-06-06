require './scheme_env'

# Evaluate an expression in an environment
def plis_eval(expression, env)
  case expression
  when String # variable reference
    env[expression]
  when Numeric # constant literal
    expression
  when Array  # list
    case expression.first
    when 'quote' # (quote exp)
      expression.last
    when 'if' # (if test conseq eval)
      _, test, conseq, alt = expression
      exp = plis_eval(test, env) ? conseq : alt
      plis_eval(exp, env)
    when 'define' # (define var exp)
      _, var, exp = expression
      env[var] = plis_eval(exp, env)
    else # (proc arg...)
      prox = plis_eval(expression.first, env)
      args = expression[1..-1].map { |x| plis_eval(x, env) }
      prox.call(*args)
    end
  end
rescue => err
  puts err
  puts err.backtrace
end

# Read a Scheme expression from a string
def parse(program)
  abstract_syntax_tree(tokenize(program))
end

# Convert a string of characters into a list of token
def tokenize(chars)
  chars.gsub('(', ' ( ').gsub(')', ' ) ').split
end

# Read an expression from a sequence of tokens
def abstract_syntax_tree(tokens)
  fail SyntaxError, 'unexpected EOF while reading' if tokens.empty?

  token = tokens.shift
  fail SyntaxError, 'unexpected ")"' if token == ')'

  if token == '('
    l = []
    until (tokens.first == ')') do
      l << abstract_syntax_tree(tokens)
    end
    tokens.shift
    return l
  else
    return atom(token)
  end
end

# Numbers become numbers; every other token is a symbol
def atom(token)
  int = Integer(token) rescue nil
  float = Float(token) rescue nil
  int || float || token
end
