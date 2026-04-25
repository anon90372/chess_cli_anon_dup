# frozen_string_literal: true

module Chess
  # A namespace to store king and castling related constants
  module KingAndCastlingConstants
    WHITE_KING_HOME = Coord.from_s('e1')

    BLACK_KING_HOME = Coord.from_s('e8')

    WHITE_KINGSIDE_ROOK_HOME = Coord.from_s('h1')

    WHITE_QUEENSIDE_ROOK_HOME = Coord.from_s('a1')

    BLACK_KINGSIDE_ROOK_HOME = Coord.from_s('h8')

    BLACK_QUEENSIDE_ROOK_HOME = Coord.from_s('a8')

    WHITE_KINGSIDE_ROOK_CASTLE_DESTINATION = Coord.from_s('f1').freeze

    WHITE_QUEENSIDE_ROOK_CASTLE_DESTINATION = Coord.from_s('d1').freeze

    BLACK_KINGSIDE_ROOK_CASTLE_DESTINATION = Coord.from_s('f8').freeze

    BLACK_QUEENSIDE_ROOK_CASTLE_DESTINATION = Coord.from_s('d8').freeze

    WHITE_KINGSIDE_CASTLE_PATH = [Coord.from_s('e1'), Coord.from_s('f1'), Coord.from_s('g1')].freeze

    WHITE_QUEENSIDE_CASTLE_PATH = [Coord.from_s('e1'), Coord.from_s('d1'), Coord.from_s('c1')].freeze

    BLACK_KINGSIDE_CASTLE_PATH = [Coord.from_s('e8'), Coord.from_s('f8'), Coord.from_s('g8')].freeze

    BLACK_QUEENSIDE_CASTLE_PATH = [Coord.from_s('e8'), Coord.from_s('d8'), Coord.from_s('c8')].freeze

    WHITE_KINGSIDE_CASTLE_SPACE = [Coord.from_s('f1'), Coord.from_s('g1')].freeze

    WHITE_QUEENSIDE_CASTLE_SPACE = [Coord.from_s('d1'), Coord.from_s('c1'), Coord.from_s('b1')].freeze

    BLACK_KINGSIDE_CASTLE_SPACE = [Coord.from_s('f8'), Coord.from_s('g8')].freeze

    BLACK_QUEENSIDE_CASTLE_SPACE = [Coord.from_s('d8'), Coord.from_s('c8'), Coord.from_s('b8')].freeze

    CASTLE_RIGHTS_REMOVAL_METHOD_MAP = {
      WHITE_KINGSIDE_ROOK_HOME => :remove_white_kingside_castle,
      WHITE_QUEENSIDE_ROOK_HOME => :remove_white_queenside_castle,
      BLACK_KINGSIDE_ROOK_HOME => :remove_black_kingside_castle,
      BLACK_QUEENSIDE_ROOK_HOME => :remove_black_queenside_castle
    }.freeze

    ROOK_CASTLING_COORD_MAP = {
      WHITE_KINGSIDE_CASTLE_PATH.last => {
        source: WHITE_KINGSIDE_ROOK_HOME, destination: WHITE_KINGSIDE_ROOK_CASTLE_DESTINATION
      },
      WHITE_QUEENSIDE_CASTLE_PATH.last => {
        source: WHITE_QUEENSIDE_ROOK_HOME, destination: WHITE_QUEENSIDE_ROOK_CASTLE_DESTINATION
      },
      BLACK_KINGSIDE_CASTLE_PATH.last => {
        source: BLACK_KINGSIDE_ROOK_HOME, destination: BLACK_KINGSIDE_ROOK_CASTLE_DESTINATION
      },
      BLACK_QUEENSIDE_CASTLE_PATH.last => {
        source: BLACK_QUEENSIDE_ROOK_HOME, destination: BLACK_QUEENSIDE_ROOK_CASTLE_DESTINATION
      }
    }.freeze
  end
end
