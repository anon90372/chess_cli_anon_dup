# frozen_string_literal: true

module Chess
  # A queen chess piece
  class Queen < Piece
    using HashExtensions

    def to_adjacent_movement_coords(coord)
      Chess::COORD_METHOD_MAP
        .transform_values { |method_name| coord.public_send(method_name) }
        .delete_empty_arr_vals
    end

    # Define #to_adjacent_capture_coords to maintain a common interface with the
    # other pieces, specifically Pawn.
    def to_adjacent_capture_coords(coord)
      to_adjacent_movement_coords(coord)
    end
  end
end
