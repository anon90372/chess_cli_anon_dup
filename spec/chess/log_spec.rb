# frozen_string_literal: true

describe Chess::Log do
  describe '#threefold_repetition_rule_satisfied?' do
    subject(:log) { described_class.new }

    context 'when there are three identical records regardless of order' do
      before do
        log.fen_history << '8/pp3p1k/2p2q1p/3r1P2/5R2/7P/P1P1QP2/7K b - - 0 1'
        log.fen_history << '8/pp3p1k/2p4p/3rqP2/5R2/7P/P1P1QP2/7K w - - 0 1'
        log.fen_history << '8/pp3p1k/2p4p/3rqP1Q/5R2/7P/P1P2P2/7K b - - 0 1'
        log.fen_history << '8/pp3p1k/2p2q1p/3r1P1Q/5R2/7P/P1P2P2/7K w - - 0 1'
        log.fen_history << '8/pp3p1k/2p2q1p/3r1P2/5R2/7P/P1P1QP2/7K b - - 0 1'
        log.fen_history << '8/pp3p1k/2p2q1p/4rP2/5R2/7P/P1P1QP2/7K w - - 0 1'
        log.fen_history << '8/pp3p1k/2p2q1p/4rP2/5R2/3Q3P/P1P2P2/7K b - - 0 1'
        log.fen_history << '8/pp3p1k/2p2q1p/3r1P2/5R2/3Q3P/P1P2P2/7K w - - 0 1'
        log.fen_history << '8/pp3p1k/2p2q1p/3r1P2/5R2/7P/P1P1QP2/7K b - - 0 1'
      end

      it 'returns true' do
        result = log.threefold_repetition_rule_satisfied?
        expect(result).to be(true)
      end
    end

    context 'when there are no three identical records' do
      before do
        log.fen_history << '8/pp3p1k/2p2q1p/3r1P2/5R2/7P/P1P1QP2/7K b - - 0 1'
        log.fen_history << '8/pp3p1k/2p4p/3rqP2/5R2/7P/P1P1QP2/7K w - - 0 1'
        log.fen_history << '8/pp3p1k/2p4p/3rqP1Q/5R2/7P/P1P2P2/7K b - - 0 1'
        log.fen_history << '8/pp3p1k/2p2q1p/3r1P1Q/5R2/7P/P1P2P2/7K w - - 0 1'
        log.fen_history << '8/pp3p1k/2p2q1p/3r1P2/5R2/7P/P1P1QP2/7K b - - 0 1'
        log.fen_history << '8/pp3p1k/2p2q1p/4rP2/5R2/7P/P1P1QP2/7K w - - 0 1'
        log.fen_history << '8/pp3p1k/2p2q1p/4rP2/5R2/3Q3P/P1P2P2/7K b - - 0 1'
        log.fen_history << '8/pp3p1k/2p2q1p/3r1P2/5R2/3Q3P/P1P2P2/7K w - - 0 1'
      end

      it 'returns false' do
        result = log.threefold_repetition_rule_satisfied?
        expect(result).to be(false)
      end
    end
  end
end
