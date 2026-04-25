# frozen_string_literal: true

describe Chess::Game do
  describe '#play_turn' do
    context 'when playing an illegal turn' do
      subject(:game) { described_class.new }

      example 'source e7 to destination e1 raises an argument error' do
        expect { game.play_turn(Chess::Coord.from_s('e7'), Chess::Coord.from_s('e1')) }
          .to raise_error(ArgumentError)
      end
    end

    context 'when playing turn one of the immortal game' do
      subject(:game) { described_class.new }

      let(:source_e2) { Chess::Coord.from_s('e2') }
      let(:destination_e4) { Chess::Coord.from_s('e4') }
      let(:fen_history_before) { [] }
      let(:fen_history_after) do
        [
          Chess::DEFAULT_FEN,
          'rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq e3 0 1'
        ]
      end

      example 'source e2 to destination e4 produces the expected position' do
        expect { game.play_turn(source_e2, destination_e4) }
          .to change { game.instance_variable_get(:@position).to_fen }
          .from(Chess::DEFAULT_FEN)
          .to('rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq e3 0 1')
      end

      example 'source e2 to destination e4 logs the expected fen history' do
        expect { game.play_turn(source_e2, destination_e4) }
          .to change { game.instance_variable_get(:@log).fen_history }
          .from(fen_history_before)
          .to(fen_history_after)
      end
    end

    context 'when playing turn two of the immortal game' do
      subject(:game) do
        fen = 'rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq e3 0 1'
        fen_parser = Chess::FENParser.new(fen)
        position = Chess::Position.from_fen_parser(fen_parser)
        log = Chess::Log.new(
          {},
          [
            Chess::DEFAULT_FEN,
            'rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq e3 0 1'
          ]
        )
        described_class.new(position: position, log: log)
      end

      let(:source_e7) { Chess::Coord.from_s('e7') }
      let(:destination_e5) { Chess::Coord.from_s('e5') }
      let(:fen_history_before) do
        [
          Chess::DEFAULT_FEN,
          'rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq e3 0 1'
        ]
      end
      let(:fen_history_after) do
        [
          Chess::DEFAULT_FEN,
          'rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq e3 0 1',
          'rnbqkbnr/pppp1ppp/8/4p3/4P3/8/PPPP1PPP/RNBQKBNR w KQkq e6 0 2'
        ]
      end

      example 'source e7 to destination e5 produces the expected position' do
        expect { game.play_turn(source_e7, destination_e5) }
          .to change { game.instance_variable_get(:@position).to_fen }
          .from('rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq e3 0 1')
          .to('rnbqkbnr/pppp1ppp/8/4p3/4P3/8/PPPP1PPP/RNBQKBNR w KQkq e6 0 2')
      end

      example 'source e7 to destination e5 logs the expected fen history' do
        expect { game.play_turn(source_e7, destination_e5) }
          .to change { game.instance_variable_get(:@log).fen_history }
          .from(fen_history_before)
          .to(fen_history_after)
      end
    end

    context 'when playing turn three of the immortal game' do
      subject(:game) do
        fen = 'rnbqkbnr/pppp1ppp/8/4p3/4P3/8/PPPP1PPP/RNBQKBNR w KQkq e6 0 2'
        fen_parser = Chess::FENParser.new(fen)
        position = Chess::Position.from_fen_parser(fen_parser)
        described_class.new(position: position)
      end

      example 'source f2 to destination f4 produces the expected position' do
        expect { game.play_turn(Chess::Coord.from_s('f2'), Chess::Coord.from_s('f4')) }
          .to change { game.instance_variable_get(:@position).to_fen }
          .from('rnbqkbnr/pppp1ppp/8/4p3/4P3/8/PPPP1PPP/RNBQKBNR w KQkq e6 0 2')
          .to('rnbqkbnr/pppp1ppp/8/4p3/4PP2/8/PPPP2PP/RNBQKBNR b KQkq f3 0 2')
      end
    end

    context 'when playing turn four of the immortal game' do
      subject(:game) do
        fen = 'rnbqkbnr/pppp1ppp/8/4p3/4PP2/8/PPPP2PP/RNBQKBNR b KQkq f3 0 2'
        fen_parser = Chess::FENParser.new(fen)
        position = Chess::Position.from_fen_parser(fen_parser)
        described_class.new(position: position)
      end

      example 'source e5 to destination f4 produces the expected position' do
        expect { game.play_turn(Chess::Coord.from_s('e5'), Chess::Coord.from_s('f4')) }
          .to change { game.instance_variable_get(:@position).to_fen }
          .from('rnbqkbnr/pppp1ppp/8/4p3/4PP2/8/PPPP2PP/RNBQKBNR b KQkq f3 0 2')
          .to('rnbqkbnr/pppp1ppp/8/8/4Pp2/8/PPPP2PP/RNBQKBNR w KQkq - 0 3')
      end
    end

    context 'when playing turn five of the immortal game' do
      subject(:game) do
        fen = 'rnbqkbnr/pppp1ppp/8/8/4Pp2/8/PPPP2PP/RNBQKBNR w KQkq - 0 3'
        fen_parser = Chess::FENParser.new(fen)
        position = Chess::Position.from_fen_parser(fen_parser)
        described_class.new(position: position)
      end

      example 'source f1 to destination c4 produces the expected position' do
        expect { game.play_turn(Chess::Coord.from_s('f1'), Chess::Coord.from_s('c4')) }
          .to change { game.instance_variable_get(:@position).to_fen }
          .from('rnbqkbnr/pppp1ppp/8/8/4Pp2/8/PPPP2PP/RNBQKBNR w KQkq - 0 3')
          .to('rnbqkbnr/pppp1ppp/8/8/2B1Pp2/8/PPPP2PP/RNBQK1NR b KQkq - 1 3')
      end
    end

    context 'when playing turn six of the immortal game' do
      subject(:game) do
        fen = 'rnbqkbnr/pppp1ppp/8/8/2B1Pp2/8/PPPP2PP/RNBQK1NR b KQkq - 1 3'
        fen_parser = Chess::FENParser.new(fen)
        position = Chess::Position.from_fen_parser(fen_parser)
        described_class.new(position: position)
      end

      let(:source_d8) { Chess::Coord.from_s('d8') }
      let(:destination_h4) { Chess::Coord.from_s('h4') }
      let(:metadata_before) { {} }
      let(:metadata_after) do
        { previous_source: source_d8,
          previous_destination: destination_h4,
          checked_king: Chess::Coord.from_s('e1') }
      end

      example 'source d8 to destination h4 produces the expected position' do
        expect { game.play_turn(source_d8, destination_h4) }
          .to change { game.instance_variable_get(:@position).to_fen }
          .from('rnbqkbnr/pppp1ppp/8/8/2B1Pp2/8/PPPP2PP/RNBQK1NR b KQkq - 1 3')
          .to('rnb1kbnr/pppp1ppp/8/8/2B1Pp1q/8/PPPP2PP/RNBQK1NR w KQkq - 2 4')
      end

      example 'source d8 to destination h4 logs the expected metadata' do
        expect { game.play_turn(source_d8, destination_h4) }
          .to change { game.instance_variable_get(:@log).metadata }
          .from(metadata_before)
          .to(metadata_after)
      end
    end

    context 'when playing turn seven of the immortal game' do
      subject(:game) do
        fen = 'rnb1kbnr/pppp1ppp/8/8/2B1Pp1q/8/PPPP2PP/RNBQK1NR w KQkq - 2 4'
        fen_parser = Chess::FENParser.new(fen)
        position = Chess::Position.from_fen_parser(fen_parser)
        described_class.new(position: position)
      end

      example 'source e1 to destination f1 produces the expected position' do
        expect { game.play_turn(Chess::Coord.from_s('e1'), Chess::Coord.from_s('f1')) }
          .to change { game.instance_variable_get(:@position).to_fen }
          .from('rnb1kbnr/pppp1ppp/8/8/2B1Pp1q/8/PPPP2PP/RNBQK1NR w KQkq - 2 4')
          .to('rnb1kbnr/pppp1ppp/8/8/2B1Pp1q/8/PPPP2PP/RNBQ1KNR b kq - 3 4')
      end
    end

    context 'when moving a rook from its home' do
      subject(:game) do
        fen = 'rnbqkbnr/ppppppp1/8/7Q/4P3/8/PPPP1PPP/RNB1KBNR b KQkq - 0 2'
        fen_parser = Chess::FENParser.new(fen)
        position = Chess::Position.from_fen_parser(fen_parser)
        described_class.new(position: position)
      end

      example 'source h8 to destination h5 produces the expected position' do
        expect { game.play_turn(Chess::Coord.from_s('h8'), Chess::Coord.from_s('h5')) }
          .to change { game.instance_variable_get(:@position).to_fen }
          .from('rnbqkbnr/ppppppp1/8/7Q/4P3/8/PPPP1PPP/RNB1KBNR b KQkq - 0 2')
          .to('rnbqkbn1/ppppppp1/8/7r/4P3/8/PPPP1PPP/RNB1KBNR w KQq - 0 3')
      end
    end

    context 'when capturing a rook at its home' do
      subject(:game) do
        fen = 'rn1qkbnr/pbpppppp/1p6/8/8/6P1/PPPPPP1P/RNBQKBNR b KQkq - 3 3'
        fen_parser = Chess::FENParser.new(fen)
        position = Chess::Position.from_fen_parser(fen_parser)
        described_class.new(position: position)
      end

      example 'source b7 to destination h1 produces the expected position' do
        expect { game.play_turn(Chess::Coord.from_s('b7'), Chess::Coord.from_s('h1')) }
          .to change { game.instance_variable_get(:@position).to_fen }
          .from('rn1qkbnr/pbpppppp/1p6/8/8/6P1/PPPPPP1P/RNBQKBNR b KQkq - 3 3')
          .to('rn1qkbnr/p1pppppp/1p6/8/8/6P1/PPPPPP1P/RNBQKBNb w Qkq - 0 4')
      end
    end

    context 'when capturing a rook not at home' do
      subject(:game) do
        fen = 'Rnbqkbnr/2pppppp/1p6/4P3/3B4/pP1P2P1/2P2PBP/rN1QK1NR w Kk - 0 15'
        fen_parser = Chess::FENParser.new(fen)
        position = Chess::Position.from_fen_parser(fen_parser)
        described_class.new(position: position)
      end

      example 'source d4 to destination a1 produces the expected position' do
        expect { game.play_turn(Chess::Coord.from_s('d4'), Chess::Coord.from_s('a1')) }
          .to change { game.instance_variable_get(:@position).to_fen }
          .from('Rnbqkbnr/2pppppp/1p6/4P3/3B4/pP1P2P1/2P2PBP/rN1QK1NR w Kk - 0 15')
          .to('Rnbqkbnr/2pppppp/1p6/4P3/8/pP1P2P1/2P2PBP/BN1QK1NR b Kk - 0 15')
      end
    end

    context 'when moving a rook not at home' do
      subject(:game) do
        fen = 'Rnbqkbnr/1ppppppp/8/p3P3/P7/8/1PPP1PPP/rNBQKBNR b Kk - 10 8'
        fen_parser = Chess::FENParser.new(fen)
        position = Chess::Position.from_fen_parser(fen_parser)
        described_class.new(position: position)
      end

      example 'source a1 to destination a4 produces the expected position' do
        expect { game.play_turn(Chess::Coord.from_s('a1'), Chess::Coord.from_s('a4')) }
          .to change { game.instance_variable_get(:@position).to_fen }
          .from('Rnbqkbnr/1ppppppp/8/p3P3/P7/8/1PPP1PPP/rNBQKBNR b Kk - 10 8')
          .to('Rnbqkbnr/1ppppppp/8/p3P3/r7/8/1PPP1PPP/1NBQKBNR w Kk - 0 9')
      end
    end

    context 'when capturing en passant' do
      subject(:game) do
        fen = 'rnbqkbnr/pppp1ppp/8/8/3PpP2/8/PPP1P1PP/RNBQKBNR b KQkq f3 0 3'
        fen_parser = Chess::FENParser.new(fen)
        position = Chess::Position.from_fen_parser(fen_parser)
        described_class.new(position: position)
      end

      example 'source e4 to destination f3 produces the expected position' do
        expect { game.play_turn(Chess::Coord.from_s('e4'), Chess::Coord.from_s('f3')) }
          .to change { game.instance_variable_get(:@position).to_fen }
          .from('rnbqkbnr/pppp1ppp/8/8/3PpP2/8/PPP1P1PP/RNBQKBNR b KQkq f3 0 3')
          .to('rnbqkbnr/pppp1ppp/8/8/3P4/5p2/PPP1P1PP/RNBQKBNR w KQkq - 0 4')
      end
    end

    context 'when castling' do
      subject(:game) do
        fen = 'r3k2r/pbpp1ppp/np5n/2b1p1q1/2B1P1Q1/1P5N/PBPP1PPP/RN2K2R b KQkq - 3 8'
        fen_parser = Chess::FENParser.new(fen)
        position = Chess::Position.from_fen_parser(fen_parser)
        described_class.new(position: position)
      end

      example 'source e8 to destination c8 produces the expected position' do
        expect { game.play_turn(Chess::Coord.from_s('e8'), Chess::Coord.from_s('c8')) }
          .to change { game.instance_variable_get(:@position).to_fen }
          .from('r3k2r/pbpp1ppp/np5n/2b1p1q1/2B1P1Q1/1P5N/PBPP1PPP/RN2K2R b KQkq - 3 8')
          .to('2kr3r/pbpp1ppp/np5n/2b1p1q1/2B1P1Q1/1P5N/PBPP1PPP/RN2K2R w KQ - 4 9')
      end
    end

    # NOTE: This promotion test passes when running the entire suite, but fails
    # when attempting to filter for it by file or regex. Don't ask me why.
    context 'when promoting' do
      subject(:game) do
        fen = 'rnbqkbnr/pppppp1p/5P2/8/8/3P4/PPP1P1Pp/RNBQKBNR b KQkq - 0 5'
        fen_parser = Chess::FENParser.new(fen)
        position = Chess::Position.from_fen_parser(fen_parser)
        described_class.new(position: position)
      end

      let(:input) { StringIO.new('queen') }

      before do
        $stdin = input
        allow($stdout).to receive(:puts)
      end

      after { $stdin = STDIN }

      example 'source h2 to destination g1 produces the expected position' do
        expect { game.play_turn(Chess::Coord.from_s('h2'), Chess::Coord.from_s('g1')) }
          .to change { game.instance_variable_get(:@position).to_fen }
          .from('rnbqkbnr/pppppp1p/5P2/8/8/3P4/PPP1P1Pp/RNBQKBNR b KQkq - 0 5')
          .to('rnbqkbnr/pppppp1p/5P2/8/8/3P4/PPP1P1P1/RNBQKBqR w KQkq - 0 6')
      end
    end
  end

  describe '#check?' do
    subject(:game) { described_class.new }

    let(:position) { game.instance_variable_get(:@position) }

    before { allow(position).to receive(:check?) }

    specify 'position receives #check?' do
      game.check?
      expect(position).to have_received(:check?)
    end
  end

  describe '#checkmate?' do
    context 'when fool\'s mate' do
      subject(:game) do
        fen = 'rnb1kbnr/pppp1ppp/8/4p3/6Pq/5P2/PPPPP2P/RNBQKBNR w KQkq - 1 3'
        fen_parser = Chess::FENParser.new(fen)
        position = Chess::Position.from_fen_parser(fen_parser)
        described_class.new(position: position)
      end

      it 'returns true' do
        expect(game.checkmate?).to be(true)
      end
    end

    context 'when immortal game mate' do
      subject(:game) do
        fen = 'r1bk3r/p2pBpNp/n4n2/1p1NP2P/6P1/3P4/P1P1K3/q5b1 b - - 1 23'
        fen_parser = Chess::FENParser.new(fen)
        position = Chess::Position.from_fen_parser(fen_parser)
        described_class.new(position: position)
      end

      it 'returns true' do
        expect(game.checkmate?).to be(true)
      end
    end

    context 'when check without mate' do
      subject(:game) do
        fen = 'rnb1kbnr/pppp1ppp/8/8/2B1Pp1q/8/PPPP2PP/RNBQK1NR w KQkq - 2 4'
        fen_parser = Chess::FENParser.new(fen)
        position = Chess::Position.from_fen_parser(fen_parser)
        described_class.new(position: position)
      end

      it 'returns false' do
        expect(game.checkmate?).to be(false)
      end
    end

    context 'when stalemate' do
      subject(:game) do
        fen = '5bnr/4p1pq/4Qpkr/7p/7P/4P3/PPPP1PP1/RNB1KBNR b KQ - 2 10'
        fen_parser = Chess::FENParser.new(fen)
        position = Chess::Position.from_fen_parser(fen_parser)
        described_class.new(position: position)
      end

      it 'returns false' do
        expect(game.checkmate?).to be(false)
      end
    end

    context 'when the only legal move is en passant capture' do
      subject(:game) do
        fen = 'kb6/p7/5p2/2RPpp2/2RK4/2BPP3/6B1/8 w - e6 0 1'
        fen_parser = Chess::FENParser.new(fen)
        position = Chess::Position.from_fen_parser(fen_parser)
        described_class.new(position: position)
      end

      it 'returns false' do
        expect(game.checkmate?).to be(false)
      end
    end
  end

  describe '#stalemate?' do
    context 'when black is stalemated' do
      subject(:game) do
        fen = '5bnr/4p1pq/4Qpkr/7p/7P/4P3/PPPP1PP1/RNB1KBNR b KQ - 2 10'
        fen_parser = Chess::FENParser.new(fen)
        position = Chess::Position.from_fen_parser(fen_parser)
        described_class.new(position: position)
      end

      it 'returns true' do
        expect(game.stalemate?).to be(true)
      end
    end

    context 'when white is stalemated' do
      subject(:game) do
        fen = '8/6p1/5p2/5k1K/7P/8/8/8 w - - 0 66'
        fen_parser = Chess::FENParser.new(fen)
        position = Chess::Position.from_fen_parser(fen_parser)
        described_class.new(position: position)
      end

      it 'returns true' do
        expect(game.stalemate?).to be(true)
      end
    end

    context 'when check without mate' do
      subject(:game) do
        fen = 'rnb1kbnr/pppp1ppp/8/8/2B1Pp1q/8/PPPP2PP/RNBQK1NR w KQkq - 2 4'
        fen_parser = Chess::FENParser.new(fen)
        position = Chess::Position.from_fen_parser(fen_parser)
        described_class.new(position: position)
      end

      it 'returns false' do
        expect(game.stalemate?).to be(false)
      end
    end

    context 'when fool\'s mate' do
      subject(:game) do
        fen = 'rnb1kbnr/pppp1ppp/8/4p3/6Pq/5P2/PPPPP2P/RNBQKBNR w KQkq - 1 3'
        fen_parser = Chess::FENParser.new(fen)
        position = Chess::Position.from_fen_parser(fen_parser)
        described_class.new(position: position)
      end

      it 'returns false' do
        expect(game.stalemate?).to be(false)
      end
    end

    context 'when the only legal move is en passant capture' do
      subject(:game) do
        fen = 'kb6/p7/5p2/2RPpp2/2RK4/2BPP3/6B1/8 w - e6 0 1'
        fen_parser = Chess::FENParser.new(fen)
        position = Chess::Position.from_fen_parser(fen_parser)
        described_class.new(position: position)
      end

      it 'returns false' do
        expect(game.stalemate?).to be(false)
      end
    end
  end

  describe '#draw_by_fifty_move_rule?' do
    context 'when draw by fifty-move rule' do
      subject(:game) do
        fen = '8/7k/8/5KR1/1r3B2/8/8/8 b - - 100 121'
        fen_parser = Chess::FENParser.new(fen)
        position = Chess::Position.from_fen_parser(fen_parser)
        described_class.new(position: position)
      end

      it 'returns true' do
        expect(game.draw_by_fifty_move_rule?).to be(true)
      end
    end

    context 'when no draw by fifty-move rule' do
      subject(:game) do
        fen = '8/7k/8/5KR1/1r3B2/8/8/8 b - - 99 121'
        fen_parser = Chess::FENParser.new(fen)
        position = Chess::Position.from_fen_parser(fen_parser)
        described_class.new(position: position)
      end

      it 'returns false' do
        expect(game.draw_by_fifty_move_rule?).to be(false)
      end
    end
  end

  describe '#draw_by_threefold_repetition_rule?' do
    context 'when draw by threefold repetition rule' do
      subject(:game) do
        fen = '8/pp3p1k/2p2q1p/3r1P2/5R2/7P/P1P1QP2/7K b - - 0 1'
        fen_parser = Chess::FENParser.new(fen)
        position = Chess::Position.from_fen_parser(fen_parser)
        log = Chess::Log.new
        log.fen_history << '8/pp3p1k/2p2q1p/3r1P2/5R2/7P/P1P1QP2/7K b - - 0 1'
        log.fen_history << '8/pp3p1k/2p4p/3rqP2/5R2/7P/P1P1QP2/7K w - - 0 1'
        log.fen_history << '8/pp3p1k/2p4p/3rqP1Q/5R2/7P/P1P2P2/7K b - - 0 1'
        log.fen_history << '8/pp3p1k/2p2q1p/3r1P1Q/5R2/7P/P1P2P2/7K w - - 0 1'
        log.fen_history << '8/pp3p1k/2p2q1p/3r1P2/5R2/7P/P1P1QP2/7K b - - 0 1'
        log.fen_history << '8/pp3p1k/2p2q1p/4rP2/5R2/7P/P1P1QP2/7K w - - 0 1'
        log.fen_history << '8/pp3p1k/2p2q1p/4rP2/5R2/3Q3P/P1P2P2/7K b - - 0 1'
        log.fen_history << '8/pp3p1k/2p2q1p/3r1P2/5R2/3Q3P/P1P2P2/7K w - - 0 1'
        log.fen_history << '8/pp3p1k/2p2q1p/3r1P2/5R2/7P/P1P1QP2/7K b - - 0 1'
        described_class.new(position: position, log: log)
      end

      it 'returns true' do
        expect(game.draw_by_threefold_repetition_rule?).to be(true)
      end
    end

    context 'when no draw by threefold repetition rule' do
      subject(:game) do
        fen = '8/pp3p1k/2p2q1p/3r1P2/5R2/3Q3P/P1P2P2/7K w - - 0 1'
        fen_parser = Chess::FENParser.new(fen)
        position = Chess::Position.from_fen_parser(fen_parser)
        log = Chess::Log.new
        log.fen_history << '8/pp3p1k/2p2q1p/3r1P2/5R2/7P/P1P1QP2/7K b - - 0 1'
        log.fen_history << '8/pp3p1k/2p4p/3rqP2/5R2/7P/P1P1QP2/7K w - - 0 1'
        log.fen_history << '8/pp3p1k/2p4p/3rqP1Q/5R2/7P/P1P2P2/7K b - - 0 1'
        log.fen_history << '8/pp3p1k/2p2q1p/3r1P1Q/5R2/7P/P1P2P2/7K w - - 0 1'
        log.fen_history << '8/pp3p1k/2p2q1p/3r1P2/5R2/7P/P1P1QP2/7K b - - 0 1'
        log.fen_history << '8/pp3p1k/2p2q1p/4rP2/5R2/7P/P1P1QP2/7K w - - 0 1'
        log.fen_history << '8/pp3p1k/2p2q1p/4rP2/5R2/3Q3P/P1P2P2/7K b - - 0 1'
        log.fen_history << '8/pp3p1k/2p2q1p/3r1P2/5R2/3Q3P/P1P2P2/7K w - - 0 1'
        described_class.new(position: position, log: log)
      end

      it 'returns false' do
        expect(game.draw_by_threefold_repetition_rule?).to be(false)
      end
    end
  end

  describe '#over?' do
    context 'when checkmate' do
      subject(:game) do
        fen = 'rnb1kbnr/pppp1ppp/8/4p3/6Pq/5P2/PPPPP2P/RNBQKBNR w KQkq - 1 3'
        fen_parser = Chess::FENParser.new(fen)
        position = Chess::Position.from_fen_parser(fen_parser)
        described_class.new(position: position)
      end

      it 'returns true' do
        expect(game.over?).to be(true)
      end
    end

    context 'when stalemate' do
      subject(:game) do
        fen = '5bnr/4p1pq/4Qpkr/7p/7P/4P3/PPPP1PP1/RNB1KBNR b KQ - 2 10'
        fen_parser = Chess::FENParser.new(fen)
        position = Chess::Position.from_fen_parser(fen_parser)
        described_class.new(position: position)
      end

      it 'returns true' do
        expect(game.over?).to be(true)
      end
    end

    context 'when draw by fifty-move rule' do
      subject(:game) do
        fen = '8/7k/8/5KR1/1r3B2/8/8/8 b - - 100 121'
        fen_parser = Chess::FENParser.new(fen)
        position = Chess::Position.from_fen_parser(fen_parser)
        described_class.new(position: position)
      end

      it 'returns true' do
        expect(game.over?).to be(true)
      end
    end

    context 'when draw by threefold repetition rule' do
      subject(:game) do
        fen = '8/pp3p1k/2p2q1p/3r1P2/5R2/7P/P1P1QP2/7K b - - 0 1'
        fen_parser = Chess::FENParser.new(fen)
        position = Chess::Position.from_fen_parser(fen_parser)
        log = Chess::Log.new
        log.fen_history << '8/pp3p1k/2p2q1p/3r1P2/5R2/7P/P1P1QP2/7K b - - 0 1'
        log.fen_history << '8/pp3p1k/2p4p/3rqP2/5R2/7P/P1P1QP2/7K w - - 0 1'
        log.fen_history << '8/pp3p1k/2p4p/3rqP1Q/5R2/7P/P1P2P2/7K b - - 0 1'
        log.fen_history << '8/pp3p1k/2p2q1p/3r1P1Q/5R2/7P/P1P2P2/7K w - - 0 1'
        log.fen_history << '8/pp3p1k/2p2q1p/3r1P2/5R2/7P/P1P1QP2/7K b - - 0 1'
        log.fen_history << '8/pp3p1k/2p2q1p/4rP2/5R2/7P/P1P1QP2/7K w - - 0 1'
        log.fen_history << '8/pp3p1k/2p2q1p/4rP2/5R2/3Q3P/P1P2P2/7K b - - 0 1'
        log.fen_history << '8/pp3p1k/2p2q1p/3r1P2/5R2/3Q3P/P1P2P2/7K w - - 0 1'
        log.fen_history << '8/pp3p1k/2p2q1p/3r1P2/5R2/7P/P1P1QP2/7K b - - 0 1'
        described_class.new(position: position, log: log)
      end

      it 'returns true' do
        expect(game.over?).to be(true)
      end
    end

    context 'when not over' do
      subject(:game) do
        fen = Chess::DEFAULT_FEN
        fen_parser = Chess::FENParser.new(fen)
        position = Chess::Position.from_fen_parser(fen_parser)
        described_class.new(position: position)
      end

      it 'returns false' do
        expect(game.over?).to be(false)
      end
    end
  end

  describe '#to_active_player' do
    context 'when white is active' do
      subject(:game) { described_class.new }

      it 'returns the player playing white' do
        expect(game.to_active_player).to be(game.player_white)
      end
    end

    context 'when black is active' do
      subject(:game) do
        fen = 'rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq e3 0 1'
        fen_parser = Chess::FENParser.new(fen)
        position = Chess::Position.from_fen_parser(fen_parser)
        described_class.new(position: position)
      end

      it 'returns the player playing black' do
        expect(game.to_active_player).to be(game.player_black)
      end
    end
  end

  describe '#to_inactive_player' do
    context 'when white is active' do
      subject(:game) { described_class.new }

      it 'returns the player playing black' do
        expect(game.to_inactive_player).to be(game.player_black)
      end
    end

    context 'when black is active' do
      subject(:game) do
        fen = 'rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq e3 0 1'
        fen_parser = Chess::FENParser.new(fen)
        position = Chess::Position.from_fen_parser(fen_parser)
        described_class.new(position: position)
      end

      it 'returns the player playing white' do
        expect(game.to_inactive_player).to be(game.player_white)
      end
    end
  end

  describe '#display_board' do
    subject(:game) { described_class.new }

    let(:board) { game.instance_variable_get(:@position).board }
    let(:metadata) { game.instance_variable_get(:@log).metadata }
    let(:display) { game.instance_variable_get(:@display) }

    before do
      allow(display).to receive(:render_board).with(board.to_ranks, metadata)
      allow($stdout).to receive(:puts)
    end

    specify 'display receives #render_board with expected args' do
      game.display_board
      expect(display).to have_received(:render_board).with(board.to_ranks, metadata)
    end
  end

  describe '#select_source' do
    context 'when selecting source c4 mid game' do
      subject(:game) do
        fen = 'rnb1kbnr/p1pp1ppp/8/1p6/2B1Pp1q/8/PPPP2PP/RNBQ1KNR w kq b6 0 5'
        fen_parser = Chess::FENParser.new(fen)
        position = Chess::Position.from_fen_parser(fen_parser)
        described_class.new(position: position)
      end

      let(:source_c4) { Chess::Coord.from_s('c4') }
      let(:metadata) { game.instance_variable_get(:@log).metadata }

      it 'logs the current source' do
        expect { game.select_source(source_c4) }
          .to change { metadata[:current_source] }
          .from(nil).to(source_c4)
      end

      it 'logs the currently controlled destinations' do
        expect { game.select_source(source_c4) }
          .to change { metadata[:currently_controlled] }
          .from(nil)
          .to match_array(%w[b3 d3 e2 d5 e6].map { |coord_s| Chess::Coord.from_s(coord_s) })
      end

      it 'logs the currently attacked destinations' do
        expect { game.select_source(source_c4) }
          .to change { metadata[:currently_attacked] }
          .from(nil)
          .to match_array(%w[b5 f7].map { |coord_s| Chess::Coord.from_s(coord_s) })
      end
    end
  end

  describe '#deselect_source' do
    context 'with a source selected' do
      subject(:game) do
        fen = 'rnb1kbnr/p1pp1ppp/8/1p6/2B1Pp1q/8/PPPP2PP/RNBQ1KNR w kq b6 0 5'
        fen_parser = Chess::FENParser.new(fen)
        position = Chess::Position.from_fen_parser(fen_parser)
        described_class.new(position: position)
      end

      let(:source_c4) { Chess::Coord.from_s('c4') }
      let(:metadata) { game.instance_variable_get(:@log).metadata }

      before { game.select_source(source_c4) }

      it 'logs the current source as nil' do
        expect { game.deselect_source }
          .to change { metadata[:current_source] }
          .to(nil)
      end

      it 'logs the currently controlled destinations as nil' do
        expect { game.deselect_source }
          .to change { metadata[:currently_controlled] }
          .to(nil)
      end

      it 'logs the currently attacked destinations as nil' do
        expect { game.deselect_source }
          .to change { metadata[:currently_attacked] }
          .to(nil)
      end
    end
  end
end
