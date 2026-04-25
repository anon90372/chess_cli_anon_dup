# frozen_string_literal: true

module Chess
  # A namespace to store display related constants
  module DisplayConstants
    COLOR_RGB_MAP = {
      white: '255;255;255',
      black: '0;0;0',
      green: '119;162;109',
      yellow: '200;194;100',
      lighter_orange: '170;82;48',
      darker_orange: '130;68;43',
      lighter_olive: '150;144;49',
      darker_olive: '130;125;53',
      red: '168;50;50'
    }.freeze

    PIECE_ICON_MAP = {
      King => "\u{265A}",
      Queen => "\u{265B}",
      Rook => "\u{265C}",
      Bishop => "\u{265D}",
      Knight => "\u{265E}",
      Pawn => "\u{2659}"
    }.freeze

    CONTROLLED_DESTINATION_INDICATOR = "\u{25CF}"

    BOARD_FILE_INDICATORS = '   a  b  c  d  e  f  g  h'
  end
end
