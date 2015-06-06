require './plis'
require './scheme_env'

local_env = scheme_env

loop do
  begin
    print 'plis> '
    line = gets.chomp
    puts plis_eval(parse(line), local_env)
  rescue Interrupt
    puts "\nBye!"
    exit
  end
end
