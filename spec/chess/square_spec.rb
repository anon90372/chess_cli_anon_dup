# frozen_string_literal: true

describe Chess::Square do
  describe '#occupied?' do
    context 'when occupied' do
      subject(:square_occupied) { described_class.new(piece) }

      let(:piece) { double('Piece') }

      it 'returns true' do
        expect(square_occupied.occupied?).to be(true)
      end
    end

    context 'when vacant' do
      subject(:square_vacant) { described_class.new }

      it 'returns false' do
        expect(square_vacant.occupied?).to be(false)
      end
    end
  end

  describe '#vacant?' do
    context 'when vacant' do
      subject(:square_vacant) { described_class.new }

      it 'returns true' do
        expect(square_vacant.vacant?).to be(true)
      end
    end

    context 'when occupied' do
      subject(:square_occupied) { described_class.new(piece) }

      let(:piece) { double('Piece') }

      it 'returns false' do
        expect(square_occupied.vacant?).to be(false)
      end
    end
  end

  describe '#fill' do
    subject(:square) { described_class.new }

    let(:piece) { double('Piece') }

    it 'updates the occupant' do
      expect { square.fill(piece) }.to change \
        { square.instance_variable_get(:@occupant) }.from(nil).to(piece)
    end
  end

  describe '#empty' do
    subject(:square) { described_class.new(piece) }

    let(:piece) { double('Piece') }

    it 'removes the occupant' do
      expect { square.empty }.to change \
        { square.instance_variable_get(:@occupant) }.from(piece).to(nil)
    end
  end

  describe '#to_s' do
    context 'when occupied' do
      subject(:square_occupied) { described_class.new(piece) }

      let(:piece) { Chess::Piece.new(:white) }

      it 'returns a string describing the state' do
        expect(square_occupied.to_s).to eq('The Square is occupied by a white Piece.')
      end
    end

    context 'when vacant' do
      subject(:square_vacant) { described_class.new }

      it 'returns a string describing the state' do
        expect(square_vacant.to_s).to eq('The Square is vacant.')
      end
    end
  end
end
