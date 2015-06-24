require './plis'
require './scheme_env'

require 'readline'

local_env = scheme_env

loop do
  begin
    line = Readline.readline('plis> ', true)

    exit if line =~ /^exit$/i

    puts plis_eval(parse(line), local_env)
  rescue Interrupt
    exit
  end
end
