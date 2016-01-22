class Game
    attr_accessor :player_one, :player_two, :current_player, :board, :mark

    def initialize(player_one = HumanPlayer.new, player_two = ComputerPlayer.new)
        @player_one = player_one
        @player_two = player_two
        @player_one.mark = :X
        @player_two.mark = :O
        @current_player = @player_one 
        
        @board = Board.new
    end
    
    def grid
        board.transpose
    end
    
    def switch_players!
        @current_player = ( current_player == player_one ? player_two : player_one )
    end
    
    def play_turn
        col = current_player.get_move(@board, @current_player.mark)
        if board.valid_move?(col)
            board.move(col, current_player.mark)
        else
            puts "Impossible." if current_player.is_a? HumanPlayer
            play_turn
        end
    end
    
    def play
        start
        until board.won?
            board.display
            puts current_player.random_insult if current_player.is_a? ComputerPlayer
            puts "#{current_player.name}'s turn."
            play_turn
            switch_players!
        end
        finish
    end
    
    def start
        puts "Let's play Connect Four!"
        puts "#{player_one.name}, your mark will be #{player_one.mark}."
        puts "#{player_two.name}, your mark will be #{player_two.mark}."
        puts ""
    end
    
    def finish
        board.display
        switch_players!
        puts "#{current_player.name} wins!"
        puts "Game over."
    end
end


class Board
    attr_accessor :grid, :winner
    
    def initialize(grid = self.default_grid)
        @grid = grid
        
        @winner = nil
    end
    
    def default_grid
        Array.new(7) { Array.new(6, '_') }
    end
    
    def display
        col_count = 1; cols = " "
        
        grid_str = ""
        grid.transpose.reverse_each do |col|
            col_count += 1
            col.each do |el|
                grid_str << "|"
                grid_str << "#{el}"
            end
            grid_str << "|\n"
        end
        puts grid_str
        col_count.times do |i|
            cols << "#{i} "
        end
        puts cols
        puts ""
    end
    
    def [](x, y)
        grid[x][y]
    end
    
    def col(col)
        grid[col]
    end
    
    def []=(x, y, mark)
        grid[x][y] = mark
    end
    
    def place_mark(x, y, mark)
        grid[x][y] = mark
    end
    
    def transpose
        grid.transpose
    end
    
    def move(col, mark)
       idx = self.col(col).find_index('_')
       self.[]=(col, idx, mark)
    end
    
    def undo_move(col, mark)
       idx = self.col(col).rindex(mark)
       self.[]=(col, idx, '_')
    end
   
    def valid_move?(col)
       return false if col < 0 or col > 6
       col(col).include?('_')
    end
   
    def over?
       grid.all? or grid.won?
    end
   
    def all?
       grid.flatten.none? { |el| el == "_" }
    end
   
    def vertical_win?
        grid.each do |col|
            if col.join('').include?("OOOO")
                winner = :O
                return true
            elsif col.join('').include?("XXXX")
                winner = :X
                return true
            end
        end
       false
    end
   
    def horizontal_win?
        grid.transpose.each do |row|
            if row.join('').include?("OOOO")
                winner = :O
                return true
            elsif row.join('').include?("XXXX")
                winner = :X
                return true
            end
           end
       false
    end
   
    def diagonal_win?
       grid.each_with_index do |col, idx1|
           col.each_with_index do |el, idx2|
            unless idx1 + 3 > 6 or idx2 + 3 > 6
                if el == :X
                  if [grid[idx1 + 1][idx2 + 1], grid[idx1 + 2][idx2 + 2], grid[idx1 + 3][idx2 + 3]] == [:X, :X, :X]
                     winner = :X
                     return true
                  end
                elsif el == :O
                  if [grid[idx1 + 1][idx2 + 1], grid[idx1 + 2][idx2 + 2], grid[idx1 + 3][idx2 + 3]] == [:O, :O, :O]
                     winner = :O
                     return true
                  end
                end
            end
          end
       end
       
       grid.each_with_index do |col, idx1|
           col.each_with_index do |el, idx2|
            unless idx1 + 3 > 6 or idx2 - 3 < 0
                if el == :X
                  if [grid[idx1 + 1][idx2 - 1], grid[idx1 + 2][idx2 - 2], grid[idx1 + 3][idx2 - 3]] == [:X, :X, :X]
                     winner = :X
                     return true
                  end
                elsif el == :O
                  if [grid[idx1 + 1][idx2 - 1], grid[idx1 + 2][idx2 - 2], grid[idx1 + 3][idx2 - 3]] == [:O, :O, :O]
                     winner = :O
                     return true
                  end
                end
            end
          end
       end
       
       false
    end
   
    def won?
       horizontal_win? or vertical_win? or diagonal_win?
    end
end


class ComputerPlayer
    attr_accessor :name, :mark, :board
    
    def initialize(name = "Bot")
        @name = name
    end
    
    def get_move(board, mark)
        @board = board
        @mark = mark
        
        if winnable?
            winning_move
        elsif imminent_loss?
            prevent_loss
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


if __FILE__ == $PROGRAM_NAME
game = Game.new
p game.play
end
