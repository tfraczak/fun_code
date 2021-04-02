# require "byebug"
require "set"
require_relative "player"

class Game

    def self.build_dictionary(file_name)
        dictionary = Set.new
        File.readlines(file_name).each { |line| dictionary.add(line.chomp) }
        dictionary
    end

    attr_reader :fragment, :players, :dictionary
    attr_writer :players

    def initialize(num_players)
        @players = (1..num_players).map { |num| Player.new(num) }
        @dictionary = Game.build_dictionary("dictionary.txt")
        @fragment = ""
        @current_player = @players[0]
        @previous_player = @players[-1]
        @round = 1        
    end

    def next_player!
        @players.rotate!
        @current_player = @players[0]
        @previous_player = @players[-1]
    end

    def take_turn
        valid_turn = false
        while !valid_turn
            system("clear")
            print("Round #{@round}\n")
            print("The current fragment is: '#{@fragment}'\n")
            sleep(1)
            player_input = @current_player.get_input
            valid_turn = self.valid_play?(player_input)
        end
    end

    def valid_play?(player_input)
        alpha = ("a".."z").to_a
        if alpha.include?(player_input)
            if @dictionary.any? { |word| word[0..@fragment.length] == @fragment + player_input }
                @fragment += player_input
                print "\n'#{@fragment}' is the new fragment. "
                sleep(2)
                true
            else
                print "\n'#{player_input}' does not form a valid word, you lose your turn. "
                @current_player.passes -= 1
                sleep(2)
                print "Passes: #{@current_player.passes} "
                sleep(2)
                true
            end
        else
            print "\n --INVALID INPUT "
            sleep(2)
            false
        end
    end

    def word_found?
        @dictionary.include?(@fragment)
    end

    def add_loss
        @previous_player.losses += 1
    end

    def round_reset
        @fragment = ""
        @players.each { |player| player.passes = 3 }
    end

    def eliminated?
        @players.each do |player|
            if player.losses == "GHOST".length
                print "\nPlayer #{player.player_num}, you are a '#{"GHOST"[0...player.losses]}', you are eliminated... "
                sleep(3)
                @players.delete(player)
            end
        end
    end

    def winner?
        if @players.length == 1
            print "\n\nCongratulations Player #{@players[0].player_num}, you are the winner! "
            sleep(5)
            return true
        end
        false
    end

    def remove_word(fragment)
        @dictionary.delete(fragment)
    end

    def out_of_passes?
        @players.any? { |player| player.passes == 0 }
    end

    def round_over?
        self.word_found? || self.out_of_passes?
    end

    def play_round
        self.take_turn
        
        if self.round_over?
            if self.word_found?
                print "\n\nPlayer #{@current_player.player_num} wins this round! "
                sleep(2)
                print "\nPlayer #{@previous_player.player_num} loses... "
                sleep(2)
                self.add_loss
                print "#{"GHOST"[0...@previous_player.losses]} "
                sleep(2)
                self.eliminated?
                self.remove_word(@fragment)
                self.round_reset
                @round += 1
            elsif self.out_of_passes?
                self.next_player!
                print "\n\nPlayer #{@previous_player.player_num} is out of passes and loses... "
                sleep(2)
                self.add_loss
                print "#{"GHOST"[0...@previous_player.losses]} "
                sleep(2)
                print "\n\nPlayer #{@current_player.player_num} wins this round! "
                sleep(2)
                self.eliminated?
                self.remove_word(@fragment)
                self.round_reset
                @round += 1
            end
        else
            self.next_player!
        end

    end

    def run
        winner = false
        until self.winner?
            self.play_round
        end
        print "\n\nSee you guys next time!\n\n"
        sleep(2)
        nil
    end

end

