# frozen_string_literal: true

describe Chess::Pawn do
  describe '#to_adjacent_movement_coords' do
    context 'when white and passed Coord e2' do
      subject(:pawn_white) { described_class.new(:white) }

      let(:coord_e2) { Chess::Coord.new('e', 2) }
      let(:expected) do
        { north: %w[e3 e4] }.transform_values do |coord_a|
          coord_a.map { |coord_s| Chess::Coord.from_s(coord_s) }
        end
      end

      it 'returns a hash of adjacencies per direction' do
        result = pawn_white.to_adjacent_movement_coords(coord_e2)
        expect(result).to eq(expected)
      end
    end

    context 'when white and passed Coord e6' do
      subject(:pawn_white) { described_class.new(:white) }

      let(:coord_e6) { Chess::Coord.new('e', 6) }
      let(:expected) do
        { north: %w[e7] }.transform_values do |coord_a|
          coord_a.map { |coord_s| Chess::Coord.from_s(coord_s) }
        end
      end

      it 'returns a hash of adjacencies per direction' do
        result = pawn_white.to_adjacent_movement_coords(coord_e6)
        expect(result).to eq(expected)
      end
    end

    context 'when white and passed Coord e7' do
      subject(:pawn_white) { described_class.new(:white) }

      let(:coord_e7) { Chess::Coord.new('e', 7) }
      let(:expected) do
        { north: %w[e8] }.transform_values do |coord_a|
          coord_a.map { |coord_s| Chess::Coord.from_s(coord_s) }
        end
      end

      it 'returns a hash of adjacencies per direction' do
        result = pawn_white.to_adjacent_movement_coords(coord_e7)
        expect(result).to eq(expected)
      end
    end

    context 'when white and passed Coord e8' do
      subject(:pawn_white) { described_class.new(:white) }

      let(:coord_e8) { Chess::Coord.new('e', 8) }

      it 'returns an empty hash' do
        result = pawn_white.to_adjacent_movement_coords(coord_e8)
        expect(result).to be_a(Hash).and be_empty
      end
    end

    context 'when black and passed Coord e7' do
      subject(:pawn_black) { described_class.new(:black) }

      let(:coord_e7) { Chess::Coord.new('e', 7) }
      let(:expected) do
        { south: %w[e6 e5] }.transform_values do |coord_a|
          coord_a.map { |coord_s| Chess::Coord.from_s(coord_s) }
        end
      end

      it 'returns a hash of adjacencies per direction' do
        result = pawn_black.to_adjacent_movement_coords(coord_e7)
        expect(result).to eq(expected)
      end
    end

    context 'when black and passed Coord e3' do
      subject(:pawn_black) { described_class.new(:black) }

      let(:coord_e3) { Chess::Coord.new('e', 3) }
      let(:expected) do
        { south: %w[e2] }.transform_values do |coord_a|
          coord_a.map { |coord_s| Chess::Coord.from_s(coord_s) }
        end
      end

      it 'returns a hash of adjacencies per direction' do
        result = pawn_black.to_adjacent_movement_coords(coord_e3)
        expect(result).to eq(expected)
      end
    end

    context 'when black and passed Coord e2' do
      subject(:pawn_black) { described_class.new(:black) }

      let(:coord_e2) { Chess::Coord.new('e', 2) }
      let(:expected) do
        { south: %w[e1] }.transform_values do |coord_a|
          coord_a.map { |coord_s| Chess::Coord.from_s(coord_s) }
        end
      end

      it 'returns a hash of adjacencies per direction' do
        result = pawn_black.to_adjacent_movement_coords(coord_e2)
        expect(result).to eq(expected)
      end
    end

    context 'when black and passed Coord e1' do
      subject(:pawn_black) { described_class.new(:black) }

      let(:coord_e1) { Chess::Coord.new('e', 1) }

      it 'returns an empty hash' do
        result = pawn_black.to_adjacent_movement_coords(coord_e1)
        expect(result).to be_a(Hash).and be_empty
      end
    end
  end

  describe '#to_adjacent_capture_coords' do
    context 'when white and passed Coord e4' do
      subject(:pawn_white) { described_class.new(:white) }

      let(:coord_e4) { Chess::Coord.new('e', 4) }
      let(:expected) do
        {
          north_west: %w[d5],
          north_east: %w[f5]
        }.transform_values do |coord_a|
          coord_a.map { |coord_s| Chess::Coord.from_s(coord_s) }
        end
      end

      it 'returns a hash of adjacencies per direction' do
        result = pawn_white.to_adjacent_capture_coords(coord_e4)
        expect(result).to eq(expected)
      end
    end

    context 'when white and passed Coord a4' do
      subject(:pawn_white) { described_class.new(:white) }

      let(:coord_a4) { Chess::Coord.new('a', 4) }
      let(:expected) do
        { north_east: %w[b5] }.transform_values do |coord_a|
          coord_a.map { |coord_s| Chess::Coord.from_s(coord_s) }
        end
      end

      it 'returns a hash of adjacencies per direction' do
        result = pawn_white.to_adjacent_capture_coords(coord_a4)
        expect(result).to eq(expected)
      end
    end

    context 'when white and passed Coord h4' do
      subject(:pawn_white) { described_class.new(:white) }

      let(:coord_h4) { Chess::Coord.new('h', 4) }
      let(:expected) do
        { north_west: %w[g5] }.transform_values do |coord_a|
          coord_a.map { |coord_s| Chess::Coord.from_s(coord_s) }
        end
      end

      it 'returns a hash of adjacencies per direction' do
        result = pawn_white.to_adjacent_capture_coords(coord_h4)
        expect(result).to eq(expected)
      end
    end

    context 'when white and passed Coord e8' do
      subject(:pawn_white) { described_class.new(:white) }

      let(:coord_e8) { Chess::Coord.new('e', 8) }

      it 'returns an empty hash' do
        result = pawn_white.to_adjacent_capture_coords(coord_e8)
        expect(result).to be_a(Hash).and be_empty
      end
    end

    context 'when black and passed Coord e5' do
      subject(:pawn_black) { described_class.new(:black) }

      let(:coord_e5) { Chess::Coord.new('e', 5) }
      let(:expected) do
        {
          south_west: %w[d4],
          south_east: %w[f4]
        }.transform_values do |coord_a|
          coord_a.map { |coord_s| Chess::Coord.from_s(coord_s) }
        end
      end

      it 'returns a hash of adjacencies per direction' do
        result = pawn_black.to_adjacent_capture_coords(coord_e5)
        expect(result).to eq(expected)
      end
    end

    context 'when black and passed Coord a5' do
      subject(:pawn_black) { described_class.new(:black) }

      let(:coord_a5) { Chess::Coord.new('a', 5) }
      let(:expected) do
        { south_east: %w[b4] }.transform_values do |coord_a|
          coord_a.map { |coord_s| Chess::Coord.from_s(coord_s) }
        end
      end

      it 'returns a hash of adjacencies per direction' do
        result = pawn_black.to_adjacent_capture_coords(coord_a5)
        expect(result).to eq(expected)
      end
    end

    context 'when black and passed Coord h5' do
      subject(:pawn_black) { described_class.new(:black) }

      let(:coord_h5) { Chess::Coord.new('h', 5) }
      let(:expected) do
        { south_west: %w[g4] }.transform_values do |coord_a|
          coord_a.map { |coord_s| Chess::Coord.from_s(coord_s) }
        end
      end

      it 'returns a hash of adjacencies per direction' do
        result = pawn_black.to_adjacent_capture_coords(coord_h5)
        expect(result).to eq(expected)
      end
    end

    context 'when black and passed Coord e1' do
      subject(:pawn_black) { described_class.new(:black) }

      let(:coord_e1) { Chess::Coord.new('e', 1) }

      it 'returns an empty hash' do
        result = pawn_black.to_adjacent_capture_coords(coord_e1)
        expect(result).to be_a(Hash).and be_empty
      end
    end
  end

  describe '#eligible_for_promotion?' do
    context 'when white' do
      subject(:pawn_white) { described_class.new(:white) }

      it 'returns true if passed any Coord with a rank of 8' do
        result = pawn_white.eligible_for_promotion?(Chess::Coord.from_s('e8'))
        expect(result).to be(true)
      end

      it 'returns false if passed any Coord with a rank other than 8' do
        result = pawn_white.eligible_for_promotion?(Chess::Coord.from_s('e7'))
        expect(result).to be(false)
      end
    end

    context 'when black' do
      subject(:pawn_black) { described_class.new(:black) }

      it 'returns true if passed any Coord with a rank of 1' do
        result = pawn_black.eligible_for_promotion?(Chess::Coord.from_s('e1'))
        expect(result).to be(true)
      end

      it 'returns false if passed any Coord with a rank other than 1' do
        result = pawn_black.eligible_for_promotion?(Chess::Coord.from_s('e2'))
        expect(result).to be(false)
      end
    end
  end

  describe '#to_potential_en_passant_capture_coords' do
    context 'when white and with the correct rank to capture en passant' do
      subject(:pawn_white) { described_class.new(:white) }

      let(:coord_e5) { Chess::Coord.from_s('e5') }

      it 'returns an array of potential en passant capture coords' do
        expect(pawn_white.to_potential_en_passant_capture_coords(coord_e5))
          .to match_array(%w[d6 f6].map { |coord_s| Chess::Coord.from_s(coord_s) })
      end
    end

    context 'when black and with the correct rank to capture en passant' do
      subject(:pawn_black) { described_class.new(:black) }

      let(:coord_e4) { Chess::Coord.from_s('e4') }

      it 'returns an array of potential en passant capture coords' do
        expect(pawn_black.to_potential_en_passant_capture_coords(coord_e4))
          .to match_array(%w[d3 f3].map { |coord_s| Chess::Coord.from_s(coord_s) })
      end
    end

    context 'when white and with an incorrect rank to capture en passant' do
      subject(:pawn_white) { described_class.new(:white) }

      let(:coord_e4) { Chess::Coord.from_s('e4') }

      it 'returns an empty array' do
        expect(pawn_white.to_potential_en_passant_capture_coords(coord_e4))
          .to be_an(Array).and be_empty
      end
    end

    context 'when black and with an incorrect rank to capture en passant' do
      subject(:pawn_black) { described_class.new(:black) }

      let(:coord_e5) { Chess::Coord.from_s('e5') }

      it 'returns an empty array' do
        expect(pawn_black.to_potential_en_passant_capture_coords(coord_e5))
          .to be_an(Array).and be_empty
      end
    end
  end
end
