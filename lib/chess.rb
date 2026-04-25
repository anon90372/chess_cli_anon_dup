# frozen_string_literal: true

# Top level namespace for the project
module Chess
  require_relative 'core_ext/object_extensions'
  require_relative 'core_ext/numeric_extensions'
  require_relative 'core_ext/hash_extensions'
  require_relative 'chess/fen_char_analyzer'
  require_relative 'chess/fen_parser'
  require_relative 'chess/square'
  require_relative 'chess/piece'
  require_relative 'chess/player'
  require_relative 'chess/coord'
  require_relative 'chess/pieces/king'
  require_relative 'chess/pieces/queen'
  require_relative 'chess/pieces/rook'
  require_relative 'chess/pieces/bishop'
  require_relative 'chess/pieces/knight'
  require_relative 'chess/pieces/pawn'
  require_relative 'chess/pieces'
  require_relative 'chess/board'
  require_relative 'chess/aux_pos_data'
  require_relative 'chess/position'
  require_relative 'chess/log'
  require_relative 'chess/pre_move_analyzer'
  require_relative 'chess/move_validator'
  require_relative 'chess/post_move_analyzer'
  require_relative 'chess/turn_processor'
  require_relative 'chess/display'
  require_relative 'chess/game'
  require_relative 'chess/pawn_constants'
  require_relative 'chess/king_and_castling_constants'
  require_relative 'chess/fen_constants'
  require_relative 'chess/board_constants'
  require_relative 'chess/coord_constants'
  require_relative 'chess/display_constants'

  include PawnConstants
  include KingAndCastlingConstants
  include FENConstants
  include BoardConstants
  include CoordConstants
  include DisplayConstants
end
