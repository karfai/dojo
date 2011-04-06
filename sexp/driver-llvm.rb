$:.unshift "/home/don/src/freesoftware/llvm/llvmruby_llvm2.4/ext"
$:.unshift "/home/don/src/freesoftware/llvm/llvmruby_llvm2.4/lib"

require 'treetop'
require 'time'
require 'exp'
require 'codegen'

Treetop.load('sexp')

prsr = SExpParser.new()
rv = prsr.parse(ARGV[0])

if rv
  puts '--- SUCCESS'
  interp = CodeGenerator.new()
  interp.start()
  interp.finish(rv.evaluate(interp))
else
  puts '!!! FAILED'
end


