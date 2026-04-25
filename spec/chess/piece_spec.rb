# frozen_string_literal: true

describe Chess::Piece do
  describe '#white?' do
    context 'when white' do
      subject(:piece_white) { described_class.new(:white) }

      it 'returns true' do
        expect(piece_white.white?).to be(true)
      end
    end

    context 'when black' do
      subject(:piece_black) { described_class.new(:black) }

      it 'returns false' do
        expect(piece_black.white?).to be(false)
      end
    end
  end

  describe '#black?' do
    context 'when black' do
      subject(:piece_black) { described_class.new(:black) }

      it 'returns true' do
        expect(piece_black.black?).to be(true)
      end
    end

    context 'when white' do
      subject(:piece_white) { described_class.new(:white) }

      it 'returns false' do
        expect(piece_white.black?).to be(false)
      end
    end
  end

  describe '#friendly_with?' do
    context 'with a white piece' do
      subject(:piece_white) { described_class.new(:white) }

      specify 'a friendly piece returns true' do
        friendly = described_class.new(:white)
        expect(piece_white.friendly_with?(friendly)).to be(true)
      end

      specify 'an enemy piece returns false' do
        enemy = described_class.new(:black)
        expect(piece_white.friendly_with?(enemy)).to be(false)
      end
    end

    context 'with a black piece' do
      subject(:piece_black) { described_class.new(:black) }

      specify 'a friendly piece returns true' do
        friendly = described_class.new(:black)
        expect(piece_black.friendly_with?(friendly)).to be(true)
      end

      specify 'an enemy piece returns false' do
        enemy = described_class.new(:white)
        expect(piece_black.friendly_with?(enemy)).to be(false)
      end
    end
  end

  describe '#enemy_to?' do
    context 'with a white piece' do
      subject(:piece_white) { described_class.new(:white) }

      specify 'an enemy piece returns true' do
        enemy = described_class.new(:black)
        expect(piece_white.enemy_to?(enemy)).to be(true)
      end

      specify 'a friendly piece returns false' do
        friendly = described_class.new(:white)
        expect(piece_white.enemy_to?(friendly)).to be(false)
      end
    end

    context 'with a black piece' do
      subject(:piece_black) { described_class.new(:black) }

      specify 'an enemy piece returns true' do
        enemy = described_class.new(:white)
        expect(piece_black.enemy_to?(enemy)).to be(true)
      end

      specify 'a friendly piece returns false' do
        friendly = described_class.new(:black)
        expect(piece_black.enemy_to?(friendly)).to be(false)
      end
    end
  end

  describe '#to_s' do
    subject(:piece) { described_class.new(:white) }

    it 'returns a string describing the state' do
      expect(piece.to_s).to eq('The Piece is white.')
    end
  end
end
