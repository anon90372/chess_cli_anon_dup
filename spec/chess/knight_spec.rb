# frozen_string_literal: true

describe Chess::Knight do
  describe '#to_adjacent_movement_coords' do
    subject(:knight) { described_class.new(:white) }

    context 'when passed Coord e4' do
      let(:coord_e4) { Chess::Coord.new('e', 4) }
      let(:expected) do
        {
          north_east_left: %w[f6],
          north_east_right: %w[g5],
          south_east_left: %w[f2],
          south_east_right: %w[g3],
          south_west_left: %w[c3],
          south_west_right: %w[d2],
          north_west_left: %w[c5],
          north_west_right: %w[d6]
        }.transform_values do |coord_a|
          coord_a.map { |coord_s| Chess::Coord.from_s(coord_s) }
        end
      end

      it 'returns a hash of adjacencies per direction' do
        result = knight.to_adjacent_movement_coords(coord_e4)
        expect(result).to eq(expected)
      end
    end

    context 'when passed Coord a8' do
      let(:coord_a8) { Chess::Coord.new('a', 8) }
      let(:expected) do
        {
          south_east_left: %w[b6],
          south_east_right: %w[c7]
        }.transform_values do |coord_a|
          coord_a.map { |coord_s| Chess::Coord.from_s(coord_s) }
        end
      end

      it 'returns a hash of adjacencies per direction' do
        result = knight.to_adjacent_movement_coords(coord_a8)
        expect(result).to eq(expected)
      end
    end
  end

  describe '#to_adjacent_capture_coords' do
    subject(:knight) { described_class.new(:white) }

    let(:coord) { double('Coord') }

    # rubocop: disable RSpec/SubjectStub
    it 'sends the #to_adjacent_movement_coords message to self with the passed Coord' do
      allow(knight).to receive(:to_adjacent_movement_coords).with(coord)
      knight.to_adjacent_capture_coords(coord)
      expect(knight).to have_received(:to_adjacent_movement_coords).with(coord)
    end
    # rubocop: enable all
  end
end
