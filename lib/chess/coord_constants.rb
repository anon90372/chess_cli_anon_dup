# frozen_string_literal: true

module Chess
  # A namespace to store coordinate related constants
  module CoordConstants
    COORD_METHOD_MAP = {
      north: :to_northern_adjacencies,
      east: :to_eastern_adjacencies,
      south: :to_southern_adjacencies,
      west: :to_western_adjacencies,
      north_east: :to_north_eastern_adjacencies,
      south_east: :to_south_eastern_adjacencies,
      south_west: :to_south_western_adjacencies,
      north_west: :to_north_western_adjacencies
    }.freeze
  end
end
