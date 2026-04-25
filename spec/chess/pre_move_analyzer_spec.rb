# frozen_string_literal: true

describe Chess::PreMoveAnalyzer do
  describe '#to_en_passant_destinations_from' do
    context 'when white can capture en passant' do
      subject(:pre_move_analyzer) do
        fen = 'rnbqkbnr/ppp1p1pp/3p4/4Pp2/8/8/PPPP1PPP/RNBQKBNR w KQkq f6 0 3'
        fen_parser = Chess::FENParser.new(fen)
        position = Chess::Position.from_fen_parser(fen_parser)
        described_class.new(position)
      end

      example 'source e5 returns an array of en passant destinations' do
        expect(pre_move_analyzer.to_en_passant_destinations_from(Chess::Coord.from_s('e5')))
          .to match_array(%w[f6].map { |coord_s| Chess::Coord.from_s(coord_s) })
      end
    end

    context 'when black can capture en passant' do
      subject(:pre_move_analyzer) do
        fen = 'rnbqkbnr/ppp1pppp/8/8/2Pp4/4PN2/PP1P1PPP/RNBQKB1R b KQkq c3 0 3'
        fen_parser = Chess::FENParser.new(fen)
        position = Chess::Position.from_fen_parser(fen_parser)
        described_class.new(position)
      end

      example 'source d4 returns an array of en passant destinations' do
        expect(pre_move_analyzer.to_en_passant_destinations_from(Chess::Coord.from_s('d4')))
          .to match_array(%w[c3].map { |coord_s| Chess::Coord.from_s(coord_s) })
      end
    end

    context 'when a pawn is in position without an en passant target' do
      subject(:pre_move_analyzer) do
        fen = 'r1bqkbnr/ppp1pppp/2n5/8/2Pp4/4P3/PP1P1PPP/RNBQKBNR b KQkq - 2 4'
        fen_parser = Chess::FENParser.new(fen)
        position = Chess::Position.from_fen_parser(fen_parser)
        described_class.new(position)
      end

      example 'source d4 returns an empty array' do
        expect(pre_move_analyzer.to_en_passant_destinations_from(Chess::Coord.from_s('d4')))
          .to be_an(Array).and be_empty
      end
    end

    context 'when a pawn is out of position for en passant capture' do
      subject(:pre_move_analyzer) do
        fen = 'r1bqkbnr/ppp1pppp/2n5/8/2Pp4/4P3/PP1P1PPP/RNBQKBNR b KQkq - 2 4'
        fen_parser = Chess::FENParser.new(fen)
        position = Chess::Position.from_fen_parser(fen_parser)
        described_class.new(position)
      end

      example 'source e3 returns an empty array' do
        expect(pre_move_analyzer.to_en_passant_destinations_from(Chess::Coord.from_s('e3')))
          .to be_an(Array).and be_empty
      end
    end

    context 'when the piece at the source is not a pawn' do
      subject(:pre_move_analyzer) do
        fen = 'r1bqkbnr/ppp1pppp/2n5/8/2Pp4/4P3/PP1P1PPP/RNBQKBNR b KQkq - 2 4'
        fen_parser = Chess::FENParser.new(fen)
        position = Chess::Position.from_fen_parser(fen_parser)
        described_class.new(position)
      end

      example 'source c6 returns an empty array' do
        expect(pre_move_analyzer.to_en_passant_destinations_from(Chess::Coord.from_s('c6')))
          .to be_an(Array).and be_empty
      end
    end
  end

  describe '#en_passant_attack?' do
    context 'when a white pawn would move to the en passant target' do
      subject(:pre_move_analyzer) do
        fen = 'rnbqkbnr/ppp1p1pp/3p4/4Pp2/8/8/PPPP1PPP/RNBQKBNR w KQkq f6 0 3'
        fen_parser = Chess::FENParser.new(fen)
        position = Chess::Position.from_fen_parser(fen_parser)
        described_class.new(position)
      end

      let(:source_e5) { Chess::Coord.from_s('e5') }
      let(:destination_f6) { Chess::Coord.from_s('f6') }

      example 'source e5 to destination f6 returns true' do
        expect(pre_move_analyzer.en_passant_attack?(source_e5, destination_f6))
          .to be(true)
      end
    end

    context 'when a black pawn would move to the en passant target' do
      subject(:pre_move_analyzer) do
        fen = 'rnbqkbnr/ppp1pppp/8/8/2Pp4/4P3/PP1PNPPP/RNBQKB1R b KQkq c3 0 3'
        fen_parser = Chess::FENParser.new(fen)
        position = Chess::Position.from_fen_parser(fen_parser)
        described_class.new(position)
      end

      let(:source_d4) { Chess::Coord.from_s('d4') }
      let(:destination_c3) { Chess::Coord.from_s('c3') }

      example 'source d4 to destination c3 returns true' do
        expect(pre_move_analyzer.en_passant_attack?(source_d4, destination_c3))
          .to be(true)
      end
    end

    context 'when a pawn would not move to the en passant target' do
      subject(:pre_move_analyzer) do
        fen = 'rnbqkbnr/ppp1pppp/8/8/2Pp4/4P3/PP1PNPPP/RNBQKB1R b KQkq c3 0 3'
        fen_parser = Chess::FENParser.new(fen)
        position = Chess::Position.from_fen_parser(fen_parser)
        described_class.new(position)
      end

      let(:source_d4) { Chess::Coord.from_s('d4') }
      let(:destination_d3) { Chess::Coord.from_s('d3') }

      example 'source d4 to destination d3 returns false' do
        expect(pre_move_analyzer.en_passant_attack?(source_d4, destination_d3))
          .to be(false)
      end
    end

    context 'when a non-pawn would move to the en passant target' do
      subject(:pre_move_analyzer) do
        fen = 'rnbqkbnr/ppp1p1pp/3p4/4Pp2/6N1/N7/PPPP1PPP/R1BQKB1R w KQkq f6 0 9'
        fen_parser = Chess::FENParser.new(fen)
        position = Chess::Position.from_fen_parser(fen_parser)
        described_class.new(position)
      end

      let(:source_g4) { Chess::Coord.from_s('g4') }
      let(:destination_f6) { Chess::Coord.from_s('f6') }

      example 'source g4 to destination f6 returns false' do
        expect(pre_move_analyzer.en_passant_attack?(source_g4, destination_f6))
          .to be(false)
      end
    end

    context 'when there is no en passant target' do
      subject(:pre_move_analyzer) do
        fen = Chess::DEFAULT_FEN
        fen_parser = Chess::FENParser.new(fen)
        position = Chess::Position.from_fen_parser(fen_parser)
        described_class.new(position)
      end

      let(:source_e2) { Chess::Coord.from_s('e2') }
      let(:destination_e4) { Chess::Coord.from_s('e4') }

      example 'source e2 to destination e4 returns false' do
        expect(pre_move_analyzer.en_passant_attack?(source_e2, destination_e4))
          .to be(false)
      end
    end
  end

  describe '#to_en_passant_capture_coord' do
    context 'when a white pawn is en passant vulnerable' do
      subject(:pre_move_analyzer) do
        fen = 'rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq e3 0 1'
        fen_parser = Chess::FENParser.new(fen)
        position = Chess::Position.from_fen_parser(fen_parser)
        described_class.new(position)
      end

      it 'returns the appropriate capture coord' do
        expect(pre_move_analyzer.to_en_passant_capture_coord)
          .to eq(Chess::Coord.from_s('e4'))
      end
    end

    context 'when a black pawn is en passant vulnerable' do
      subject(:pre_move_analyzer) do
        fen = 'rnbqkbnr/pppp1ppp/8/4p3/4P3/8/PPPP1PPP/RNBQKBNR w KQkq e6 0 2'
        fen_parser = Chess::FENParser.new(fen)
        position = Chess::Position.from_fen_parser(fen_parser)
        described_class.new(position)
      end

      it 'returns the appropriate capture coord' do
        expect(pre_move_analyzer.to_en_passant_capture_coord)
          .to eq(Chess::Coord.from_s('e5'))
      end
    end

    context 'without an en passant target' do
      subject(:pre_move_analyzer) do
        fen = Chess::DEFAULT_FEN
        fen_parser = Chess::FENParser.new(fen)
        position = Chess::Position.from_fen_parser(fen_parser)
        described_class.new(position)
      end

      it 'returns a dash string' do
        expect(pre_move_analyzer.to_en_passant_capture_coord).to eq('-')
      end
    end
  end

  describe '#to_castle_destinations_from' do
    context 'when all castles are possible' do
      subject(:pre_move_analyzer) do
        fen = 'r3k2r/p1pp1ppp/bpn4n/2b1p1q1/2B1P1Q1/BPN4N/P1PP1PPP/R3K2R w KQkq - 4 8'
        fen_parser = Chess::FENParser.new(fen)
        position = Chess::Position.from_fen_parser(fen_parser)
        described_class.new(position)
      end

      example 'source e1 returns an array of castle destinations' do
        expect(pre_move_analyzer.to_castle_destinations_from(Chess::Coord.from_s('e1')))
          .to match_array(%w[c1 g1].map { |coord_s| Chess::Coord.from_s(coord_s) })
      end

      example 'source e8 returns an array of castle destinations' do
        expect(pre_move_analyzer.to_castle_destinations_from(Chess::Coord.from_s('e8')))
          .to match_array(%w[c8 g8].map { |coord_s| Chess::Coord.from_s(coord_s) })
      end

      example 'source h1 returns an empty array' do
        expect(pre_move_analyzer.to_castle_destinations_from(Chess::Coord.from_s('h1')))
          .to be_an(Array).and be_empty
      end
    end

    context 'when no castles are possible' do
      subject(:pre_move_analyzer) do
        fen = 'r3k1nr/p1p2ppp/b1np4/1pb1p1q1/1PB1P3/B1N4Q/P1PP1PPP/R3K1NR w Kkq - 2 10'
        fen_parser = Chess::FENParser.new(fen)
        position = Chess::Position.from_fen_parser(fen_parser)
        described_class.new(position)
      end

      example 'source e1 returns an empty array' do
        expect(pre_move_analyzer.to_castle_destinations_from(Chess::Coord.from_s('e1')))
          .to be_an(Array).and be_empty
      end

      example 'source e8 returns an empty array' do
        expect(pre_move_analyzer.to_castle_destinations_from(Chess::Coord.from_s('e8')))
          .to be_an(Array).and be_empty
      end
    end

    context 'when some castles are possible' do
      subject(:pre_move_analyzer) do
        fen = 'r3k1nr/p1p2ppp/b1np4/1pb1p3/1PB1P2q/B1N2N1Q/P1PP1PPP/R3K2R w Kkq - 4 11'
        fen_parser = Chess::FENParser.new(fen)
        position = Chess::Position.from_fen_parser(fen_parser)
        described_class.new(position)
      end

      example 'source e1 returns an array of castle destinations' do
        expect(pre_move_analyzer.to_castle_destinations_from(Chess::Coord.from_s('e1')))
          .to match_array(%w[g1].map { |coord_s| Chess::Coord.from_s(coord_s) })
      end

      example 'source e8 returns an empty array' do
        expect(pre_move_analyzer.to_castle_destinations_from(Chess::Coord.from_s('e8')))
          .to be_an(Array).and be_empty
      end
    end
  end

  describe '#move_to_castle?' do
    context 'when the move would castle' do
      subject(:pre_move_analyzer) do
        fen = 'rnbqkb1r/pppppppp/7n/8/2B1P3/7N/PPPP1PPP/RNBQK2R w KQkq - 5 4'
        fen_parser = Chess::FENParser.new(fen)
        position = Chess::Position.from_fen_parser(fen_parser)
        described_class.new(position)
      end

      let(:source_e1) { Chess::Coord.from_s('e1') }
      let(:destination_g1) { Chess::Coord.from_s('g1') }

      example 'source e1 to destination g1 returns true' do
        expect(pre_move_analyzer.move_to_castle?(source_e1, destination_g1))
          .to be(true)
      end
    end

    context 'when the move would not castle' do
      subject(:pre_move_analyzer) do
        fen = 'rnbqkb1r/pppppppp/7n/8/2B1P3/7N/PPPP1PPP/RNBQK2R w KQkq - 5 4'
        fen_parser = Chess::FENParser.new(fen)
        position = Chess::Position.from_fen_parser(fen_parser)
        described_class.new(position)
      end

      let(:source_e1) { Chess::Coord.from_s('e1') }
      let(:destination_f1) { Chess::Coord.from_s('f1') }

      example 'source e1 to destination f1 returns false' do
        expect(pre_move_analyzer.move_to_castle?(source_e1, destination_f1))
          .to be(false)
      end
    end
  end

  describe '#move_to_capture?' do
    context 'when white would capture en passant' do
      subject(:pre_move_analyzer) do
        fen = 'rnbqkbnr/ppp1p1pp/5p2/3pP3/8/8/PPPP1PPP/RNBQKBNR w KQkq d6 0 3'
        fen_parser = Chess::FENParser.new(fen)
        position = Chess::Position.from_fen_parser(fen_parser)
        described_class.new(position)
      end

      let(:source_e5) { Chess::Coord.from_s('e5') }
      let(:destination_d6) { Chess::Coord.from_s('d6') }

      example 'source e5 to destination d6 returns true' do
        expect(pre_move_analyzer.move_to_capture?(source_e5, destination_d6))
          .to be(true)
      end
    end

    context 'when black would capture en passant' do
      subject(:pre_move_analyzer) do
        fen = 'rnbqkbnr/pppp1ppp/8/8/4pP2/3P3N/PPP1P1PP/RNBQKB1R b KQkq f3 0 3'
        fen_parser = Chess::FENParser.new(fen)
        position = Chess::Position.from_fen_parser(fen_parser)
        described_class.new(position)
      end

      let(:source_e4) { Chess::Coord.from_s('e4') }
      let(:destination_f3) { Chess::Coord.from_s('f3') }

      example 'source e4 to destination f3 returns true' do
        expect(pre_move_analyzer.move_to_capture?(source_e4, destination_f3))
          .to be(true)
      end
    end

    context 'when moving to a destination occupied by the enemy' do
      subject(:pre_move_analyzer) do
        fen = 'rnbqkbnr/ppp1pppp/8/3p4/2B1P3/8/PPPP1PPP/RNBQK1NR w KQkq - 0 3'
        fen_parser = Chess::FENParser.new(fen)
        position = Chess::Position.from_fen_parser(fen_parser)
        described_class.new(position)
      end

      let(:source_c4) { Chess::Coord.from_s('c4') }
      let(:destination_d5) { Chess::Coord.from_s('d5') }

      example 'source c4 to destination d5 returns true' do
        expect(pre_move_analyzer.move_to_capture?(source_c4, destination_d5))
          .to be(true)
      end
    end

    context 'when moving to a vacant destination and not capturing en passant' do
      subject(:pre_move_analyzer) do
        fen = 'rnbqkbnr/ppp1pppp/8/3p4/2B1P3/8/PPPP1PPP/RNBQK1NR w KQkq - 0 3'
        fen_parser = Chess::FENParser.new(fen)
        position = Chess::Position.from_fen_parser(fen_parser)
        described_class.new(position)
      end

      let(:source_c4) { Chess::Coord.from_s('c4') }
      let(:destination_a6) { Chess::Coord.from_s('a6') }

      example 'source c4 to destination a6 returns false' do
        expect(pre_move_analyzer.move_to_capture?(source_c4, destination_a6))
          .to be(false)
      end
    end
  end

  describe '#rook_at_home?' do
    context 'when white and black rooks are at home' do
      subject(:pre_move_analyzer) do
        fen = Chess::DEFAULT_FEN
        fen_parser = Chess::FENParser.new(fen)
        position = Chess::Position.from_fen_parser(fen_parser)
        described_class.new(position)
      end

      example 'source h1 returns true' do
        expect(pre_move_analyzer.rook_at_home?(Chess::Coord.from_s('h1'))).to be(true)
      end

      example 'source a1 returns true' do
        expect(pre_move_analyzer.rook_at_home?(Chess::Coord.from_s('a1'))).to be(true)
      end

      example 'source h8 returns true' do
        expect(pre_move_analyzer.rook_at_home?(Chess::Coord.from_s('h8'))).to be(true)
      end

      example 'source a8 returns true' do
        expect(pre_move_analyzer.rook_at_home?(Chess::Coord.from_s('a8'))).to be(true)
      end
    end

    context 'when white and black rooks are not at home' do
      subject(:pre_move_analyzer) do
        fen = '1nbqkbnR/rpppppp1/p7/P6p/7P/8/RPPPPPP1/1NBQKBNr w - - 11 12'
        fen_parser = Chess::FENParser.new(fen)
        position = Chess::Position.from_fen_parser(fen_parser)
        described_class.new(position)
      end

      example 'source a2 returns false' do
        expect(pre_move_analyzer.rook_at_home?(Chess::Coord.from_s('a2'))).to be(false)
      end

      example 'source h1 returns false' do
        expect(pre_move_analyzer.rook_at_home?(Chess::Coord.from_s('h1'))).to be(false)
      end

      example 'source a7 returns false' do
        expect(pre_move_analyzer.rook_at_home?(Chess::Coord.from_s('a7'))).to be(false)
      end

      example 'source h8 returns false' do
        expect(pre_move_analyzer.rook_at_home?(Chess::Coord.from_s('h8'))).to be(false)
      end
    end
  end

  describe '#move_would_capture_rook_at_home?' do
    context 'when capturing a white rook at home' do
      subject(:pre_move_analyzer) do
        fen = 'rnbqkb1r/pppppppp/8/8/5N2/6n1/PPPPPPPP/RNBQKB1R b KQkq - 7 4'
        fen_parser = Chess::FENParser.new(fen)
        position = Chess::Position.from_fen_parser(fen_parser)
        described_class.new(position)
      end

      let(:source_g3) { Chess::Coord.from_s('g3') }
      let(:destination_h1) { Chess::Coord.from_s('h1') }

      example 'source g3 to destination h1 returns true' do
        expect(pre_move_analyzer.move_would_capture_rook_at_home?(source_g3, destination_h1))
          .to be(true)
      end
    end

    context 'when capturing a black rook at home' do
      subject(:pre_move_analyzer) do
        fen = 'r1bqkb1r/pppppppp/2n3N1/8/8/8/PPPPPPPP/RNBQKB1n w Qkq - 2 6'
        fen_parser = Chess::FENParser.new(fen)
        position = Chess::Position.from_fen_parser(fen_parser)
        described_class.new(position)
      end

      let(:source_g6) { Chess::Coord.from_s('g6') }
      let(:destination_h8) { Chess::Coord.from_s('h8') }

      example 'source g6 to destination h8 returns true' do
        expect(pre_move_analyzer.move_would_capture_rook_at_home?(source_g6, destination_h8))
          .to be(true)
      end
    end

    context 'when capturing rooks not at home' do
      subject(:pre_move_analyzer) do
        fen = 'R1bqkb2/1p1ppppr/1np5/p5Np/P5nP/1N6/1PPPPPPR/r1BQKB2 b - - 1 20'
        fen_parser = Chess::FENParser.new(fen)
        position = Chess::Position.from_fen_parser(fen_parser)
        described_class.new(position)
      end

      example 'source g4 to destination h2 returns false' do
        result = pre_move_analyzer.move_would_capture_rook_at_home?(
          Chess::Coord.from_s('g4'), Chess::Coord.from_s('h2')
        )
        expect(result).to be(false)
      end

      example 'source g5 to destination h7 returns false' do
        result = pre_move_analyzer.move_would_capture_rook_at_home?(
          Chess::Coord.from_s('g5'), Chess::Coord.from_s('h7')
        )
        expect(result).to be(false)
      end

      example 'source b6 to destination a8 returns false' do
        result = pre_move_analyzer.move_would_capture_rook_at_home?(
          Chess::Coord.from_s('b6'), Chess::Coord.from_s('a8')
        )
        expect(result).to be(false)
      end

      example 'source b3 to destination a1 returns false' do
        result = pre_move_analyzer.move_would_capture_rook_at_home?(
          Chess::Coord.from_s('b3'), Chess::Coord.from_s('a1')
        )
        expect(result).to be(false)
      end
    end

    context 'when not capturing a rook at home or not capturing at all' do
      subject(:pre_move_analyzer) do
        fen = 'R1bqkb2/1p1ppppr/1np5/p5Np/P5nP/1N6/1PPPPPPR/r1BQKB2 b - - 1 20'
        fen_parser = Chess::FENParser.new(fen)
        position = Chess::Position.from_fen_parser(fen_parser)
        described_class.new(position)
      end

      example 'source g4 to destination f2 returns false' do
        result = pre_move_analyzer.move_would_capture_rook_at_home?(
          Chess::Coord.from_s('g4'), Chess::Coord.from_s('f2')
        )
        expect(result).to be(false)
      end

      example 'source g4 to destination f6 returns false' do
        result = pre_move_analyzer.move_would_capture_rook_at_home?(
          Chess::Coord.from_s('g4'), Chess::Coord.from_s('f6')
        )
        expect(result).to be(false)
      end
    end
  end

  describe '#move_to_promote?' do
    context 'when a white pawn would move to promote' do
      subject(:pre_move_analyzer) do
        fen = 'rnbqkbnr/pppppp1P/6p1/8/8/8/PPPPPP1P/RNBQKBNR w KQkq - 1 5'
        fen_parser = Chess::FENParser.new(fen)
        position = Chess::Position.from_fen_parser(fen_parser)
        described_class.new(position)
      end

      example 'source h7 to destination g8 returns true' do
        result = pre_move_analyzer.move_to_promote?(
          Chess::Coord.from_s('h7'), Chess::Coord.from_s('g8')
        )
        expect(result).to be(true)
      end
    end

    context 'when a black pawn would move to promote' do
      subject(:pre_move_analyzer) do
        fen = 'rnbqkb1r/ppp1pppp/5n2/4P1N1/5B2/3P4/PPp2PPP/RN1QKB1R b KQkq - 2 6'
        fen_parser = Chess::FENParser.new(fen)
        position = Chess::Position.from_fen_parser(fen_parser)
        described_class.new(position)
      end

      example 'source c2 to destination c1 returns true' do
        result = pre_move_analyzer.move_to_promote?(
          Chess::Coord.from_s('c2'), Chess::Coord.from_s('c1')
        )
        expect(result).to be(true)
      end
    end

    context 'when a pawn would not move to promote' do
      subject(:pre_move_analyzer) do
        fen = 'rnbqkb1r/ppp1pppp/5n2/4P1N1/5B2/3P4/PPp2PPP/RN1QKB1R b KQkq - 2 6'
        fen_parser = Chess::FENParser.new(fen)
        position = Chess::Position.from_fen_parser(fen_parser)
        described_class.new(position)
      end

      example 'source e7 to destination e6 returns false' do
        result = pre_move_analyzer.move_to_promote?(
          Chess::Coord.from_s('e7'), Chess::Coord.from_s('e6')
        )
        expect(result).to be(false)
      end
    end

    context 'when not moving a pawn' do
      subject(:pre_move_analyzer) do
        fen = 'rnbqkb1r/ppp1pppp/5n2/4P1N1/5B2/3P4/PPp2PPP/RN1QKB1R b KQkq - 2 6'
        fen_parser = Chess::FENParser.new(fen)
        position = Chess::Position.from_fen_parser(fen_parser)
        described_class.new(position)
      end

      example 'source f6 to destination g8 returns false' do
        result = pre_move_analyzer.move_to_promote?(
          Chess::Coord.from_s('f6'), Chess::Coord.from_s('g8')
        )
        expect(result).to be(false)
      end
    end
  end
end
