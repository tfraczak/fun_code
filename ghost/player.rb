class Player

    attr_accessor :losses, :passes
    attr_reader :player_num

    def initialize(player_num)
        @player_num = player_num
        @losses = 0
        @passes = 3
    end

    def get_input
        print "\nPlayer #{self.player_num}: #{"GHOST"[0...self.losses]} | Passes: #{self.passes}"
        print "\nPlayer #{self.player_num}, enter a letter from the English alphabet: "
        input = gets.chomp
        input.downcase
    end

end