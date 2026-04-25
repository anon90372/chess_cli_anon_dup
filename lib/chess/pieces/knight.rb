# frozen_string_literal: true

module Chess
  # A knight chess piece
  class Knight < Piece
    using HashExtensions

    # Wrap each value in an array to maintain a common interface with the other
    # pieces.
    def to_adjacent_movement_coords(coord)
      {
        north_east_left: [coord.to_adjacency(1, 2)],
        north_east_right: [coord.to_adjacency(2, 1)],
        south_east_left: [coord.to_adjacency(1, -2)],
        south_east_right: [coord.to_adjacency(2, -1)],
        south_west_left: [coord.to_adjacency(-2, -1)],
        south_west_right: [coord.to_adjacency(-1, -2)],
        north_west_left: [coord.to_adjacency(-2, 1)],
        north_west_right: [coord.to_adjacency(-1, 2)]
      }.delete_empty_arr_vals
    end

    # Define #to_adjacent_capture_coords to maintain a common interface with the
    # other pieces, specifically Pawn.
    def to_adjacent_capture_coords(coord)
      to_adjacent_movement_coords(coord)
    end
  end
end
