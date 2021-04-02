
class HumanPlayer
    def initialize

    end

    def get_input
        print "\nEnter a valid position with a space between the numbers (ex. '0 2'): "
        gets.chomp.split
    end
end