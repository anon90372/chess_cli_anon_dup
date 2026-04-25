# frozen_string_literal: true

describe Chess::King do
  describe '#to_adjacent_movement_coords' do
    subject(:king) { described_class.new(:white) }

    context 'when passed Coord e4' do
      let(:coord_e4) { Chess::Coord.new('e', 4) }
      let(:expected) do
        {
          north: %w[e5],
          east: %w[f4],
          south: %w[e3],
          west: %w[d4],
          north_east: %w[f5],
          south_east: %w[f3],
          south_west: %w[d3],
          north_west: %w[d5]
        }.transform_values do |coord_a|
          coord_a.map { |coord_s| Chess::Coord.from_s(coord_s) }
        end
      end

      it 'returns a hash of adjacencies per direction' do
        result = king.to_adjacent_movement_coords(coord_e4)
        expect(result).to eq(expected)
      end
    end

    context 'when passed Coord a8' do
      let(:coord_a8) { Chess::Coord.new('a', 8) }
      let(:expected) do
        {
          east: %w[b8],
          south: %w[a7],
          south_east: %w[b7]
        }.transform_values do |coord_a|
          coord_a.map { |coord_s| Chess::Coord.from_s(coord_s) }
        end
      end

      it 'returns a hash of adjacencies per direction' do
        result = king.to_adjacent_movement_coords(coord_a8)
        expect(result).to eq(expected)
      end
    end
  end

  describe '#to_adjacent_capture_coords' do
    subject(:king) { described_class.new(:white) }

    let(:coord) { double('Coord') }

    # rubocop: disable RSpec/SubjectStub
    it 'sends the #to_adjacent_movement_coords message to self with the passed Coord' do
      allow(king).to receive(:to_adjacent_movement_coords).with(coord)
      king.to_adjacent_capture_coords(coord)
      expect(king).to have_received(:to_adjacent_movement_coords).with(coord)
    end
    # rubocop: enable all
  end
end
