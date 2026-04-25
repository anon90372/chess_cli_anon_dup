# frozen_string_literal: true

describe Chess::MoveValidator do
  describe '#legal_move?' do
    subject(:move_validator) do
      fen = Chess::DEFAULT_FEN
      fen_parser = Chess::FENParser.new(fen)
      position = Chess::Position.from_fen_parser(fen_parser)
      described_class.new(position)
    end

    context 'when the move is legal' do
      let(:source) { Chess::Coord.from_s('e2') }
      let(:destination) { Chess::Coord.from_s('e4') }

      it 'returns true' do
        expect(move_validator.legal_move?(source, destination)).to be(true)
      end
    end

    context 'when the move is illegal' do
      let(:source) { Chess::Coord.from_s('e2') }
      let(:destination) { Chess::Coord.from_s('e5') }

      it 'returns false' do
        expect(move_validator.legal_move?(source, destination)).to be(false)
      end
    end
  end

  describe '#legal_source?' do
    subject(:move_validator) do
      fen = Chess::DEFAULT_FEN
      fen_parser = Chess::FENParser.new(fen)
      position = Chess::Position.from_fen_parser(fen_parser)
      described_class.new(position)
    end

    context 'with any source occupied by the active color' do
      let(:sources) do
        %w[a1 b1 c1 d1 e1 f1 g1 h1 a2 b2 c2 d2 e2 f2 g2 h2].map do |coord_s|
          Chess::Coord.from_s(coord_s)
        end
      end

      it 'returns true' do
        result = sources.all? { |source| move_validator.legal_source?(source) }
        expect(result).to be(true)
      end
    end

    context 'with any source not occupied by the active color' do
      let(:sources) do
        %w[
          a3 b3 c3 d3 e3 f3 g3 h3
          a4 b4 c4 d4 e4 f4 g4 h4
          a5 b5 c5 d5 e5 f5 g5 h5
          a6 b6 c6 d6 e6 f6 g6 h6
          a7 b7 c7 d7 e7 f7 g7 h7
          a8 b8 c8 d8 e8 f8 g8 h8
        ].map { |coord_s| Chess::Coord.from_s(coord_s) }
      end

      it 'returns false' do
        result = sources.none? { |source| move_validator.legal_source?(source) }
        expect(result).to be(true)
      end
    end
  end

  describe '#any_legal_moves_available?' do
    context 'with at least one legal move' do
      subject(:move_validator) do
        fen = 'r1bk2nr/p2p1pNp/n2B1Q2/1p1NP2P/6P1/3P4/P1P1K3/q5b1 b - - 2 22'
        fen_parser = Chess::FENParser.new(fen)
        position = Chess::Position.from_fen_parser(fen_parser)
        described_class.new(position)
      end

      it 'returns true' do
        expect(move_validator.any_legal_moves_available?).to be(true)
      end
    end

    context 'with no legal moves' do
      subject(:move_validator) do
        fen = 'r1bk3r/p2pBpNp/n4n2/1p1NP2P/6P1/3P4/P1P1K3/q5b1 b - - 1 23'
        fen_parser = Chess::FENParser.new(fen)
        position = Chess::Position.from_fen_parser(fen_parser)
        described_class.new(position)
      end

      it 'returns false' do
        expect(move_validator.any_legal_moves_available?).to be(false)
      end
    end
  end

  describe '#to_all_legal_sources' do
    subject(:move_validator) do
      fen = Chess::DEFAULT_FEN
      fen_parser = Chess::FENParser.new(fen)
      position = Chess::Position.from_fen_parser(fen_parser)
      described_class.new(position)
    end

    it 'returns an array of all sources of the active color' do
      expect(move_validator.to_all_legal_sources).to match_array(
        %w[a2 b2 c2 d2 e2 f2 g2 h2 a1 b1 c1 d1 e1 f1 g1 h1].map do |coord_s|
          Chess::Coord.from_s(coord_s)
        end
      )
    end
  end

  describe '#to_all_legal_destinations' do
    subject(:move_validator) do
      fen = 'r1bk2nr/p2p1pNp/n2B1Q2/1p1NP2P/6P1/3P4/P1P1K3/q5b1 b - - 2 22'
      fen_parser = Chess::FENParser.new(fen)
      position = Chess::Position.from_fen_parser(fen_parser)
      described_class.new(position)
    end

    it 'returns an array of all legal destinations of the active color' do
      expect(move_validator.to_all_legal_destinations).to match_array(
        %w[e7 f6].map { |coord_s| Chess::Coord.from_s(coord_s) }
      )
    end
  end

  describe '#to_all_legal_destinations_from' do
    subject(:move_validator) do
      fen = 'r1bk2nr/p2p1pNp/n2B1Q2/1p1NP2P/6P1/3P4/P1P1K3/q5b1 b - - 2 22'
      fen_parser = Chess::FENParser.new(fen)
      position = Chess::Position.from_fen_parser(fen_parser)
      described_class.new(position)
    end

    let(:source_g8) { Chess::Coord.from_s('g8') }

    it 'returns an array of all legal destinations from the given source' do
      expect(move_validator.to_all_legal_destinations_from(source_g8)).to match_array(
        %w[e7 f6].map { |coord_s| Chess::Coord.from_s(coord_s) }
      )
    end
  end

  describe '#to_legal_attacked_destinations_from' do
    context 'when an en passant capture would remove check' do
      subject(:move_validator) do
        fen = 'rnb1kbnr/ppp3qp/3pp1p1/4Pp2/4K3/7N/PPPP1PPP/RNBQ1B1R w kq f6 0 8'
        fen_parser = Chess::FENParser.new(fen)
        position = Chess::Position.from_fen_parser(fen_parser)
        described_class.new(position)
      end

      example 'source e5' do
        source_e5 = Chess::Coord.from_s('e5')
        expect(move_validator.to_legal_attacked_destinations_from(source_e5))
          .to match_array(%w[f6].map { |coord_s| Chess::Coord.from_s(coord_s) })
      end
    end

    context 'when multiple pawns attack an en passant target' do
      subject(:move_validator) do
        fen = 'rnbqkb1r/p1p1p1pp/1p3p1n/2PpP3/8/8/PP1P1PPP/RNBQKBNR w KQkq d6 0 5'
        fen_parser = Chess::FENParser.new(fen)
        position = Chess::Position.from_fen_parser(fen_parser)
        described_class.new(position)
      end

      example 'source e5' do
        source_e5 = Chess::Coord.from_s('e5')
        expect(move_validator.to_legal_attacked_destinations_from(source_e5))
          .to match_array(%w[d6 f6].map { |coord_s| Chess::Coord.from_s(coord_s) })
      end

      example 'source c5' do
        source_c5 = Chess::Coord.from_s('c5')
        expect(move_validator.to_legal_attacked_destinations_from(source_c5))
          .to match_array(%w[b6 d6].map { |coord_s| Chess::Coord.from_s(coord_s) })
      end
    end

    context 'when an en passant capture would leave the active king in check' do
      subject(:move_validator) do
        fen = 'rnb1kb1r/ppqpp1pp/2p4n/4Pp2/5K2/8/PPPP1PPP/RNBQ1BNR w kq f6 0 7'
        fen_parser = Chess::FENParser.new(fen)
        position = Chess::Position.from_fen_parser(fen_parser)
        described_class.new(position)
      end

      example 'source e5' do
        source_e5 = Chess::Coord.from_s('e5')
        expect(move_validator.to_legal_attacked_destinations_from(source_e5))
          .to be_an(Array).and be_empty
      end
    end

    context 'when the active king is in check' do
      subject(:move_validator) do
        fen = 'r1bk2nr/p2p1pNp/n2B1Q2/1p1NP2P/6P1/3P4/P1P1K3/q5b1 b - - 2 22'
        fen_parser = Chess::FENParser.new(fen)
        position = Chess::Position.from_fen_parser(fen_parser)
        described_class.new(position)
      end

      example 'source g8' do
        source_g8 = Chess::Coord.from_s('g8')
        expect(move_validator.to_legal_attacked_destinations_from(source_g8))
          .to match_array(%w[f6].map { |coord_s| Chess::Coord.from_s(coord_s) })
      end

      example 'source a1' do
        source_a1 = Chess::Coord.from_s('a1')
        expect(move_validator.to_legal_attacked_destinations_from(source_a1))
          .to be_an(Array).and be_empty
      end
    end

    context 'with a mid game position' do
      subject(:move_validator) do
        fen = 'rnb1k1nr/p2p1ppp/8/1pbN1N1P/4PBP1/3P1Q2/PqP5/R4KR1 w kq - 0 18'
        fen_parser = Chess::FENParser.new(fen)
        position = Chess::Position.from_fen_parser(fen_parser)
        described_class.new(position)
      end

      example 'source f4' do
        source_f4 = Chess::Coord.from_s('f4')
        expect(move_validator.to_legal_attacked_destinations_from(source_f4))
          .to match_array(%w[b8].map { |coord_s| Chess::Coord.from_s(coord_s) })
      end

      example 'source f5' do
        source_f5 = Chess::Coord.from_s('f5')
        expect(move_validator.to_legal_attacked_destinations_from(source_f5))
          .to match_array(%w[g7].map { |coord_s| Chess::Coord.from_s(coord_s) })
      end

      example 'source e4' do
        source_e4 = Chess::Coord.from_s('e4')
        expect(move_validator.to_legal_attacked_destinations_from(source_e4))
          .to be_an(Array).and be_empty
      end

      example 'source c5' do
        source_c5 = Chess::Coord.from_s('c5')
        expect(move_validator.to_legal_attacked_destinations_from(source_c5))
          .to be_an(Array).and be_empty
      end

      example 'source d4' do
        source_d4 = Chess::Coord.from_s('d4')
        expect(move_validator.to_legal_attacked_destinations_from(source_d4))
          .to be_an(Array).and be_empty
      end
    end
  end

  describe '#to_legal_controlled_destinations_from' do
    context 'when both active castles are possible' do
      subject(:move_validator) do
        fen = 'rnbqkb1r/pppppppp/5n2/8/2B1PBQ1/N2P3N/PPP2PPP/R3K2R w KQkq - 5 8'
        fen_parser = Chess::FENParser.new(fen)
        position = Chess::Position.from_fen_parser(fen_parser)
        described_class.new(position)
      end

      example 'source e1' do
        source_e1 = Chess::Coord.from_s('e1')
        expect(move_validator.to_legal_controlled_destinations_from(source_e1))
          .to match_array(
            %w[d2 e2 d1 c1 f1 g1].map { |coord_s| Chess::Coord.from_s(coord_s) }
          )
      end
    end

    context 'when neither active castle is possible' do
      subject(:move_validator) do
        fen = 'rnbqkbnr/pppppppp/8/8/2B1PBQ1/3P3N/PPP2PPP/RN2K2R w Qkq - 11 11'
        fen_parser = Chess::FENParser.new(fen)
        position = Chess::Position.from_fen_parser(fen_parser)
        described_class.new(position)
      end

      example 'source e1' do
        source_e1 = Chess::Coord.from_s('e1')
        expect(move_validator.to_legal_controlled_destinations_from(source_e1))
          .to match_array(
            %w[d1 f1 e2 d2].map { |coord_s| Chess::Coord.from_s(coord_s) }
          )
      end
    end

    context 'when one active castle is possible' do
      subject(:move_validator) do
        fen = 'rnbqkb1r/pppppppp/8/8/2B1P3/2NP1Q1N/PPPB1PPn/R3K2R w KQq - 0 10'
        fen_parser = Chess::FENParser.new(fen)
        position = Chess::Position.from_fen_parser(fen_parser)
        described_class.new(position)
      end

      example 'source e1' do
        source_e1 = Chess::Coord.from_s('e1')
        expect(move_validator.to_legal_controlled_destinations_from(source_e1))
          .to match_array(
            %w[e2 d1 c1].map { |coord_s| Chess::Coord.from_s(coord_s) }
          )
      end
    end

    context 'when an active castling rook is under attack' do
      subject(:move_validator) do
        fen = 'rn1qkbnr/pbpppppp/8/1p2P3/2B5/6PN/PPPPQP1P/RNB1K2R w KQkq - 5 7'
        fen_parser = Chess::FENParser.new(fen)
        position = Chess::Position.from_fen_parser(fen_parser)
        described_class.new(position)
      end

      example 'source e1' do
        source_e1 = Chess::Coord.from_s('e1')
        expect(move_validator.to_legal_controlled_destinations_from(source_e1))
          .to match_array(
            %w[d1 f1 g1].map { |coord_s| Chess::Coord.from_s(coord_s) }
          )
      end
    end

    context 'when the active king is in check' do
      subject(:move_validator) do
        fen = 'r2qkbnr/pbpppppp/8/1p2P3/2B5/4Q1PN/PPnP1P1P/RNB1K2R w KQkq - 0 10'
        fen_parser = Chess::FENParser.new(fen)
        position = Chess::Position.from_fen_parser(fen_parser)
        described_class.new(position)
      end

      example 'source e1' do
        source_e1 = Chess::Coord.from_s('e1')
        expect(move_validator.to_legal_controlled_destinations_from(source_e1))
          .to match_array(
            %w[d1 f1 e2].map { |coord_s| Chess::Coord.from_s(coord_s) }
          )
      end

      example 'source e3' do
        source_e3 = Chess::Coord.from_s('e3')
        expect(move_validator.to_legal_controlled_destinations_from(source_e3))
          .to be_an(Array).and be_empty
      end
    end

    context 'with a mid game position' do
      subject(:move_validator) do
        fen = 'rnb1kb1r/p1pp1ppp/8/1B3Nqn/4Pp2/3P4/PPP3PP/RNBQ1K1R b kq - 4 9'
        fen_parser = Chess::FENParser.new(fen)
        position = Chess::Position.from_fen_parser(fen_parser)
        described_class.new(position)
      end

      example 'source e8' do
        source_e8 = Chess::Coord.from_s('e8')
        expect(move_validator.to_legal_controlled_destinations_from(source_e8))
          .to match_array(%w[d8].map { |coord_s| Chess::Coord.from_s(coord_s) })
      end

      example 'source d7' do
        source_d7 = Chess::Coord.from_s('d7')
        expect(move_validator.to_legal_controlled_destinations_from(source_d7))
          .to be_an(Array).and be_empty
      end

      example 'source c7' do
        source_c7 = Chess::Coord.from_s('c7')
        expect(move_validator.to_legal_controlled_destinations_from(source_c7))
          .to match_array(%w[c6 c5].map { |coord_s| Chess::Coord.from_s(coord_s) })
      end

      example 'source f4' do
        source_f4 = Chess::Coord.from_s('f4')
        expect(move_validator.to_legal_controlled_destinations_from(source_f4))
          .to match_array(%w[f3].map { |coord_s| Chess::Coord.from_s(coord_s) })
      end

      example 'source h5' do
        source_h5 = Chess::Coord.from_s('h5')
        expect(move_validator.to_legal_controlled_destinations_from(source_h5))
          .to match_array(%w[g3 f6].map { |coord_s| Chess::Coord.from_s(coord_s) })
      end

      example 'source g5' do
        source_g5 = Chess::Coord.from_s('g5')
        expect(move_validator.to_legal_controlled_destinations_from(source_g5))
          .to match_array(
            %w[g4 g3 h4 h6 g6 f6 e7 d8].map { |coord_s| Chess::Coord.from_s(coord_s) }
          )
      end

      example 'source f1' do
        source_f1 = Chess::Coord.from_s('f1')
        expect(move_validator.to_legal_controlled_destinations_from(source_f1))
          .to be_an(Array).and be_empty
      end

      example 'source f2' do
        source_f2 = Chess::Coord.from_s('f2')
        expect(move_validator.to_legal_controlled_destinations_from(source_f2))
          .to be_an(Array).and be_empty
      end
    end
  end
end
