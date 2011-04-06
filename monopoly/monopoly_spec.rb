require 'monopoly'

describe 'Player' do
  it 'should start at 0' do
    Player.new.loc.should == nil
  end

  it 'should start with 1500$' do
    Player.new.money.should == 1500
  end

  it 'should receive funds' do
    [100, 300, 555].each() do |am|
      pl = Player.new
      m = pl.money
      pl.gain(am)
      pl.money.should == m + am
    end
  end

  it 'should handle the cost of a Space' do
    pl0 = Player.new(0)
    m0 = pl0.money
    cost = 10
    rent = 2

    sp = Space.new('', 0, cost, rent)

    # Space is unowned, costs and assigns owner
    pl0.loc = sp
    pl0.money.should == (m0 - cost)
    sp.owner.should == pl0
    pl0.actions.should == [[:buy, cost]]

    # Space is owned by player, no cost
    m0 = pl0.money
    pl0.loc = sp
    pl0.money.should == m0
    sp.owner.should == pl0
    pl0.actions.should == [[:buy, cost]]

    # Space is owned by player, costs "rent" and no ownership
    pl1 = Player.new(1)
    m0 = pl0.money
    m1 = pl1.money
    pl1.loc = sp
    pl1.money.should == (m1 - rent)
    pl0.money.should == (m0 + rent)
    sp.owner.should == pl0
    pl0.actions.should == [[:buy, cost], [:rent, rent, pl1]]
    pl1.actions.should == [[:rent, -rent, pl0]]
  end

  it 'should not own or rent unownable Spaces' do
    pl0 = Player.new(0)
    pl1 = Player.new(1)
    m0 = pl0.money
    m1 = pl1.money
    cost = 10

    sp = Space.new('', 0, cost, nil)

    # Space is unowned, costs only
    pl0.loc = sp
    pl0.money.should == (m0 - cost)
    sp.owner.should be_nil
    pl0.actions.should == [[:pay, cost]]

    pl1.loc = sp
    pl1.money.should == (m1 - cost)
    sp.owner.should be_nil
    pl1.actions.should == [[:pay, cost]]
  end

  it 'should not buy a Space if they have insufficient funds' do
    pl0 = Player.new
    m0 = 10
    pl0.money = m0

    cost0 = 11
    cost1 = 9
    sp0 = Space.new('', 0, cost0, 0)
    sp1 = Space.new('', 0, cost1, 0)

    # Space is unowned but too expensive
    pl0.loc = sp0
    pl0.money.should == m0
    sp0.owner.should be_nil
    pl0.actions.should == []
  end

  it 'should format actions for display' do
    pl0 = Player.new(0)
    pl1 = Player.new(1)
    pl0.actions = [[:buy, 6], [:rent, 7, pl1], [:pay, 5], [:rent, -10, pl1]]
    pl0.format_actions().should == '[B(-6)/R(7<=P1)/P(-5)/R(-10=>P1)]'
    pl1.format_actions().should == ''
  end
end

describe 'Colour' do
  it 'should have a name' do
    name = 'name'
    Colour.new(name).name.should == name
  end
end

describe 'Space' do
  it 'should intially have no owner' do
    Space.new('', 0, 0, 0).owner.should be_nil
  end

  it 'should have a postion on the board, a cost and a rent' do
    [[17, 10, 6], [22, 5, 1], [34, 17, 10]].each() do |p|
      sp = Space.new('', *p)
      [:position, :cost, :rent].each_with_index() do |sym, i|
        sp.send(sym).should == p[i]
      end
    end
  end

  it 'should belong to a Colour' do
    gr0 = Colour.new('0')
    gr1 = Colour.new('1')

    sp0 = Space.new('0', 0, 0, 0, gr0)
    sp1 = Space.new('1', 0, 0, 0, gr1)
    sp2 = Space.new('2', 0, 0, 0, gr0)
    
    sp0.colour.should == gr0
    sp1.colour.should == gr1
    sp2.colour.should == gr0

    gr0.spaces.should == [sp0, sp2]
    gr1.spaces.should == [sp1]
  end
end

describe IncomeTax do
  it 'should cost 200$ or 25% of cash, whichever is lower' do
    lt = IncomeTax.new('', 0, 0, 0)
    lt.cost(2).should == 1
    lt.cost(100).should == 25
    lt.cost(700).should == 175
    lt.cost(900).should == 200
    lt.cost(1000).should == 200
  end
end

describe Railroad do
  it 'should vary in rent based on the number owned' do
    pl = Player.new
    gr = Colour.new('')
    rr = (0...4).collect() { |i| Railroad.new("r#{i}", 0, 0, 0, gr) } 

    [0, 0, 0, 0].each_with_index() do |c, i|
      rr[i].rent.should == c
    end

    rr[0].owner = pl
    [25, 0, 0, 0].each_with_index() do |c, i|
      rr[i].rent.should == c
    end

    rr[1].owner = pl
    [50, 50, 0, 0].each_with_index() do |c, i|
      rr[i].rent.should == c
    end

    rr[2].owner = pl
    [100, 100, 100, 0].each_with_index() do |c, i|
      rr[i].rent.should == c
    end

    rr[3].owner = pl
    [200, 200, 200, 200].each_with_index() do |c, i|
      rr[i].rent.should == c
    end
  end
end

describe 'Game' do
  it "should load the board" do
    game = Game.new

    game.spaces.should_not be_nil
    game.spaces.length.should == 40

    game.spaces[0].name.should == 'GO'
    game.spaces[0].cost.should == 0
    game.spaces[0].rent.should be_nil
    game.spaces[0].ownable?.should be_false
    game.spaces[0].colour.should be_nil
    game.spaces[4].name.should == 'Income Tax'
    game.spaces[4].rent.should be_nil
    game.spaces[4].ownable?.should be_false
    game.spaces[4].colour.should be_nil
    game.spaces[7].name.should == 'Chance'
    game.spaces[7].cost.should == 0
    game.spaces[7].rent.should be_nil
    game.spaces[7].ownable?.should be_false
    game.spaces[7].colour.should be_nil
    game.spaces[10].name.should == 'Jail'
    game.spaces[10].cost.should == 0
    game.spaces[10].rent.should be_nil
    game.spaces[10].ownable?.should be_false
    game.spaces[10].colour.should be_nil
    game.spaces[12].name.should == 'Electric Company'
    game.spaces[12].cost.should == 150
    game.spaces[12].rent.should == 0
    game.spaces[12].colour.should_not be_nil
    game.spaces[12].colour.name.should == 'Utility'
#    game.spaces[12].ownable?.should be_true
    game.spaces[17].name.should == 'Community Chest'
    game.spaces[17].cost.should == 0
    game.spaces[17].rent.should be_nil
    game.spaces[17].colour.should be_nil
    game.spaces[17].ownable?.should be_false
    game.spaces[20].name.should == 'Free Parking'
    game.spaces[20].cost.should == 0
    game.spaces[20].rent.should be_nil
    game.spaces[20].ownable?.should be_false
    game.spaces[20].colour.should be_nil
    game.spaces[6].name.should == 'Oriental Avenue'
    game.spaces[6].cost.should == 100
    game.spaces[6].rent.should == 6
    game.spaces[6].ownable?.should be_true
    game.spaces[6].colour.should_not be_nil
    game.spaces[6].colour.name.should == 'Light Blue'
    game.spaces[30].name.should == 'Go to jail'
    game.spaces[30].cost.should == 0
    game.spaces[30].rent.should be_nil
    game.spaces[30].ownable?.should be_false
    game.spaces[38].name.should == 'Luxury Tax'
    game.spaces[38].cost.should == 75
    game.spaces[38].rent.should be_nil
    game.spaces[38].ownable?.should be_false
    game.spaces[39].name.should == 'Boardwalk'
    game.spaces[39].cost.should == 400
    game.spaces[39].rent.should == 50
    game.spaces[39].ownable?.should be_true
    game.spaces[39].colour.should_not be_nil
    game.spaces[39].colour.name.should == 'Dark Blue'

    # special cases
    game.spaces[4].class.should == IncomeTax
    game.spaces[5].class.should == Railroad
    game.spaces[5].ownable?.should be_true
    game.spaces[15].class.should == Railroad
    game.spaces[15].ownable?.should be_true
    game.spaces[25].class.should == Railroad
    game.spaces[25].ownable?.should be_true
    game.spaces[35].class.should == Railroad
    game.spaces[35].ownable?.should be_true
  end

  it "should start with 4 players" do
    game = Game.new
    game.should_not be_nil
    game.players.length == 4
    game.players.each do |p|
      p.loc.should == game.spaces[0]
    end
  end

  it "should move players to new locations in each round" do
    rolls1 = [4, 10, 7, 2]
    rolls2 = [6, 9, 2, 8]
    round = 0

    game = Game.new
    game.should_receive(:roll_all).twice do
      round += 1
      round == 1 ? rolls1 : rolls2      
    end
    
    game.round
    (0...rolls1.length).each() do |i|
      game.players[i].loc.should == game.spaces[rolls1[i]]
    end

    game.round

    (0...rolls2.length).each() do |i|
      game.players[i].loc.should == game.spaces[rolls1[i] + rolls2[i]]
    end
  end

  it "should wrap at board end and receive 200$" do
    rolls = [11, 10, 1, 4]
    locs = [31, 39, 36, 36]
    next_locs = [2, 9, 37, 0] 

    game = Game.new
    game.should_receive(:roll_all).and_return(rolls)

    (0...locs.length).each() do |i|
      game.players[i].loc = game.spaces[locs[i]]
    end

    money = game.players.collect() { |p| p.money }
    game.round

    (0...next_locs.length).each() do |i|
      game.players[i].loc.should == game.spaces[next_locs[i]]
      inc = game.players[i].loc.position < 15 ? 200 : 0
      inc -= game.players[i].loc.cost()
      game.players[i].money.should == money[i] + inc
    end
  end

  it "should generate rolls in the range 2..12" do
    rolls = Game.new.roll_all
    rolls.length.should == 4
    rolls.each() do |r|
      r.should > 1
      r.should < 13
    end
    rolls.should_not == Game.new.roll_all
  end

  it "should play n rounds" do
    n = 20
    game = Game.new
    game.should_receive(:round).exactly(n).times
    game.play(n)
  end

  it "should determine a winner" do
    game = Game.new
    game.players[0].money = 3000
    game.players[1].money = 2000
    game.players[2].money = 1000
    game.players[3].money = 500

    game.winners.should == [game.players[0]]

    game.players[0].money = 3000
    game.players[1].money = 3000
    game.players[2].money = 1000
    game.players[3].money = 500

    game.winners.should == [game.players[0], game.players[1]]

    game.players[0].money = 1000
    game.players[1].money = 1000
    game.players[2].money = 3000
    game.players[3].money = 500

    game.winners.should == [game.players[2]]
  end
end
