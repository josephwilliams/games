class HumanPlayer
    attr_accessor :name, :mark
    
    def initialize(name = "Human")
        @name = name
    end
    
    def get_move(board = nil, mark = nil)
        puts "Choose a column to drop your piece. (0-6)"
        begin
            Integer(gets.chomp)
        rescue
            puts "Enter a number."
            retry
        end
    end
end
