$:.unshift "/home/don/src/freesoftware/llvm/llvmruby_llvm2.4/ext"
$:.unshift "/home/don/src/freesoftware/llvm/llvmruby_llvm2.4/lib"
require 'llvm'

PCHAR = LLVM::Type.pointer(LLVM::Type::Int8Ty)
INT   = LLVM::Type::Int32Ty

m = LLVM::Module.new("test_module")

func_printf = m.external_function("printf", LLVM::Type.function(INT, [PCHAR, INT], true))

type = LLVM::Type::function(INT, [])
func_test = m.get_or_insert_function("test", type)
bb = func_test.create_block.builder
rv = bb.add(2.llvm, 3.llvm)
rv = bb.add(7.llvm, rv)
bb.return(rv)

type = LLVM::Type::function(INT, [INT, LLVM::Type.pointer(PCHAR)])
func_main = m.get_or_insert_function("main", type)
bb = func_main.create_block.builder

s = bb.create_global_string_ptr(">> %d\n")

test_res = bb.call(func_test)
bb.call(func_printf, s, test_res)
bb.return(0.llvm)

LLVM::ExecutionEngine.get(m)
res = LLVM::ExecutionEngine.run_autoconvert(func_test)
puts "res=#{res}"

m.write_bitcode('llvm-explore.o')
