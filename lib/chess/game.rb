# frozen_string_literal: true

module Chess
  # A game of chess
  class Game
    attr_reader :move_validator, :player_white, :player_black

    # @param position [Position]
    # @param log [Log]
    # @param player_white [Player] the player playing white
    # @param player_black [Player] the player playing black
    # @param display [Display]
    def initialize(
      position: Position.from_fen_parser(FENParser.new(Chess::DEFAULT_FEN)),
      log: Log.new,
      player_white: Player.new('w', :white),
      player_black: Player.new('b', :black),
      display: Display.new
    )
      @position = position
      @log = log
      @player_white = player_white
      @player_black = player_black
      @display = display
      @move_validator = MoveValidator.new(@position)
    end

    def play_turn(source, destination)
      raise ArgumentError unless @move_validator.legal_move?(source, destination)

      TurnProcessor.play_turn(
        position: @position,
        log: @log,
        source: source,
        destination: destination
      )
    end

    def check?
      @position.check?
    end

    def checkmate?
      @position.check? && !@move_validator.any_legal_moves_available?
    end

    def stalemate?
      !@position.check? && !@move_validator.any_legal_moves_available?
    end

    def draw_by_fifty_move_rule?
      @position.aux_pos_data.fifty_move_rule_satisfied?
    end

    def draw_by_threefold_repetition_rule?
      @log.threefold_repetition_rule_satisfied?
    end

    def over?
      draw_by_fifty_move_rule? || draw_by_threefold_repetition_rule? ||
        checkmate? || stalemate?
    end

    def to_active_player
      active_color = @position.to_active_color
      if active_color == :white
        @player_white
      elsif active_color == :black
        @player_black
      end
    end

    def to_inactive_player
      active_color = @position.to_active_color
      if active_color == :white
        @player_black
      elsif active_color == :black
        @player_white
      end
    end

    def display_board
      @display.render_board(@position.board.to_ranks, @log.metadata)
      # puts @position.to_fen.split[1..].join(' ') # Toggle optional extra FEN data
    end

    def select_source(source)
      @log.metadata[:current_source] = source
      @log.metadata[:currently_controlled] =
        @move_validator.to_legal_controlled_destinations_from(source)
      @log.metadata[:currently_attacked] =
        @move_validator.to_legal_attacked_destinations_from(source)
    end

    def deselect_source
      @log.metadata[:current_source] = nil
      @log.metadata[:currently_controlled] = nil
      @log.metadata[:currently_attacked] = nil
    end
  end
end
