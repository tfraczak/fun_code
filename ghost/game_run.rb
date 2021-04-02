require_relative "game"
require_relative "player"

system("clear")

print "Welcome to GHOST, a game of strategy and proper spelling... "
sleep(3)

player_num_accepted = false
until player_num_accepted
    system("clear")

    print "Enter the number of players for this game: "
    player_num = gets.chomp
    
    begin
        Float(player_num)
    rescue => exception
        print "\n --INVALID CHARACTER "
        sleep(2)
    else
        player_num = player_num.to_i
        player_num_accepted = true
    end

end

game = Game.new(player_num)

game.run