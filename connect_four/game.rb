require_relative 'board'
require_relative 'human_player'
require_relative 'computer_player'

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

if __FILE__ == $PROGRAM_NAME
game = Game.new
p game.play
end
