require 'llvm'

PCHAR = LLVM::Type.pointer(LLVM::Type::Int8Ty)
INT   = LLVM::Type::Int32Ty

class CodeGenerator
  def initialize()
    @mod = LLVM::Module.new('sexp')
    @func_main = @mod.get_or_insert_function("main", 
                                             LLVM::Type::function(INT, []))
    @func_printf = @mod.external_function("printf",
                                          LLVM::Type.function(INT, [PCHAR, INT], true))
  end

  def start()
    @bl = @func_main.create_block.builder
  end

  def finish(v)
    s = @bl.create_global_string_ptr(">> %d\n")
    @bl.call(@func_printf, s, v)
    @bl.return(0.llvm)

    @mod.write_bitcode('sexp.o')
  end

  def add(vals)
    rv = 0.llvm
    vals.each() do |v|
      rv = @bl.add(rv, v)      
    end
    rv
  end

  def sub(vals)
    rv = 0.llvm
    if vals.length() > 1
      rv = vals[0]
      vals[1..-1].each() do |v|
        rv  = @bl.sub(rv, v)
      end
    else
      rv @bl.sub(rv, v)
    end
    rv
  end

  def mul(vals)
    rv = 1.llvm
    vals.each() { |v| rv = @bl.mul(rv, v) }
    rv
  end

  def div(vals)
    rv = 0.llvm
    if vals.length > 1
      rv = vals[0]
      vals[1..-1].each() { |v| rv = @bl.udiv(rv, v) }
    end
    rv
  end

  def list(vals)
  end

  def car(vals)
  end

  def cdr(vals)
  end

  def number(val)
    val.to_i.llvm
  end
end
