# An environment with some Scheme standard procedures
PROCS = %i(+ - * / > < == <= >=
           length max min map)

def scheme_env
  {
    'begin' => -> (*args) { args.last },
    'car' => -> (x) { x.first },
    'cdr' => -> (x) { x[1..-1] },
    'cons' => -> (x, y) { [x] + y },
    'pi' => Math::PI
  }.merge(Hash[PROCS.map { |sym| [sym.to_s, sym.to_proc].flatten }])
end
