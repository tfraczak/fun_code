require "./card.rb"
require "colorize"

class Board

    COLORS = [
        :light_black,
        :red,
        :green,
        :light_green,
        :yellow,
        :blue,
        :magenta,
        :light_magenta,
        :light_cyan,
        :white,
    ]


    attr_reader :cards, :grid

    def self.print_grid(grid)
        (0..grid.length).each do |rdx|
            row_print = ""
            (0..grid.length).each do |cdx|
                if rdx == 0 && cdx == 0
                    row_print += "  "
                elsif rdx == 0 && cdx > 0
                    row_print += "#{cdx-1} "
                elsif rdx > 0 && cdx == 0
                    row_print += "#{rdx-1} "
                else
                    if grid[rdx-1][cdx-1].is_shown?
                        row_print += "#{grid[rdx-1][cdx-1].face} "
                    else
                        row_print += "- "
                    end
                end
            end
            puts row_print[0...-1]
        end
        nil
    end

    def self.build_deck(size)
        faces = ("A".."Z").to_a
        num_pairs = (size * size) / 2
        cards = []
        num_pairs.times do
            random_color = COLORS.sample
            random_face = faces.sample
            colorized_face = random_face.colorize(random_color)
            random_card1 = Card.new(colorized_face)
            random_card2 = Card.new(colorized_face)
            cards += [random_card1, random_card2]
        end
        cards.shuffle
    end

    def initialize(size)
        @grid = Array.new(size) {Array.new(size," ")}
        @cards = Board.build_deck(size)
    end

    def [](pos)
        row, col = pos[0], pos[1]
        @grid[row][col]
    end

    def []=(pos,val)
        row, col = pos[0], pos[1]
        @grid[row][col] = val
    end

    def length_odd_and_center?(pos)
        (pos[0] == @grid.length/2) && (pos[1] == @grid.length/2) && @grid.length.odd?
    end

    def place_random_cards
        (0...@grid.length).each do |rdx|
            (0...@grid.length).each do |cdx|
                pos = [rdx,cdx]
                if self.length_odd_and_center?(pos)
                    self[pos] = Card.new("+",true)
                else
                    self[pos] = @cards.pop
                end
            end
        end
        nil
    end

    def print_board
        Board.print_grid(@grid)
        nil
    end

    def pos_on_board?(row,col)
        positive_num_out_of_bounds = (row >= @grid.length || col >= @grid.length)
        negative_num_out_of_bounds = (row < -@grid.length || col < -@grid.length)
        !positive_num_out_of_bounds && !negative_num_out_of_bounds
    end

    def valid_pos?(input)
        case input.length
        
        when 2
            row, col = input[0], input[1]
            begin
                Float(row)
                Float(col)
            rescue => exception
                print "\n --INVALID CHARACTER "
                sleep(2)
                false
            else
                row = row.to_i
                col = col.to_i
                if pos_on_board?(row,col)
                    true
                else
                    print "\n --INPUT OUT OF BOUNDS "
                    sleep(2)
                    false
                end
            end
        
        else
            print "\n --INVALID FORMAT "
            sleep(2)
            false
        end

    end

    def all_cards_revealed?
        @grid.each do |row|
            row.each do |card|
                return false if card.is_shown? == false
            end
        end
        true
    end

    def reveal_pos(*pos)
        self[*pos].reveal
        nil
    end

    def hide_pos(*pos)
        self[*pos].hide
        nil
    end

end