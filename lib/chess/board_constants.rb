# frozen_string_literal: true

module Chess
  # A namespace to store board related constants
  module BoardConstants
    BOARD_FILE_MARKERS = ('a'..'h').to_a.freeze
    BOARD_RANK_MARKERS = (1..8).to_a.reverse.freeze
  end
end
