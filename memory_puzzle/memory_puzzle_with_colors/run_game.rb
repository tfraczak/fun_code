system("gem install colorize")
system("clear")

require_relative "board"
require_relative "card"
require_relative "player"
require "colorize"

game = Game.new
game.run_game