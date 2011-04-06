require 'treetop'
require 'time'
require 'exp'
require 'interp'

mode = Interpreter.new()

Treetop.load('sexp')

prsr = SExpParser.new
st = Time.now
rv = prsr.parse(ARGV[0])
en = Time.now
puts "Time to run: #{en - st}"
if rv
  puts '--- SUCCESS'
else
  puts '!!! FAILED'
end

p "result: #{rv.interpret(mode)}"
