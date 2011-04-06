require 'treetop'
require 'exp'
require 'interp'

describe 'Parser' do
  before(:all) do
    Treetop.load('sexp')
    @prsr = SExpParser.new()
  end

  def check_parse_and_evaluate(succ, failure)
    succ.each() do |s|
      r = @prsr.parse(s[0])
      r.should_not be_nil
      r.evaluate(Interpreter.new()).should == s[1]
    end
    failure.each() { |s| @prsr.parse(s).should be_nil }
  end

  it 'should evaluate basic arithmetic' do
    succ = [['(add 1 2)', 3],
            ['(add 1 4)', 5],
            ['(add 21 31)', 52],
            ['(add 1 0)', 1],
            ['(sub 4 2)', 2],
            ['(sub 2 7)', -5],
            ['(add 1 -2)', -1],
            ['(sub 11 -22)', 33],
            ['(mul 2 3)', 6],
            ['(mul 7 8)', 56],
            ['(mul 21 -2)', -42],
            ['(mul -21 -2)', 42],
            ['(div 2 3)', 0],
            ['(div 56 8)', 7],
            ['(div 42 -2)', -21],
            ['(div -42 -2)', 21],
            ['(add 1)', 1],
            ['(sub 5)', -5],
            ['(mul 4)', 4],
            ['(div 3)', 'nil'],
            ]
    fails = ['(add']
    check_parse_and_evaluate(succ, fails)
  end

  it 'should evaluate recursive arithmetic' do
    succ = [['(add 2 (sub 2 1))', 3],
            ['(add (mul 4 3) 11)', 23],
            ['(add (mul 4 3) (div 8 4))', 14],
            ['(add (mul 4 (add 2 1)) 11)', 23],
    ]
    fails = []
    check_parse_and_evaluate(succ, fails)
  end

  it 'should make lists' do
    succ = [['(list 1 2)', [1, 2]],
            ['(list 47 83)', [47, 83]],
            ['(list (list 21 87) (list 44 78) (list 11 33))', [[21, 87], [44, 78], [11, 33]]],
            ['(car (list 47 83))', 47],
            ['(cdr (list 47 83 67))', [83, 67]],
    ]
    fails = []
    check_parse_and_evaluate(succ, fails)
  end
end
