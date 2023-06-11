require_relative 'pieces'

class Board
    attr_reader :rows
    
    
    
    def initialize(fill_board = true)
       @sentinel = NullPiece.instance
        make_starting_grid(fill_board)
    end
    
    def pieces
        @rows.flatten.reject(&:empty)
    end
    
    def [](pos)
        raise "invalid pos" unless valid_pos?(pos)
        
        row, col = pos
        @rows[row][col]
    end
    
    def []=(pos, val)
        raise "invalid pos" unless valid_pos?(pos)
        
        row, col = pos
        @rows[row][col] = val
        
    end
    
    
    def add_piece(pos, piece)
        raise "position is not empty" unless empty?(pos)
        
        self[pos] = piece
    end
    
    def move_piece(turn_color, start_pos, end_pos)
       raise "start position is empty" if empty?(start_pos)
       
       piece = self[start_pos]
       if piece.color != turn_color
          raise "You are only allowed to move your own piece"
       elsif !piece.moves.include?(end_pos)
           raise "Piece does not move like that"
       elsif !piece.valid_moves.include?(end_pos)
          raise "Piece is not allowed to move like that"
       end
       
       move_piece!(start_pos, end_pos)
       
       
       
       
    end
    
    def move_piece!(start_pos, end_pos)
       piece = self[start_pos]
       
       raise "Piece does not move like that" unless piece.moves.include?(end_pos)
       
       self[end_pos] = piece
       self[start_pos] = sentinel
       piece.pos = end_pos
       
       nil  
    end
    
    def pieces 
       @rows.flatten.reject(&:empty?) 
    end
    
    def empty?(pos)
       self[pos].empty? 
    end
    
    def valid_pos?(pos)
        pos.all? { |coord| coord.between?(0,7)}
    end
    
    def checkmate?(color)
        return false unless in_check?(color)
    end
    
    def dup
        new_board = Board.new(false)
        
        pieces.each do |piece|
           piece.class.new(piece.color, new_board, piece.pos) 
        end
        
        new_board
        
    end
    
    def in_check?(color) 
        king_pos = find_king(color).pos
        pieces.any? do |p|
           p.color = !color && p.moves.include?(king_pos) 
        end
    end 
    
    private
    
    attr_reader :sentinel

    def find_king(color)
        king_pos = pieces.find { |p| p.color == color && p.is_a?(King) }
        king_pos || (raise 'king not found')
    end

    
    def fill_back_row(color)
       back_pieces = [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook] 
       i = color == "white" ? 7: 0
       back_pieces.each_with_index do |piece_class, j| 
           piece_class.new(color, self, [i,j])
       end
    end
    
    def fill_pawns_row(color)
        i = color == "white" ? 6: 1
        8.times { |j| Pawn.new(color, self, [i,j]) }
     
    end
    
    def make_starting_grid(fill_board)
       # make grid
       @rows = Array.new(8) { Array.new(8, sentinel) }
       return unless fill_board
       %i(white black).each do |color|
           fill_back_row(color)
           fill_pawns_row(color)
        end
       
       
       
    end
end