# frozen_string_literal: true

module Chess
  # Analyzes information after a move in the context of a chess position
  class PostMoveAnalyzer
    # @param position [Position]
    # @param log [Log]
    def initialize(position, log)
      @position = position
      @log = log
    end

    def move_was_double_pawn_push?
      return false unless pawn_at_previous_destination?

      (@log.metadata[:previous_destination].rank - @log.metadata[:previous_source].rank).abs == 2
    end

    def to_en_passant_target_s
      if move_was_double_pawn_push?
        pawn_source = @log.metadata[:previous_destination]
        pawn = @position.board.occupant_at(pawn_source)
        to_en_passant_target_coord(pawn_source, pawn.color).to_s
      else
        '-'
      end
    end

    private

    def to_en_passant_target_coord(source, color)
      if color == :white
        source.to_adjacency(0, -1)
      elsif color == :black
        source.to_adjacency(0, 1)
      end
    end

    def pawn_at_previous_destination?
      @position.board.occupant_at(@log.metadata[:previous_destination]).is_a?(Pawn)
    end
  end
end
