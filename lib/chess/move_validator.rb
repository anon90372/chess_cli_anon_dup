# frozen_string_literal: true

module Chess
  # Validates moves in the context of a chess position
  class MoveValidator
    # @param position [Position]
    def initialize(position)
      @position = position
      @pre_move_analyzer = PreMoveAnalyzer.new(@position)
    end

    def legal_move?(source, destination)
      legal_source?(source) && to_all_legal_destinations_from(source).include?(destination)
    end

    def legal_source?(source)
      to_all_legal_sources.include?(source)
    end

    def any_legal_moves_available?
      to_all_legal_destinations.any?
    end

    def to_all_legal_sources
      @position.to_all_sources(@position.to_active_color)
    end

    def to_all_legal_destinations
      to_all_legal_sources.map { |source|
        to_all_legal_destinations_from(source)
      }.flatten.uniq
    end

    def to_all_legal_destinations_from(source)
      to_legal_attacked_destinations_from(source) + to_legal_controlled_destinations_from(source)
    end

    # Returns a complete array of attacked destinations from a given legal source.
    # The method rejects destinations that would leave the active color in check
    # and includes any potential en passant attacks.
    def to_legal_attacked_destinations_from(source)
      arr = []
      return arr unless legal_source?(source)

      arr << @pre_move_analyzer.to_en_passant_destinations_from(source)
      arr << @position.to_attacked_destinations_from(source)
      arr.flatten.reject do |destination|
        @position.move_would_leave_active_color_in_check?(source, destination)
      end
    end

    # Returns a complete array of controlled destinations from a given legal source.
    # The method rejects destinations that would leave the active color in check
    # and includes any potential castling destinations.
    def to_legal_controlled_destinations_from(source)
      return [] unless legal_source?(source)

      arr = @position.to_controlled_destinations_from(source).reject do |destination|
        @position.move_would_leave_active_color_in_check?(source, destination)
      end
      (arr << @pre_move_analyzer.to_castle_destinations_from(source)).flatten
    end
  end
end
