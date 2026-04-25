# frozen_string_literal: true

module Chess
  # A king chess piece
  class King < Piece
    using HashExtensions

    # Wrap each value in an array to maintain a common interface with the other
    # pieces.
    def to_adjacent_movement_coords(coord)
      Chess::COORD_METHOD_MAP
        .transform_values { |method_name| [coord.public_send(method_name).first] }
        .delete_empty_arr_vals
    end

    # Define #to_adjacent_capture_coords to maintain a common interface with the
    # other pieces, specifically Pawn.
    def to_adjacent_capture_coords(coord)
      to_adjacent_movement_coords(coord)
    end
  end
end
