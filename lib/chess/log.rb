# frozen_string_literal: true

module Chess
  # Logs data about a chess game
  class Log
    attr_reader :metadata, :fen_history

    # @param metadata [Hash{Symbol => Coord}]
    # @param fen_history [Array<String>]
    def initialize(metadata = {}, fen_history = [])
      @metadata = metadata
      @fen_history = fen_history
    end

    def threefold_repetition_rule_satisfied?
      hash = Hash.new(0)
      to_simplified_fen_history.each do |fen|
        hash[fen] += 1
        return true if hash[fen] == 3
      end
      false
    end

    private

    def to_simplified_fen_history
      @fen_history.map { |fen| fen.split[0..3].join(' ') }
    end
  end
end
