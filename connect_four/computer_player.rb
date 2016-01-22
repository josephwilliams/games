class ComputerPlayer
    attr_accessor :name, :mark, :board
    
    def initialize(name = "Bot")
        @name = name
    end
    
    def get_move(board, mark)
        @board = board
        @mark = mark
        
        if imminent_loss?
            prevent_loss
        elsif winnable?
            winning_move
        else
            random_move
        end
    end
    
    def random_move
        rand(-1..5)
    end
    
    def imminent_loss?
        if mark == :X
            other_mark = :O
        else
            other_mark = :X
        end
        
        (0..6).each do |i|
            if board.valid_move?(i)
                board.move(i, other_mark)
                if board.won?
                    board.undo_move(i, other_mark)
                    return true
                end
                board.undo_move(i, other_mark)
              break
            else
                next
            end
        end
        false
    end
    
    def prevent_loss
        if mark == :X
            other_mark = :O
        else
            other_mark = :X
        end
        
        last_move = nil
        (0..6).each do |i|
            if board.valid_move?(i)
                board.move(i, other_mark)
                if board.won?
                    board.undo_move(i, other_mark)
                    return i.to_i
                end
                board.undo_move(i, other_mark)
            else
                next
            end
        end
      last_move
    end
    
    def winnable?
        (0..6).each do |i|
            if board.valid_move?(i)
                board.move(i, self.mark)
                if board.won?
                    board.undo_move(i, self.mark)
                    return true
                end
                board.undo_move(i, self.mark)
            else
                next
            end
        end
      false
    end

    def winning_move
        (0..6).each do |i|
            if board.valid_move?(i)
                board.move(i, mark)
                if board.won?
                    board.undo_move(i, mark)
                    return i.to_i
                end
            board.undo_move(i, mark)
            else
                next
            end
        end
    end
    
    def random_insult
        random_insults = ["you suck, dude.", "nice move, idiot.", "LOL."]
        
        roll = rand(4)
        if roll == 2
            return "#{self.name} says " + random_insults.sample.to_s
        end
        ""
    end
end
