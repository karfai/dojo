class Player
  attr_reader :id
  attr_accessor :actions, :loc, :money

  def initialize(id=nil)
    @loc = nil
    @money = 1500
    @id = id
    @actions = []    
  end

  def loc=(sp)
    if !sp.owned?
      c = sp.cost(@money)
      if @money >= c
        act = [:pay, c]
        @money -= c
        if sp.ownable?
          sp.owner = self 
          act[0] = :buy
        end
        @actions << act if c > 0
      end
    elsif !sp.owner?(self)
      @money -= sp.rent
      sp.owner.gain(sp.rent)
      sp.owner.actions << [:rent, sp.rent, self]
      @actions << [:rent, -sp.rent, sp.owner]
    end
    @loc = sp
  end

  def format_actions()
    fmt = {
      :buy  => lambda { |act| "B(-#{act[1]})"},
      :pay  => lambda { |act| "P(-#{act[1]})"},
      :rent => lambda { |act| "R(#{act[1]}#{act[1] > 0 ? '<=' : '=>'}P#{act[2].id})" }
    }
    s = @actions.collect() do |act|
      fmt[act[0]].call(act)
    end
    s.length > 0 ? "[#{s.join('/')}]" : ''
  end

  def clear_actions()
    @actions = []
  end

  def gain(am)
    @money += am
  end
end

class Colour
  attr_reader :name, :spaces


  def initialize(name)
    @name = name
    @spaces = []
  end
end

class Space
  attr_reader :name, :position, :cost, :rent, :colour
  attr_accessor :owner

  def initialize(n, p, c, r, g=nil)
    @name = n
    @position = p
    @cost = c
    @rent = r
    @colour = g
    @colour.spaces << self if @colour
  end

  def ownable?()
    @rent != nil
  end
  def owned?()
    @owner != nil
  end

  def owner?(pl)
    @owner == pl
  end

  def cost(am=0)
    @cost
  end
end

class IncomeTax < Space
  def cost(am)
    rv = (am * 0.25).round
    rv > 200 ? 200 : rv
  end
end

class Railroad < Space
  def rent()
    rv = super()
    if @owner
      costs = [25, 50, 100, 200]
      i = @colour.spaces.select {|s| s.owner == @owner}.length()-1
      rv = costs[i]
    end
    rv
  end
end

class Game
  attr_reader :players, :spaces

  def initialize()
    @n_players = 4
    @spaces = load_board('board.txt')
    @players = (0...@n_players).collect() do |i| 
      p = Player.new(i)
      p.loc = @spaces[0]
      p
    end
    srand
  end

  def lookup_space_class(n, gr)
    rv = Space
    if 'Income Tax' == n
      rv = IncomeTax
    elsif gr and gr.name == 'Railroad'
      rv = Railroad
    end

    rv
  end

  def load_board(fn)
    rv = []
    ghash = {}
    File.open(fn) do |f|
      f.each() do |ln|
        gr = nil
        defs = ln.chomp().split(/\|/)
        if defs.length > 3
          k = defs[3].strip()
          if !ghash.key?(k)
            gr = Colour.new(k)
            ghash[k] = gr
          end
          gr = ghash[k]
        end
          
        klass = lookup_space_class(defs[0], gr)
        rv << klass.new(defs[0],
                        rv.length,
                        defs.length > 1 ? defs[1].to_i : 0,
                        defs.length > 2 ? defs[2].to_i : nil,
                        gr)
      end
    end
    
    rv
  end

  def move(pl, n)
    i = pl.loc.position + n
    if i >= 40
      pl.gain(200)
      i %= 40
    end
    pl.loc = @spaces[i]
  end

  def roll_single()
    1 + rand(5)
  end

  def roll_all()
    (0...@n_players).collect() { |i| roll_single + roll_single }
  end

  def round_complete(n)
  end

  def round()
    rolls = roll_all
    (0...rolls.length).each() do |i|
      move(@players[i], rolls[i])
    end
  end

  def play(n=20)
    (0...n).each() do |i|
      round
      round_complete(i)
    end
  end

  def winners()
    h = 0
    rv = []
    @players.each() do |p|
      if p.money > h
        h = p.money
        rv = [p]
      elsif p.money == h
        rv << p
      end
    end
    rv
  end
  private :load_board
end
