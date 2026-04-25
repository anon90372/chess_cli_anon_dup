# frozen_string_literal: true

module Chess
  # Auxiliary data representing a chess position excluding piece placement--the
  # auxiliary position data
  class AuxPosData
    # @param data_fields [Hash{Symbol => String}]
    def initialize(data_fields)
      @data_fields = data_fields
    end

    class << self
      # @param fen_parser [FENParser]
      def from_fen_parser(fen_parser)
        data_fields = fen_parser.to_parsed_data_fields
        data_fields.delete(:piece_placement)
        new(data_fields)
      end
    end

    def to_partial_fen
      @data_fields.values.join(' ')
    end

    def white_has_the_move?
      @data_fields[:active_color] == 'w'
    end

    def black_has_the_move?
      @data_fields[:active_color] == 'b'
    end

    def swap_active_color
      if white_has_the_move?
        @data_fields[:active_color] = 'b'
      elsif black_has_the_move?
        @data_fields[:active_color] = 'w'
      end
    end

    def white_kingside_castle_available?
      @data_fields[:castling_availability].include?('K')
    end

    def white_queenside_castle_available?
      @data_fields[:castling_availability].include?('Q')
    end

    def black_kingside_castle_available?
      @data_fields[:castling_availability].include?('k')
    end

    def black_queenside_castle_available?
      @data_fields[:castling_availability].include?('q')
    end

    def remove_white_kingside_castle
      return unless white_kingside_castle_available?

      remove_castle('K')
    end

    def remove_white_queenside_castle
      return unless white_queenside_castle_available?

      remove_castle('Q')
    end

    def remove_black_kingside_castle
      return unless black_kingside_castle_available?

      remove_castle('k')
    end

    def remove_black_queenside_castle
      return unless black_queenside_castle_available?

      remove_castle('q')
    end

    def remove_all_castling_rights(color)
      if color == :white
        remove_white_kingside_castle
        remove_white_queenside_castle
      elsif color == :black
        remove_black_kingside_castle
        remove_black_queenside_castle
      end
    end

    def en_passant_target_available?
      @data_fields[:en_passant_target] != '-'
    end

    def access_en_passant_target
      @data_fields[:en_passant_target]
    end

    def update_en_passant_target(coord_s)
      @data_fields[:en_passant_target] = coord_s
    end

    def reset_en_passant_target
      @data_fields[:en_passant_target] = '-'
    end

    def fifty_move_rule_satisfied?
      @data_fields[:half_move_clock].to_i >= 100
    end

    def seventy_five_move_rule_satisfied?
      @data_fields[:half_move_clock].to_i >= 150
    end

    def increment_half_move_clock
      incremented = (@data_fields[:half_move_clock].to_i + 1).to_s
      @data_fields[:half_move_clock] = incremented
    end

    def reset_half_move_clock
      @data_fields[:half_move_clock] = '0'
    end

    def increment_full_move_number
      incremented = (@data_fields[:full_move_number].to_i + 1).to_s
      @data_fields[:full_move_number] = incremented
    end

    private

    def remove_castle(castle)
      arr = @data_fields[:castling_availability].chars.reject { |char| char == castle }
      @data_fields[:castling_availability] = arr.join
      return unless @data_fields[:castling_availability].empty?

      @data_fields[:castling_availability] = '-'
    end
  end
end
