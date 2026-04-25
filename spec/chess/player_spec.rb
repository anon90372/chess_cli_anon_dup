# frozen_string_literal: true

describe Chess::Player do
  describe '#white?' do
    context 'when white' do
      subject(:player_white) { described_class.new('Player', :white) }

      it 'returns true' do
        expect(player_white.white?).to be(true)
      end
    end

    context 'when black' do
      subject(:player_black) { described_class.new('Player', :black) }

      it 'returns false' do
        expect(player_black.white?).to be(false)
      end
    end
  end

  describe '#black?' do
    context 'when black' do
      subject(:player_black) { described_class.new('Player', :black) }

      it 'returns true' do
        expect(player_black.black?).to be(true)
      end
    end

    context 'when white' do
      subject(:player_white) { described_class.new('Player', :white) }

      it 'returns false' do
        expect(player_white.black?).to be(false)
      end
    end
  end

  describe '#to_s' do
    subject(:player) { described_class.new('Player', :white) }

    it 'returns a string describing the state' do
      expect(player.to_s).to eq('Player(white)')
    end
  end
end
