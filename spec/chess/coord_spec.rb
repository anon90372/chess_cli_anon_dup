# frozen_string_literal: true

describe Chess::Coord do
  describe '::from_s' do
    context 'when passed coordinates a8 as a string' do
      subject { described_class }

      let(:coord_s_a8) { 'a8' }

      it 'returns a Coord with the expected file coordinate' do
        result = described_class.from_s(coord_s_a8)
        file = result.instance_variable_get(:@file)
        expect(file).to eq('a')
      end

      it 'returns a Coord with the expected rank coordinate' do
        result = described_class.from_s(coord_s_a8)
        rank = result.instance_variable_get(:@rank)
        expect(rank).to eq(8)
      end
    end
  end

  describe '#==' do
    subject(:coord_a8) { described_class.new('a', 8) }

    context 'when other is a different Coord with identical state' do
      let(:other_coord_a8) { described_class.new('a', 8) }

      it 'returns true' do
        result = coord_a8 == other_coord_a8
        expect(result).to be(true)
      end
    end

    context 'when other is a different Coord with different state' do
      let(:coord_b7) { described_class.new('b', 7) }

      it 'returns false' do
        result = coord_a8 == coord_b7
        expect(result).to be(false)
      end
    end
  end

  describe '#to_adjacency' do
    subject(:coord_a8) { described_class.new('a', 8) }

    context 'when the adjacency would remain in bounds' do
      let(:file_adjustment) { 1 }
      let(:rank_adjustment) { -1 }

      # rubocop: disable RSpec/MultipleExpectations
      it 'returns a new Coord with the adjusted file coordinate' do
        result = coord_a8.to_adjacency(file_adjustment, rank_adjustment)
        file = result.instance_variable_get(:@file)
        expect(result).not_to be(coord_a8)
        expect(file).to eq('b')
      end

      it 'returns a new Coord with the adjusted rank coordinate' do
        result = coord_a8.to_adjacency(file_adjustment, rank_adjustment)
        rank = result.instance_variable_get(:@rank)
        expect(result).not_to be(coord_a8)
        expect(rank).to eq(7)
      end
      # rubocop: enable all
    end

    context 'when the adjacency would fall out of bounds' do
      it 'returns nil' do
        result = coord_a8.to_adjacency(-1, 1)
        expect(result).to be_nil
      end
    end
  end

  describe '#to_northern_adjacencies' do
    context 'when testing with Coord a1' do
      subject(:coord_a1) { described_class.new('a', 1) }

      let(:expected) do
        %w[a2 a3 a4 a5 a6 a7 a8].map do |coord_s|
          described_class.from_s(coord_s)
        end
      end

      it 'returns an array of northern adjacencies' do
        result = coord_a1.to_northern_adjacencies
        expect(result).to eq(expected)
      end
    end

    context 'when testing with Coord a8' do
      subject(:coord_a8) { described_class.new('a', 8) }

      it 'returns an empty array' do
        result = coord_a8.to_northern_adjacencies
        expect(result).to be_an(Array).and be_empty
      end
    end
  end

  describe '#to_eastern_adjacencies' do
    context 'when testing with Coord a8' do
      subject(:coord_a8) { described_class.new('a', 8) }

      let(:expected) do
        %w[b8 c8 d8 e8 f8 g8 h8].map do |coord_s|
          described_class.from_s(coord_s)
        end
      end

      it 'returns an array of eastern adjacencies' do
        result = coord_a8.to_eastern_adjacencies
        expect(result).to eq(expected)
      end
    end

    context 'when testing with Coord h8' do
      subject(:coord_h8) { described_class.new('h', 8) }

      it 'returns an empty array' do
        result = coord_h8.to_eastern_adjacencies
        expect(result).to be_an(Array).and be_empty
      end
    end
  end

  describe '#to_southern_adjacencies' do
    context 'when testing with Coord a8' do
      subject(:coord_a8) { described_class.new('a', 8) }

      let(:expected) do
        %w[a7 a6 a5 a4 a3 a2 a1].map do |coord_s|
          described_class.from_s(coord_s)
        end
      end

      it 'returns an array of southern adjacencies' do
        result = coord_a8.to_southern_adjacencies
        expect(result).to eq(expected)
      end
    end

    context 'when testing with Coord a1' do
      subject(:coord_a1) { described_class.new('a', 1) }

      it 'returns an empty array' do
        result = coord_a1.to_southern_adjacencies
        expect(result).to be_an(Array).and be_empty
      end
    end
  end

  describe '#to_western_adjacencies' do
    context 'when testing with Coord h8' do
      subject(:coord_h8) { described_class.new('h', 8) }

      let(:expected) do
        %w[g8 f8 e8 d8 c8 b8 a8].map do |coord_s|
          described_class.from_s(coord_s)
        end
      end

      it 'returns an array of western adjacencies' do
        result = coord_h8.to_western_adjacencies
        expect(result).to eq(expected)
      end
    end

    context 'when testing with Coord a8' do
      subject(:coord_a8) { described_class.new('a', 8) }

      it 'returns an empty array' do
        result = coord_a8.to_western_adjacencies
        expect(result).to be_an(Array).and be_empty
      end
    end
  end

  describe '#to_north_eastern_adjacencies' do
    context 'when testing with Coord a1' do
      subject(:coord_a1) { described_class.new('a', 1) }

      let(:expected) do
        %w[b2 c3 d4 e5 f6 g7 h8].map do |coord_s|
          described_class.from_s(coord_s)
        end
      end

      it 'returns an array of north eastern adjacencies' do
        result = coord_a1.to_north_eastern_adjacencies
        expect(result).to eq(expected)
      end
    end

    context 'when testing with Coord h8' do
      subject(:coord_h8) { described_class.new('h', 8) }

      it 'returns an empty array' do
        result = coord_h8.to_north_eastern_adjacencies
        expect(result).to be_an(Array).and be_empty
      end
    end
  end

  describe '#to_south_eastern_adjacencies' do
    context 'when testing with Coord a8' do
      subject(:coord_a8) { described_class.new('a', 8) }

      let(:expected) do
        %w[b7 c6 d5 e4 f3 g2 h1].map do |coord_s|
          described_class.from_s(coord_s)
        end
      end

      it 'returns an array of south eastern adjacencies' do
        result = coord_a8.to_south_eastern_adjacencies
        expect(result).to eq(expected)
      end
    end

    context 'when testing with Coord h1' do
      subject(:algebraic_coords_h1) { described_class.new('h', 1) }

      it 'returns an empty array' do
        result = algebraic_coords_h1.to_south_eastern_adjacencies
        expect(result).to be_an(Array).and be_empty
      end
    end
  end

  describe '#to_south_western_adjacencies' do
    context 'when testing with Coord h8' do
      subject(:coord_h8) { described_class.new('h', 8) }

      let(:expected) do
        %w[g7 f6 e5 d4 c3 b2 a1].map do |coord_s|
          described_class.from_s(coord_s)
        end
      end

      it 'returns an array of south western adjacencies' do
        result = coord_h8.to_south_western_adjacencies
        expect(result).to eq(expected)
      end
    end

    context 'when testing with Coord a1' do
      subject(:coord_a1) { described_class.new('a', 1) }

      it 'returns an empty array' do
        result = coord_a1.to_south_western_adjacencies
        expect(result).to be_an(Array).and be_empty
      end
    end
  end

  describe 'to_north_western_adjacencies' do
    context 'when testing with Coord h1' do
      subject(:algebraic_coords_h1) { described_class.new('h', 1) }

      let(:expected) do
        %w[g2 f3 e4 d5 c6 b7 a8].map do |coord_s|
          described_class.from_s(coord_s)
        end
      end

      it 'returns an array of north western adjacencies' do
        result = algebraic_coords_h1.to_north_western_adjacencies
        expect(result).to eq(expected)
      end
    end

    context 'when testing with Coord a8' do
      subject(:coord_a8) { described_class.new('a', 8) }

      it 'returns an empty array' do
        result = coord_a8.to_north_western_adjacencies
        expect(result).to be_an(Array).and be_empty
      end
    end
  end

  describe '#adjustment_in_bounds?' do
    subject(:coord_b7) { described_class.new('b', 7) }

    context 'when the file and rank adjustments would both remain in bounds' do
      it 'returns true' do
        result = coord_b7.adjustment_in_bounds?(-1, 1)
        expect(result).to be(true)
      end
    end

    context 'when the file adjustment would fall out of lower bounds' do
      it 'returns false' do
        result = coord_b7.adjustment_in_bounds?(-2, 0)
        expect(result).to be(false)
      end
    end

    context 'when the file adjustment would fall out of upper bounds' do
      it 'returns false' do
        result = coord_b7.adjustment_in_bounds?(7, 0)
        expect(result).to be(false)
      end
    end

    context 'when the rank adjustment would fall out of lower bounds' do
      it 'returns false' do
        result = coord_b7.adjustment_in_bounds?(0, -7)
        expect(result).to be(false)
      end
    end

    context 'when the rank adjustment would fall out of upper bounds' do
      it 'returns false' do
        result = coord_b7.adjustment_in_bounds?(0, 2)
        expect(result).to be(false)
      end
    end

    context 'when the file and rank adjustments would both fall out of bounds' do
      it 'returns false' do
        result = coord_b7.adjustment_in_bounds?(-2, 2)
        expect(result).to be(false)
      end
    end
  end

  describe '#file_to_i' do
    context 'when testing with Coord a8' do
      subject(:coord_a8) { described_class.new('a', 8) }

      it 'returns the file\'s integer equivalent' do
        result = coord_a8.file_to_i
        expect(result).to eq(1)
      end
    end

    context 'when testing with Coord h8' do
      subject(:coord_h8) { described_class.new('h', 8) }

      it 'returns the file\'s integer equivalent' do
        result = coord_h8.file_to_i
        expect(result).to eq(8)
      end
    end

    context 'when testing with Coord e8' do
      subject(:algebraic_coords_e8) { described_class.new('e', 8) }

      it 'returns the file\'s integer equivalent' do
        result = algebraic_coords_e8.file_to_i
        expect(result).to eq(5)
      end
    end
  end

  describe '#to_s' do
    context 'when testing with Coord a8' do
      subject(:coord_a8) { described_class.new('a', 8) }

      it 'returns the coordinates as a string' do
        result = coord_a8.to_s
        expect(result).to eq('a8')
      end
    end
  end
end
