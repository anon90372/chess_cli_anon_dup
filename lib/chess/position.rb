# frozen_string_literal: true

module Chess
  # A chess position
  class Position # rubocop:disable Metrics/ClassLength
    attr_reader :board, :aux_pos_data

    using HashExtensions

    # @param board [Board]
    # @param aux_pos_data [AuxPosData]
    def initialize(board, aux_pos_data)
      @board = board
      @aux_pos_data = aux_pos_data
    end

    class << self
      # @param fen_parser [FENParser]
      def from_fen_parser(fen_parser)
        board = Board.from_fen_parser(fen_parser)
        aux_pos_data = AuxPosData.from_fen_parser(fen_parser)
        new(board, aux_pos_data)
      end
    end

    def check?
      to_attacked_destinations_by(to_inactive_color).include?(to_king_source(to_active_color))
    end

    # Returns an array of all attacked destinations from a given source. An
    # attacked destination is one that the source piece could move to and
    # capture an enemy piece. The method does not account for potential en
    # passant attacks.
    def to_attacked_destinations_from(source)
      return [] unless @board.occupied_at?(source)

      piece = @board.occupant_at(source)
      piece.to_adjacent_capture_coords(source).transform_values { |adjacent_coord_a|
        adjacent_coord_a.find do |adjacent_coord|
          next if @board.vacant_at?(adjacent_coord)
          break if @board.occupant_at(adjacent_coord).friendly_with?(piece)

          @board.occupant_at(adjacent_coord).enemy_to?(piece)
        end
      }.wrap_vals_in_arr.delete_empty_arr_vals.values.flatten
    end

    # Returns an array of all controlled destinations from a given source. A
    # controlled destination is one that the source piece could move to without
    # capturing an enemy piece. The method does not account for potential
    # castling destinations.
    def to_controlled_destinations_from(source)
      return [] unless @board.occupied_at?(source)

      piece = @board.occupant_at(source)
      piece.to_adjacent_movement_coords(source).transform_values { |adjacent_coord_a|
        adjacent_coord_a.take_while { |adjacent_coord| @board.vacant_at?(adjacent_coord) }
      }.delete_empty_arr_vals.values.flatten
    end

    def to_attacked_destinations_by(color)
      to_all_sources(color).map { |source|
        to_attacked_destinations_from(source)
      }.flatten.uniq
    end

    def to_controlled_destinations_by(color)
      to_all_sources(color).map { |source|
        to_controlled_destinations_from(source)
      }.flatten.uniq
    end

    def move_piece(source, destination)
      raise ArgumentError unless @board.occupied_at?(source)

      capture_any_en_passant_target(source, destination, PreMoveAnalyzer.new(self))
      piece = @board.occupant_at(source)
      @board.empty_at(source)
      @board.fill_at(destination, piece)
    end

    def move_would_leave_active_color_in_check?(source, destination)
      clone = self.clone
      clone.move_piece(source, destination)
      clone.check?
    end

    def to_active_color
      if @aux_pos_data.white_has_the_move?
        :white
      elsif @aux_pos_data.black_has_the_move?
        :black
      end
    end

    def to_inactive_color
      if @aux_pos_data.white_has_the_move?
        :black
      elsif @aux_pos_data.black_has_the_move?
        :white
      end
    end

    def to_all_sources(color)
      @board.to_occupied_locations(color).keys
    end

    def to_king_source(color)
      to_all_sources(color).find { |source| @board.occupant_at(source).is_a?(King) }
    end

    def all_sources_free_from_enemy_attack?(sources, color)
      sources.all? do |source|
        if color == :white
          !to_attacked_destinations_by(:black).include?(source)
        elsif color == :black
          !to_attacked_destinations_by(:white).include?(source)
        end
      end
    end

    def all_sources_free_from_enemy_control?(sources, color)
      sources.all? do |source|
        if color == :white
          !to_controlled_destinations_by(:black).include?(source)
        elsif color == :black
          !to_controlled_destinations_by(:white).include?(source)
        end
      end
    end

    def all_sources_vacant?(sources)
      sources.all? { |source| @board.vacant_at?(source) }
    end

    def to_fen
      "#{@board.to_partial_fen} #{@aux_pos_data.to_partial_fen}"
    end

    def clone
      Marshal.load(Marshal.dump(self))
    end

    private

    def capture_any_en_passant_target(source, destination, pre_move_analyzer)
      return unless pre_move_analyzer.en_passant_attack?(source, destination)

      @board.empty_at(pre_move_analyzer.to_en_passant_capture_coord)
    end
  end
end
