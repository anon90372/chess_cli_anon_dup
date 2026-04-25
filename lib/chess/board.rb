# frozen_string_literal: true

module Chess
  # A chess board
  class Board
    extend Pieces
    extend FENCharAnalyzer

    using NumericExtensions
    using HashExtensions

    # @param squares [Hash{Coord => Square}]
    def initialize(squares)
      @squares = squares
    end

    class << self
      # @param fen_parser [FENParser]
      def from_fen_parser(fen_parser)
        squares = {}
        fen_parser.to_parsed_piece_placement.each do |coord_s, char|
          coord = Coord.from_s(coord_s)
          squares[coord] = construct_square(char)
        end
        new(squares)
      end

      private

      def construct_square(char)
        if char_represents_piece?(char)
          piece = construct_piece_from_char(char)
          Square.new(piece)
        elsif char == '-'
          Square.new
        end
      end
    end

    def to_partial_fen
      arr = []
      to_ranks.each_value do |rank_a|
        arr << rank_a_to_partial_fen(rank_a)
      end
      arr.join('/')
    end

    def assoc_at(coord)
      @squares.assoc(coord)
    end

    def square_at(coord)
      @squares[coord]
    end

    def occupant_at(coord)
      square_at(coord).occupant
    end

    def fill_at(coord, piece)
      square_at(coord).fill(piece)
    end

    def empty_at(coord)
      square_at(coord).empty
    end

    def replace_at(coord, type)
      raise ArgumentError unless occupied_at?(coord)

      current_piece = occupant_at(coord)
      new_piece = type.new(current_piece.color)
      fill_at(coord, new_piece)
    end

    def occupied_at?(coord)
      square_at(coord).occupied?
    end

    def vacant_at?(coord)
      square_at(coord).vacant?
    end

    def pawn_at?(source)
      return false unless occupied_at?(source)

      occupant_at(source).is_a?(Pawn)
    end

    def to_occupied_locations(color)
      @squares.select do |_coord, square|
        square.occupied? && square.occupant.color == color
      end
    end

    def to_ranks
      vals = @squares.values
      Chess::BOARD_RANK_MARKERS.each_with_object({}) do |rank_i, hash|
        rank = vals.slice!(0, Chess::BOARD_FILE_MARKERS.length)
        hash[rank_i] = rank
      end
    end

    private

    def rank_a_to_partial_fen(rank_a) # rubocop:disable Metrics/MethodLength
      contiguous_empty_counter = 0
      fen_a = rank_a.each_with_object([]) do |square, fen_a|
        if square.occupied?
          fen_a << contiguous_empty_counter if contiguous_empty_counter.positive?
          fen_a << self.class.convert_piece_to_char(square.occupant)
          contiguous_empty_counter = 0
        elsif square.vacant?
          contiguous_empty_counter += 1
        end
      end
      fen_a << contiguous_empty_counter if contiguous_empty_counter.positive?
      fen_a.join
    end
  end
end
