class Game

    attr_reader :board, :player, :matched_cards

    def self.valid_size?(size)
        begin
            Float(size)
        rescue => exception
            print "\n --INVALID INPUT "
            sleep(2)
            false
        else
            size = size.to_i
            if size < 4
                print "\n --INVALID SIZE "
                sleep(2)
                false
            else
                true
            end
        end
    end

    def self.get_size
        system("clear")
        print "Enter the size grid you'd like to play on (min size = 4): "
        size = gets.chomp
        until self.valid_size?(size)
            system("clear")
            print "Enter the size grid you'd like to play on (min size = 4): "
            size = gets.chomp
        end
        size.to_i
    end

    def initialize
        size = Game.get_size
        @board = Board.new(size)
        @player = HumanPlayer.new
    end

    def take_turn
        
        # gets 1st user input and checks if it's a valid choice
        valid_input1 = false
        until valid_input1
            system("clear")
            @board.print_board
            player_input = @player.get_input
            if @board.valid_pos?(player_input)
                pos = [player_input[0].to_i, player_input[1].to_i]
                if !@board[pos].is_shown?
                    @board[pos].reveal
                    card_1 = @board[pos]
                    valid_input1 = true
                end
            end
        end

        # gets 2nd user input and checks if it's a valid choice
        valid_input2 = false
        until valid_input2
            system("clear")
            @board.print_board
            player_input = @player.get_input
            if @board.valid_pos?(player_input)
                pos = [player_input[0].to_i, player_input[1].to_i]
                if !@board[pos].is_shown?
                    @board[pos].reveal
                    card_2 = @board[pos]
                    valid_input2 = true
                end
            end
        end
        
        system("clear")
        @board.print_board

        if self.match?(card_1, card_2)
            print "\nFound a match! "
            sleep(2)
        else
            print "\nCards do not match, try again. "
            sleep(2)
            card_1.hide
            card_2.hide
        end

    end

    def match?(card_1, card_2)
        card_1 == card_2
    end

    def run_game 
        @board.place_random_cards
        found_all_cards = false
        until found_all_cards
            self.take_turn
            found_all_cards = @board.all_cards_revealed?
        end
        print "\n\nCongratulations! You found all matches! "
        sleep(5)
        puts
    end

end
 