require 'monopoly'

class VisibleGame < Game
  def round_complete(n)
    status = []
    actions = []
    @players.each() do |pl|
      status << "P#{pl.id} #{pl.money.to_s.rjust(6)}$ @ #{pl.loc.name} (#{pl.loc.position})".ljust(44)
      actions << pl.format_actions().ljust(44)
      pl.clear_actions()
    end
    puts '------------------------------------------------------------------------------------------------------------------------------------------------------------------------------'
    rn = "Round #{n.to_s.rjust(3)}"
    puts "#{rn}: #{status.join('')}"
    puts "           #{actions.join('')}"
  end  
end

g = VisibleGame.new
g.play(ARGV[0] ? Integer(ARGV[0]) : 20)

puts "\nOwners:"
g.spaces.each() do |sp|
  if sp.ownable?
    pn = sp.owned? ? "P#{sp.owner.id}" : 'available'
    puts "#{sp.name.ljust(24)} #{pn}"
  end
end
ws = g.winners.collect() { |w| "Player #{w.id} with #{w.money}$" }.join(', ')
puts "\nWinners: #{ws}"

