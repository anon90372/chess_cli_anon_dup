# frozen_string_literal: true

describe Chess::Position do
  describe '#check?' do
    context 'when white is in check' do
      subject(:position_white_check) do
        fen = 'rnb1kbnr/pppp1ppp/8/8/2B1Pp1q/8/PPPP2PP/RNBQK1NR w KQkq - 2 4'
        fen_parser = Chess::FENParser.new(fen)
        described_class.from_fen_parser(fen_parser)
      end

      it 'returns true' do
        expect(position_white_check.check?).to be(true)
      end
    end

    context 'when black is in check' do
      subject(:position_black_check) do
        fen = 'r1bk2nr/p2p1pNp/n2B1Q2/1p1NP2P/6P1/3P4/P1P1K3/q5b1 b - - 2 22'
        fen_parser = Chess::FENParser.new(fen)
        described_class.from_fen_parser(fen_parser)
      end

      it 'returns true' do
        expect(position_black_check.check?).to be(true)
      end
    end

    context 'when the active color is not in check' do
      subject(:position_no_check) do
        fen = 'r1bk3r/p2p1pNp/n2B1n2/1p1NP2P/6P1/3P4/P1P1K3/q5b1 w - - 0 23'
        fen_parser = Chess::FENParser.new(fen)
        described_class.from_fen_parser(fen_parser)
      end

      it 'returns false' do
        expect(position_no_check.check?).to be(false)
      end
    end
  end

  describe '#to_attacked_destinations_from' do
    context 'with a mid game position' do
      subject(:position_mid) do
        fen = 'rnb1kb1r/p2p1ppp/2p2n2/1B3Nq1/4PpP1/3P4/PPP4P/RNBQ1KR1 b kq - 2 11'
        fen_parser = Chess::FENParser.new(fen)
        described_class.from_fen_parser(fen_parser)
      end

      example 'source f5' do
        expect(position_mid.to_attacked_destinations_from(Chess::Coord.from_s('f5')))
          .to match_array(%w[g7].map { |coord_s| Chess::Coord.from_s(coord_s) })
      end

      example 'source f6' do
        expect(position_mid.to_attacked_destinations_from(Chess::Coord.from_s('f6')))
          .to match_array(%w[e4 g4].map { |coord_s| Chess::Coord.from_s(coord_s) })
      end

      example 'source g5' do
        expect(position_mid.to_attacked_destinations_from(Chess::Coord.from_s('g5')))
          .to match_array(%w[f5 g4].map { |coord_s| Chess::Coord.from_s(coord_s) })
      end

      example 'source b5' do
        expect(position_mid.to_attacked_destinations_from(Chess::Coord.from_s('b5')))
          .to match_array(%w[c6].map { |coord_s| Chess::Coord.from_s(coord_s) })
      end

      example 'source c6' do
        expect(position_mid.to_attacked_destinations_from(Chess::Coord.from_s('c6')))
          .to match_array(%w[b5].map { |coord_s| Chess::Coord.from_s(coord_s) })
      end

      example 'source c1' do
        expect(position_mid.to_attacked_destinations_from(Chess::Coord.from_s('c1')))
          .to match_array(%w[f4].map { |coord_s| Chess::Coord.from_s(coord_s) })
      end

      example 'source g1' do
        expect(position_mid.to_attacked_destinations_from(Chess::Coord.from_s('g1')))
          .to be_an(Array).and be_empty
      end

      example 'source b8' do
        expect(position_mid.to_attacked_destinations_from(Chess::Coord.from_s('b8')))
          .to be_an(Array).and be_empty
      end

      example 'source e5' do
        expect(position_mid.to_attacked_destinations_from(Chess::Coord.from_s('e5')))
          .to be_an(Array).and be_empty
      end
    end
  end

  describe '#to_controlled_destinations_from' do
    context 'with a mid game position' do
      subject(:position_mid) do
        fen = 'rnb1kb1r/p2p1ppp/2p2n2/1B3Nq1/4PpP1/3P4/PPP4P/RNBQ1KR1 b kq - 2 11'
        fen_parser = Chess::FENParser.new(fen)
        described_class.from_fen_parser(fen_parser)
      end

      example 'source g5' do
        expect(position_mid.to_controlled_destinations_from(Chess::Coord.from_s('g5')))
          .to match_array(%w[g6 h6 h5 h4].map { |coord_s| Chess::Coord.from_s(coord_s) })
      end

      example 'source f5' do
        expect(position_mid.to_controlled_destinations_from(Chess::Coord.from_s('f5')))
          .to match_array(
            %w[d6 e7 h6 d4 e3 g3 h4].map { |coord_s| Chess::Coord.from_s(coord_s) }
          )
      end

      example 'source b5' do
        expect(position_mid.to_controlled_destinations_from(Chess::Coord.from_s('b5')))
          .to match_array(%w[a6 a4 c4].map { |coord_s| Chess::Coord.from_s(coord_s) })
      end

      example 'source f6' do
        expect(position_mid.to_controlled_destinations_from(Chess::Coord.from_s('f6')))
          .to match_array(%w[g8 d5 h5].map { |coord_s| Chess::Coord.from_s(coord_s) })
      end

      example 'source c6' do
        expect(position_mid.to_controlled_destinations_from(Chess::Coord.from_s('c6')))
          .to match_array(%w[c5].map { |coord_s| Chess::Coord.from_s(coord_s) })
      end

      example 'source c2' do
        expect(position_mid.to_controlled_destinations_from(Chess::Coord.from_s('c2')))
          .to match_array(%w[c3 c4].map { |coord_s| Chess::Coord.from_s(coord_s) })
      end

      example 'source d1' do
        expect(position_mid.to_controlled_destinations_from(Chess::Coord.from_s('d1')))
          .to match_array(%w[d2 e1 e2 f3].map { |coord_s| Chess::Coord.from_s(coord_s) })
      end

      example 'source a8' do
        expect(position_mid.to_controlled_destinations_from(Chess::Coord.from_s('a8')))
          .to be_an(Array).and be_empty
      end

      example 'source e3' do
        expect(position_mid.to_controlled_destinations_from(Chess::Coord.from_s('e3')))
          .to be_an(Array).and be_empty
      end
    end
  end

  describe '#to_attacked_destinations_by' do
    subject(:position_mid) do
      fen = 'rnb1kb1r/p2p1ppp/2p2n2/1B3Nq1/4PpP1/3P4/PPP4P/RNBQ1KR1 b kq - 2 11'
      fen_parser = Chess::FENParser.new(fen)
      described_class.from_fen_parser(fen_parser)
    end

    context 'with a white color' do
      it 'returns an array of all unique destinations attacked by white' do
        expect(position_mid.to_attacked_destinations_by(:white)).to match_array(
          %w[c6 g7 f4].map { |coord_s| Chess::Coord.from_s(coord_s) }
        )
      end
    end

    context 'with a black color' do
      it 'returns an array of all unique destinations attacked by black' do
        expect(position_mid.to_attacked_destinations_by(:black)).to match_array(
          %w[b5 e4 g4 f5].map { |coord_s| Chess::Coord.from_s(coord_s) }
        )
      end
    end
  end

  describe '#to_controlled_destinations_by' do
    subject(:position_mid) do
      fen = 'rnb1kb1r/p2p1ppp/2p2n2/1B3Nq1/4PpP1/3P4/PPP4P/RNBQ1KR1 b kq - 2 11'
      fen_parser = Chess::FENParser.new(fen)
      described_class.from_fen_parser(fen_parser)
    end

    context 'with a white color' do
      it 'returns an array of all unique destinations controlled by white' do
        expect(position_mid.to_controlled_destinations_by(:white)).to match_array(
          %w[
            a6 a4 c4 d6 e7 h6 h4 g3 e3 d4 e5 a3 b3 b4 c3 h3 d2 e1 e2 f3 f2 g2 h1
          ].map { |coord_s| Chess::Coord.from_s(coord_s) }
        )
      end
    end

    context 'with a black color' do
      it 'returns an array of all unique destinations controlled by black' do
        expect(position_mid.to_controlled_destinations_by(:black)).to match_array(
          %w[
            f3 h4 h5 h6 g6 c5 d5 g8 a6 a5 d6 b7 d8 e7 b4 a3
          ].map { |coord_s| Chess::Coord.from_s(coord_s) }
        )
      end
    end
  end

  describe '#move_piece' do
    context 'when capturing en passant' do
      subject(:position_mid) do
        fen = 'rnb1kbnr/ppp3qp/3pp1p1/4Pp2/4K3/7N/PPPP1PPP/RNBQ1B1R w kq f6 0 8'
        fen_parser = Chess::FENParser.new(fen)
        described_class.from_fen_parser(fen_parser)
      end

      example 'source e5 to destination f6' do
        position_mid.move_piece(Chess::Coord.from_s('e5'), Chess::Coord.from_s('f6'))
        expect(position_mid.to_fen.split.first).to eq('rnb1kbnr/ppp3qp/3ppPp1/8/4K3/7N/PPPP1PPP/RNBQ1B1R')
      end
    end

    context 'when capturing at the destination' do
      subject(:position_mid) do
        fen = 'rnbqkbnr/pppp1ppp/8/4p3/4PP2/8/PPPP2PP/RNBQKBNR b KQkq - 0 2'
        fen_parser = Chess::FENParser.new(fen)
        described_class.from_fen_parser(fen_parser)
      end

      example 'source e5 to destination f4' do
        position_mid.move_piece(Chess::Coord.from_s('e5'), Chess::Coord.from_s('f4'))
        expect(position_mid.to_fen.split.first).to eq('rnbqkbnr/pppp1ppp/8/8/4Pp2/8/PPPP2PP/RNBQKBNR')
      end
    end

    context 'when moving without capture' do
      subject(:position_mid) do
        fen = 'rnbqkbnr/pppp1ppp/8/8/4Pp2/8/PPPP2PP/RNBQKBNR w KQkq - 0 3'
        fen_parser = Chess::FENParser.new(fen)
        described_class.from_fen_parser(fen_parser)
      end

      example 'source f1 to destination c4' do
        position_mid.move_piece(Chess::Coord.from_s('f1'), Chess::Coord.from_s('c4'))
        expect(position_mid.to_fen.split.first).to eq('rnbqkbnr/pppp1ppp/8/8/2B1Pp2/8/PPPP2PP/RNBQK1NR')
      end
    end
  end

  describe '#move_would_leave_active_color_in_check?' do
    subject(:position_mid) do
      fen = 'rnb1kb1r/p1pp1ppp/5n2/1B6/4Pp1q/5N2/PPPP2PP/RNBQ1K1R b kq - 2 6'
      fen_parser = Chess::FENParser.new(fen)
      described_class.from_fen_parser(fen_parser)
    end

    context 'when the move would leave the active color in check' do
      let(:source) { Chess::Coord.from_s('d7') }
      let(:destination) { Chess::Coord.from_s('d6') }

      it 'returns true' do
        expect(position_mid.move_would_leave_active_color_in_check?(source, destination))
          .to be(true)
      end
    end

    context 'when the move would not leave the active color in check' do
      let(:source) { Chess::Coord.from_s('h4') }
      let(:destination) { Chess::Coord.from_s('h6') }

      it 'returns false' do
        expect(position_mid.move_would_leave_active_color_in_check?(source, destination))
          .to be(false)
      end
    end
  end

  describe '#to_active_color' do
    context 'when white is active' do
      subject(:position_white) do
        fen_parser = Chess::FENParser.new(Chess::DEFAULT_FEN)
        described_class.from_fen_parser(fen_parser)
      end

      it 'returns a white symbol' do
        expect(position_white.to_active_color).to eq(:white)
      end
    end

    context 'when black is active' do
      subject(:position_black) do
        fen = 'rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq e3 0 1'
        fen_parser = Chess::FENParser.new(fen)
        described_class.from_fen_parser(fen_parser)
      end

      it 'returns a black symbol' do
        expect(position_black.to_active_color).to eq(:black)
      end
    end
  end

  describe '#to_inactive_color' do
    context 'when white is active' do
      subject(:position_white) do
        fen_parser = Chess::FENParser.new(Chess::DEFAULT_FEN)
        described_class.from_fen_parser(fen_parser)
      end

      it 'returns a black symbol' do
        expect(position_white.to_inactive_color).to eq(:black)
      end
    end

    context 'when black is active' do
      subject(:position_black) do
        fen = 'rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq e3 0 1'
        fen_parser = Chess::FENParser.new(fen)
        described_class.from_fen_parser(fen_parser)
      end

      it 'returns a white symbol' do
        expect(position_black.to_inactive_color).to eq(:white)
      end
    end
  end

  describe '#to_all_sources' do
    subject(:position) do
      fen_parser = Chess::FENParser.new(Chess::DEFAULT_FEN)
      described_class.from_fen_parser(fen_parser)
    end

    context 'with a white color' do
      it 'returns an array of all the white sources' do
        expect(position.to_all_sources(:white)).to match_array(
          %w[a2 b2 c2 d2 e2 f2 g2 h2 a1 b1 c1 d1 e1 f1 g1 h1].map do |coord_s|
            Chess::Coord.from_s(coord_s)
          end
        )
      end
    end

    context 'with a black color' do
      it 'returns an array of all the black sources' do
        expect(position.to_all_sources(:black)).to match_array(
          %w[a7 b7 c7 d7 e7 f7 g7 h7 a8 b8 c8 d8 e8 f8 g8 h8].map do |coord_s|
            Chess::Coord.from_s(coord_s)
          end
        )
      end
    end
  end

  describe '#to_king_source' do
    subject(:position) do
      fen_parser = Chess::FENParser.new(Chess::DEFAULT_FEN)
      described_class.from_fen_parser(fen_parser)
    end

    context 'with a white color' do
      it 'returns the source of the white king' do
        expect(position.to_king_source(:white)).to eq(Chess::Coord.from_s('e1'))
      end
    end

    context 'with a black color' do
      it 'returns the source of the black king' do
        expect(position.to_king_source(:black)).to eq(Chess::Coord.from_s('e8'))
      end
    end
  end

  describe '#all_sources_free_from_enemy_attack?' do
    subject(:position_mid) do
      fen = 'rnb1kb1r/p2p1ppp/2p2n2/1B3Nq1/4PpP1/3P4/PPP4P/RNBQ1KR1 b kq - 2 11'
      fen_parser = Chess::FENParser.new(fen)
      described_class.from_fen_parser(fen_parser)
    end

    context 'when all of the given sources are free from enemy attack' do
      let(:sources) { [Chess::Coord.from_s('h5'), Chess::Coord.from_s('h6')] }
      let(:color) { :black }

      it 'returns true' do
        expect(position_mid.all_sources_free_from_enemy_attack?(sources, color))
          .to be(true)
      end
    end

    context 'when one or more of the given sources are under enemy attack' do
      let(:sources) { [Chess::Coord.from_s('h6'), Chess::Coord.from_s('g7')] }
      let(:color) { :black }

      it 'returns false' do
        expect(position_mid.all_sources_free_from_enemy_attack?(sources, color))
          .to be(false)
      end
    end
  end

  describe '#all_sources_free_from_enemy_control?' do
    subject(:position_mid) do
      fen = 'rnb1kb1r/p2p1ppp/2p2n2/1B3Nq1/4PpP1/3P4/PPP4P/RNBQ1KR1 b kq - 2 11'
      fen_parser = Chess::FENParser.new(fen)
      described_class.from_fen_parser(fen_parser)
    end

    context 'when all of the given sources are free from enemy control' do
      let(:sources) { [Chess::Coord.from_s('c3'), Chess::Coord.from_s('c4')] }
      let(:color) { :white }

      it 'returns true' do
        expect(position_mid.all_sources_free_from_enemy_control?(sources, color))
          .to be(true)
      end
    end

    context 'when one or more of the given sources are under enemy control' do
      let(:sources) { [Chess::Coord.from_s('e6'), Chess::Coord.from_s('d6')] }
      let(:color) { :black }

      it 'returns false' do
        expect(position_mid.all_sources_free_from_enemy_control?(sources, color))
          .to be(false)
      end
    end
  end

  describe '#all_sources_vacant?' do
    subject(:position) do
      fen_parser = Chess::FENParser.new(Chess::DEFAULT_FEN)
      described_class.from_fen_parser(fen_parser)
    end

    context 'when all of the given sources are vacant' do
      let(:sources) { [Chess::Coord.from_s('e3'), Chess::Coord.from_s('e4')] }

      it 'returns true' do
        expect(position.all_sources_vacant?(sources)).to be(true)
      end
    end

    context 'when one or more of the given sources are occupied' do
      let(:sources) { [Chess::Coord.from_s('e2'), Chess::Coord.from_s('e3')] }

      it 'returns false' do
        expect(position.all_sources_vacant?(sources)).to be(false)
      end
    end
  end

  describe '#to_fen' do
    context 'with a default position' do
      subject(:position_default) do
        fen_parser = Chess::FENParser.new(Chess::DEFAULT_FEN)
        described_class.from_fen_parser(fen_parser)
      end

      it 'returns the default fen record' do
        expect(position_default.to_fen).to eq(Chess::DEFAULT_FEN)
      end
    end
  end
end
