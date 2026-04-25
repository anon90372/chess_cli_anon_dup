# frozen_string_literal: true

describe Chess::PostMoveAnalyzer do
  describe '#move_was_double_pawn_push?' do
    context 'when white made a double pawn push' do
      subject(:post_move_analyzer) do
        fen = 'rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq e3 0 1'
        fen_parser = Chess::FENParser.new(fen)
        position = Chess::Position.from_fen_parser(fen_parser)
        log = Chess::Log.new(
          { previous_source: Chess::Coord.from_s('e2'),
            previous_destination: Chess::Coord.from_s('e4') }
        )
        described_class.new(position, log)
      end

      it 'returns true' do
        expect(post_move_analyzer.move_was_double_pawn_push?).to be(true)
      end
    end

    context 'when black made a double pawn push' do
      subject(:post_move_analyzer) do
        fen = 'rnbqkbnr/pppp1ppp/8/4p3/4P3/8/PPPP1PPP/RNBQKBNR w KQkq e6 0 2'
        fen_parser = Chess::FENParser.new(fen)
        position = Chess::Position.from_fen_parser(fen_parser)
        log = Chess::Log.new(
          { previous_source: Chess::Coord.from_s('e7'),
            previous_destination: Chess::Coord.from_s('e5') }
        )
        described_class.new(position, log)
      end

      it 'returns true' do
        expect(post_move_analyzer.move_was_double_pawn_push?).to be(true)
      end
    end

    context 'when white made a single pawn push' do
      subject(:post_move_analyzer) do
        fen = 'rnbqkbnr/pppppppp/8/8/8/4P3/PPPP1PPP/RNBQKBNR b KQkq - 0 1'
        fen_parser = Chess::FENParser.new(fen)
        position = Chess::Position.from_fen_parser(fen_parser)
        log = Chess::Log.new(
          { previous_source: Chess::Coord.from_s('e2'),
            previous_destination: Chess::Coord.from_s('e3') }
        )
        described_class.new(position, log)
      end

      it 'returns false' do
        expect(post_move_analyzer.move_was_double_pawn_push?).to be(false)
      end
    end

    context 'when black made a single pawn push' do
      subject(:post_move_analyzer) do
        fen = 'rnbqkbnr/pppp1ppp/4p3/8/8/4P3/PPPP1PPP/RNBQKBNR w KQkq - 0 2'
        fen_parser = Chess::FENParser.new(fen)
        position = Chess::Position.from_fen_parser(fen_parser)
        log = Chess::Log.new(
          { previous_source: Chess::Coord.from_s('e7'),
            previous_destination: Chess::Coord.from_s('e6') }
        )
        described_class.new(position, log)
      end

      it 'returns false' do
        expect(post_move_analyzer.move_was_double_pawn_push?).to be(false)
      end
    end

    context 'when a pawn was not moved' do
      subject(:post_move_analyzer) do
        fen = 'rnbqkbnr/pppp1ppp/4p3/8/2B5/4P3/PPPP1PPP/RNBQK1NR b KQkq - 1 2'
        fen_parser = Chess::FENParser.new(fen)
        position = Chess::Position.from_fen_parser(fen_parser)
        log = Chess::Log.new(
          { previous_source: Chess::Coord.from_s('f1'),
            previous_destination: Chess::Coord.from_s('c4') }
        )
        described_class.new(position, log)
      end

      it 'returns false' do
        expect(post_move_analyzer.move_was_double_pawn_push?).to be(false)
      end
    end
  end

  describe '#to_en_passant_target_s' do
    context 'when white made a double pawn push' do
      subject(:post_move_analyzer) do
        fen = 'rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq e3 0 1'
        fen_parser = Chess::FENParser.new(fen)
        position = Chess::Position.from_fen_parser(fen_parser)
        log = Chess::Log.new(
          { previous_source: Chess::Coord.from_s('e2'),
            previous_destination: Chess::Coord.from_s('e4') }
        )
        described_class.new(position, log)
      end

      it 'returns the appropriate en passant target string' do
        expect(post_move_analyzer.to_en_passant_target_s).to eq('e3')
      end
    end

    context 'when black made a double pawn push' do
      subject(:post_move_analyzer) do
        fen = 'rnbqkbnr/pppp1ppp/8/4p3/4P3/8/PPPP1PPP/RNBQKBNR w KQkq e6 0 2'
        fen_parser = Chess::FENParser.new(fen)
        position = Chess::Position.from_fen_parser(fen_parser)
        log = Chess::Log.new(
          { previous_source: Chess::Coord.from_s('e7'),
            previous_destination: Chess::Coord.from_s('e5') }
        )
        described_class.new(position, log)
      end

      it 'returns the appropriate en passant target string' do
        expect(post_move_analyzer.to_en_passant_target_s).to eq('e6')
      end
    end

    context 'when a pawn was not double pushed' do
      subject(:post_move_analyzer) do
        fen = 'rnbqkbnr/pppppppp/8/8/8/4P3/PPPP1PPP/RNBQKBNR b KQkq - 0 1'
        fen_parser = Chess::FENParser.new(fen)
        position = Chess::Position.from_fen_parser(fen_parser)
        log = Chess::Log.new(
          { previous_source: Chess::Coord.from_s('e2'),
            previous_destination: Chess::Coord.from_s('e3') }
        )
        described_class.new(position, log)
      end

      it 'returns a dash string' do
        expect(post_move_analyzer.to_en_passant_target_s).to eq('-')
      end
    end

    context 'when a pawn was not moved' do
      subject(:post_move_analyzer) do
        fen = 'rnbqkbnr/pppppppp/8/8/8/5N2/PPPPPPPP/RNBQKB1R b KQkq - 1 1'
        fen_parser = Chess::FENParser.new(fen)
        position = Chess::Position.from_fen_parser(fen_parser)
        log = Chess::Log.new(
          { previous_source: Chess::Coord.from_s('g1'),
            previous_destination: Chess::Coord.from_s('f3') }
        )
        described_class.new(position, log)
      end

      it 'returns a dash string' do
        expect(post_move_analyzer.to_en_passant_target_s).to eq('-')
      end
    end
  end
end
