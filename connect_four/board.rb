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
