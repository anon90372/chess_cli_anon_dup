# frozen_string_literal: true

module Chess
  # A namespace to store FEN related constants
  module FENConstants
    DEFAULT_FEN = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1'

    FEN_CHARS = {
      white: {
        king: 'K',
        queen: 'Q',
        rook: 'R',
        bishop: 'B',
        knight: 'N',
        pawn: 'P'
      },
      black: {
        king: 'k',
        queen: 'q',
        rook: 'r',
        bishop: 'b',
        knight: 'n',
        pawn: 'p'
      }
    }.freeze

    FEN_CHAR_PIECE_MAP = {
      white: {
        'K' => King,
        'Q' => Queen,
        'R' => Rook,
        'B' => Bishop,
        'N' => Knight,
        'P' => Pawn
      },
      black: {
        'k' => King,
        'q' => Queen,
        'r' => Rook,
        'b' => Bishop,
        'n' => Knight,
        'p' => Pawn
      }
    }.freeze

    PIECE_FEN_CHAR_MAP = {
      white: {
        King => 'K',
        Queen => 'Q',
        Rook => 'R',
        Bishop => 'B',
        Knight => 'N',
        Pawn => 'P'
      },
      black: {
        King => 'k',
        Queen => 'q',
        Rook => 'r',
        Bishop => 'b',
        Knight => 'n',
        Pawn => 'p'
      }
    }.freeze
  end
end
