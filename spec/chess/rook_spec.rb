# frozen_string_literal: true

describe Chess::Rook do
  describe '#to_adjacent_movement_coords' do
    subject(:rook) { described_class.new(:white) }

    context 'when passed Coord e4' do
      let(:coord_e4) { Chess::Coord.new('e', 4) }
      let(:expected) do
        {
          north: %w[e5 e6 e7 e8],
          east: %w[f4 g4 h4],
          south: %w[e3 e2 e1],
          west: %w[d4 c4 b4 a4]
        }.transform_values do |coord_a|
          coord_a.map { |coord_s| Chess::Coord.from_s(coord_s) }
        end
      end

      it 'returns a hash of adjacencies per direction' do
        result = rook.to_adjacent_movement_coords(coord_e4)
        expect(result).to eq(expected)
      end
    end

    context 'when passed Coord a8' do
      let(:coord_a8) { Chess::Coord.new('a', 8) }
      let(:expected) do
        {
          east: %w[b8 c8 d8 e8 f8 g8 h8],
          south: %w[a7 a6 a5 a4 a3 a2 a1]
        }.transform_values do |coord_a|
          coord_a.map { |coord_s| Chess::Coord.from_s(coord_s) }
        end
      end

      it 'returns a hash of adjacencies per direction' do
        result = rook.to_adjacent_movement_coords(coord_a8)
        expect(result).to eq(expected)
      end
    end
  end

  describe '#to_adjacent_capture_coords' do
    subject(:rook) { described_class.new(:white) }

    let(:coord) { double('Coord') }

    # rubocop: disable RSpec/SubjectStub
    it 'sends the #to_adjacent_movement_coords message to self with the passed Coord' do
      allow(rook).to receive(:to_adjacent_movement_coords).with(coord)
      rook.to_adjacent_capture_coords(coord)
      expect(rook).to have_received(:to_adjacent_movement_coords).with(coord)
    end
    # rubocop: enable all
  end
end
