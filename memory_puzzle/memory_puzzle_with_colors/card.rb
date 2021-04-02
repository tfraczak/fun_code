class Card
    attr_reader :face
    attr_writer :is_shown
    # instance variables of face value and whether or not it's shown
    def initialize(face, is_shown=false)
        @face = face 
        @is_shown = is_shown
    end
    #reveal which "reveals the card", @is_shown = true
    def reveal
        @is_shown = true
    end
    # #hide which "hides the card", @is_shown = false
    def hide
        @is_shown = false
    end
    # @shown will be true or false

    def is_shown?
        @is_shown
    end



    # #==(card) compare face values? self.face == card.face => self == card2
    def ==(other_card)
        self.face == other_card.face 
    end
    # #to_s for printing? maybe card.to_s => "#{face_value}" ?

end