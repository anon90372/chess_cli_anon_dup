# frozen_string_literal: true

module Chess
  # Displays a chess board on the command line
  class Display
    def initialize
      @current_bg_color = :yellow
    end

    def render_board(board_ranks, metadata)
      Chess::BOARD_RANK_MARKERS.each do |rank_i|
        render_rank(board_ranks[rank_i], rank_i, metadata)
        puts
      end
      puts Chess::BOARD_FILE_INDICATORS
    end

    private

    def render_rank(rank, rank_i, metadata)
      print "#{rank_i} "
      rank_i.even? ? update_current_bg_color(:yellow) : update_current_bg_color(:green)
      file_idx = 0
      rank.each do |square|
        coord_s = "#{Chess::BOARD_FILE_MARKERS[file_idx]}#{rank_i}"
        coord = Coord.from_s(coord_s)
        render_square(square, coord, @current_bg_color, metadata)
        swap_current_bg_color
        file_idx += 1
      end
    end

    # rubocop:disable Metrics/AbcSize,Metrics/CyclomaticComplexity,Metrics/MethodLength,Metrics/PerceivedComplexity
    def render_square(square, coord, bg_color, metadata)
      if metadata[:current_source] == coord
        render_source_square(square.occupant)
      elsif metadata[:checked_king] == coord
        render_checked_square(square.occupant)
      elsif metadata[:currently_controlled]&.include?(coord)
        render_controlled_square(bg_color)
      elsif metadata[:currently_attacked]&.include?(coord)
        render_attacked_square(square.occupant)
      elsif metadata[:previous_source] == coord
        render_previous_source_square
      elsif metadata[:previous_destination] == coord
        render_previous_destination_square(square.occupant)
      elsif square.occupied?
        render_occupied_square(square.occupant, bg_color)
      elsif square.vacant?
        render_vacant_square(bg_color)
      end
    end
    # rubocop:enable all

    def render_occupied_square(occupant, bg_color)
      fg_rgb_val = Chess::COLOR_RGB_MAP[occupant.color]
      bg_rgb_val = Chess::COLOR_RGB_MAP[bg_color]
      occupant_icon = Chess::PIECE_ICON_MAP[occupant.class]
      square = " #{occupant_icon} "
      print "\e[48;2;#{bg_rgb_val}m\e[38;2;#{fg_rgb_val}m#{square}\e[0m"
    end

    def render_vacant_square(bg_color)
      bg_rgb_val = Chess::COLOR_RGB_MAP[bg_color]
      square = '   '
      print "\e[48;2;#{bg_rgb_val}m#{square}\e[0m"
    end

    def render_controlled_square(bg_color)
      fg_rgb_val = Chess::COLOR_RGB_MAP[:lighter_orange]
      bg_rgb_val = Chess::COLOR_RGB_MAP[bg_color]
      square = " #{Chess::CONTROLLED_DESTINATION_INDICATOR} "
      print "\e[48;2;#{bg_rgb_val}m\e[38;2;#{fg_rgb_val}m#{square}\e[0m"
    end

    def render_checked_square(occupant)
      render_occupied_square(occupant, :red)
    end

    def render_source_square(occupant)
      render_occupied_square(occupant, :lighter_orange)
    end

    def render_attacked_square(occupant)
      if occupant.nil?
        render_vacant_square(:darker_orange)
      else
        render_occupied_square(occupant, :darker_orange)
      end
    end

    def render_previous_source_square
      render_vacant_square(:lighter_olive)
    end

    def render_previous_destination_square(occupant)
      render_occupied_square(occupant, :darker_olive)
    end

    def update_current_bg_color(color)
      return unless %i[yellow green].include?(color)

      @current_bg_color = color
    end

    def swap_current_bg_color
      if @current_bg_color == :yellow
        @current_bg_color = :green
      elsif @current_bg_color == :green
        @current_bg_color = :yellow
      end
    end
  end
end
