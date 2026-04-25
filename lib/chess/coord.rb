# frozen_string_literal: true

module Chess
  # Algebraic coordinates corresponding to a location on a chess board
  class Coord
    attr_reader :file, :rank

    # @param file [String] the file coordinate between a and h
    # @param rank [Integer] the rank coordinate between 1 and 8
    def initialize(file, rank)
      @file = file
      @rank = rank
    end

    class << self
      # @param str [String] the valid algebraic coordinates
      def from_s(str)
        file = str[0]
        rank = str[1].to_i
        new(file, rank)
      end
    end

    def ==(other)
      other.is_a?(self.class) &&
        other.file == @file &&
        other.rank == @rank
    end

    alias eql? ==

    def hash
      [self.class, @file, @rank].hash
    end

    def to_adjacency(file_adjustment, rank_adjustment)
      return unless adjustment_in_bounds?(file_adjustment, rank_adjustment)

      adjacent_file_idx = file_to_i + file_adjustment - 1
      adjacent_file = Chess::BOARD_FILE_MARKERS[adjacent_file_idx]
      adjacent_rank = @rank + rank_adjustment
      Coord.new(adjacent_file, adjacent_rank)
    end

    def to_northern_adjacencies
      to_directional_adjacencies(0, 1)
    end

    def to_eastern_adjacencies
      to_directional_adjacencies(1, 0)
    end

    def to_southern_adjacencies
      to_directional_adjacencies(0, -1)
    end

    def to_western_adjacencies
      to_directional_adjacencies(-1, 0)
    end

    def to_north_eastern_adjacencies
      to_directional_adjacencies(1, 1)
    end

    def to_south_eastern_adjacencies
      to_directional_adjacencies(1, -1)
    end

    def to_south_western_adjacencies
      to_directional_adjacencies(-1, -1)
    end

    def to_north_western_adjacencies
      to_directional_adjacencies(-1, 1)
    end

    def adjustment_in_bounds?(file_adjustment, rank_adjustment)
      file_adjustment_in_bounds?(file_adjustment) &&
        rank_adjustment_in_bounds?(rank_adjustment)
    end

    def file_to_i
      Chess::BOARD_FILE_MARKERS.index(@file) + 1
    end

    def to_s
      "#{@file}#{@rank}"
    end

    private

    def to_directional_adjacencies(file_adjustment, rank_adjustment)
      arr = []
      return arr unless adjustment_in_bounds?(file_adjustment, rank_adjustment)

      first_adjacency = to_adjacency(file_adjustment, rank_adjustment)
      arr << first_adjacency
      loop do
        break unless arr.last.adjustment_in_bounds?(file_adjustment, rank_adjustment)

        next_adjacency = arr.last.to_adjacency(file_adjustment, rank_adjustment)
        arr << next_adjacency
      end
      arr
    end

    def file_adjustment_in_bounds?(file_adjustment)
      adjusted = file_to_i + file_adjustment
      adjusted.between?(1, Chess::BOARD_FILE_MARKERS.length)
    end

    def rank_adjustment_in_bounds?(rank_adjustment)
      adjusted = @rank + rank_adjustment
      adjusted.between?(1, Chess::BOARD_RANK_MARKERS.length)
    end
  end
end
