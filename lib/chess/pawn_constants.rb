# frozen_string_literal: true

module Chess
  # A namespace to store pawn related constants
  module PawnConstants
    WHITE_PAWN_HOME_RANK = 2

    WHITE_PAWN_LAST_RANK = 8

    BLACK_PAWN_HOME_RANK = 7

    BLACK_PAWN_LAST_RANK = 1

    WHITE_EN_PASSANT_VULNERABLE_RANK = 3

    WHITE_EN_PASSANT_CAPTURE_RANK = 4

    BLACK_EN_PASSANT_VULNERABLE_RANK = 6

    BLACK_EN_PASSANT_CAPTURE_RANK = 5

    PROMOTION_MAP = {
      'queen' => Queen,
      'knight' => Knight,
      'bishop' => Bishop,
      'rook' => Rook
    }.freeze
  end
end
