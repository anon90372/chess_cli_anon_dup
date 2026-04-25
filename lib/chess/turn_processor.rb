# frozen_string_literal: true

module Chess
  # Processes a turn in the context of a chess position
  class TurnProcessor
    def self.play_turn(...)
      new(...).play_turn
    end

    # @param position [Position]
    # @param log [Log]
    # @param source [Coord] the legal source
    # @param destination [Coord] the legal destination
    def initialize(position:, log:, source:, destination:)
      @position = position
      @log = log
      @source = source
      @destination = destination
      @pre_move_analyzer = PreMoveAnalyzer.new(@position)
      @post_move_analyzer = PostMoveAnalyzer.new(@position, @log)
    end

    def play_turn
      log_fen if @log.fen_history.empty?
      move
      swap_colors
      log_fen
    end

    private

    def move
      update_metadata_before_move
      update_half_move_clock_before_move
      handle_castling_before_move
      update_castling_rights_before_move
      promotion_boolean = @pre_move_analyzer.move_to_promote?(@source, @destination)
      @position.move_piece(@source, @destination)
      update_en_passant_target_after_move
      handle_promotion_after_move(promotion_boolean)
    end

    def swap_colors
      update_full_move_number_before_color_swap
      swap_active_color
      update_metadata_after_move
    end

    def update_metadata_before_move
      @log.metadata[:previous_source] = @source
      @log.metadata[:previous_destination] = @destination
    end

    def update_half_move_clock_before_move
      if @position.board.pawn_at?(@source) ||
         @pre_move_analyzer.move_to_capture?(@source, @destination)
        @position.aux_pos_data.reset_half_move_clock
      else
        @position.aux_pos_data.increment_half_move_clock
      end
    end

    def update_castling_rights_before_move
      if @position.board.occupant_at(@source).is_a?(King)
        king = @position.board.occupant_at(@source)
        @position.aux_pos_data.remove_all_castling_rights(king.color)
      elsif @pre_move_analyzer.rook_at_home?(@source)
        @position.aux_pos_data.public_send(Chess::CASTLE_RIGHTS_REMOVAL_METHOD_MAP[@source])
      elsif @pre_move_analyzer.move_would_capture_rook_at_home?(@source, @destination)
        @position.aux_pos_data.public_send(Chess::CASTLE_RIGHTS_REMOVAL_METHOD_MAP[@destination])
      end
    end

    def handle_castling_before_move
      return unless @pre_move_analyzer.move_to_castle?(@source, @destination)

      source_and_destination = Chess::ROOK_CASTLING_COORD_MAP[@destination]
      rook_source = source_and_destination[:source]
      rook_destination = source_and_destination[:destination]
      @position.move_piece(rook_source, rook_destination)
    end

    def update_en_passant_target_after_move
      target_s = @post_move_analyzer.to_en_passant_target_s
      @position.aux_pos_data.update_en_passant_target(target_s)
    end

    def handle_promotion_after_move(promotion_boolean)
      return unless promotion_boolean

      promotion_type = Chess::PROMOTION_MAP[prompt_for_promotion]
      @position.board.replace_at(@destination, promotion_type)
    end

    def prompt_for_promotion
      loop do
        print 'Choose your promotion ["Queen", "Knight", "Bishop", "Rook"]: '
        inp = gets.chomp.downcase
        return inp if Chess::PROMOTION_MAP.key?(inp)

        puts "Invalid input: #{inp}\n\n"
      end
    end

    def update_full_move_number_before_color_swap
      @position.aux_pos_data.increment_full_move_number if @position.to_active_color == :black
    end

    def swap_active_color
      @position.aux_pos_data.swap_active_color
    end

    def update_metadata_after_move
      @log.metadata[:checked_king] =
        @position.check? ? @position.to_king_source(@position.to_active_color) : nil
    end

    def log_fen
      @log.fen_history << @position.to_fen
    end
  end
end
