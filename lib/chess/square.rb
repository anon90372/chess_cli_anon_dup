# frozen_string_literal: true

module Chess
  # A square on a chess board
  class Square
    attr_reader :occupant

    using ObjectExtensions

    # @param occupant [Piece, nil]
    def initialize(occupant = nil)
      @occupant = occupant
    end

    def occupied?
      !!@occupant
    end

    def vacant?
      @occupant.nil?
    end

    def fill(piece)
      @occupant = piece
    end

    def empty
      @occupant = nil
    end

    def to_s
      if occupied?
        "The #{to_class_s} is occupied by a #{@occupant.color} #{@occupant.to_class_s}."
      elsif vacant?
        "The #{to_class_s} is vacant."
      end
    end
  end
end
