# frozen_string_literal: true

module Chess
  # A superclass to each of the chess pieces
  class Piece
    attr_reader :color

    using ObjectExtensions

    # @param color [Symbol]
    def initialize(color)
      @color = color
    end

    def white?
      @color == :white
    end

    def black?
      @color == :black
    end

    def friendly_with?(other)
      @color == other.color
    end

    def enemy_to?(other)
      @color != other.color
    end

    def to_s
      "The #{to_class_s} is #{@color}."
    end
  end
end
