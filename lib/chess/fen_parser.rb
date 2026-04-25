# frozen_string_literal: true

module Chess
  # Parses a chess FEN record
  class FENParser
    include FENCharAnalyzer

    # @param fen [String] the valid FEN record
    def initialize(fen)
      @fen = fen
    end

    def to_parsed_piece_placement
      current_rank_i = to_number_of_ranks
      to_ranks.each_with_object({}) do |rank_s, hash|
        rank_a = rank_s_to_rank_a(rank_s)
        rank_a_assoc = rank_a_to_rank_a_with_coords(rank_a, current_rank_i)
        rank_a_assoc.each { |assoc| hash[assoc[0]] = assoc[1] }
        current_rank_i -= 1
      end
    end

    def to_parsed_data_fields
      split_data = @fen.split
      { piece_placement: split_data[0],
        active_color: split_data[1],
        castling_availability: split_data[2],
        en_passant_target: split_data[3],
        half_move_clock: split_data[4],
        full_move_number: split_data[5] }
    end

    private

    def rank_a_to_rank_a_with_coords(rank_a, rank_i)
      rank_a.map.with_index do |char, idx|
        file = Chess::BOARD_FILE_MARKERS[idx]
        rank = rank_i
        coord_s = "#{file}#{rank}"
        [coord_s, char]
      end
    end

    def rank_s_to_rank_a(rank_s)
      rank_s.chars.each_with_object([]) do |char, arr|
        if char_represents_piece?(char)
          arr << char
        elsif char_represents_contiguous_empty_squares?(char)
          char.to_i.times { arr << '-' }
        end
      end
    end

    def to_ranks
      to_parsed_data_fields[:piece_placement].split('/')
    end

    def to_number_of_ranks
      to_ranks.length
    end
  end
end
