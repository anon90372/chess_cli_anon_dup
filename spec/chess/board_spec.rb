# frozen_string_literal: true

describe Chess::Board do
  describe '::from_fen_parser' do
    context 'when passed a FENParser with a default FEN record' do
      subject { described_class }

      it 'returns a Board with the expected state' do
        fen_parser_default = Chess::FENParser.new(Chess::DEFAULT_FEN)
        result = described_class.from_fen_parser(fen_parser_default)
        string = result.to_partial_fen
        expect(string).to eq('rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR')
      end
    end
  end

  describe '#to_partial_fen' do
    context 'when testing with a default Board' do
      subject(:board_default) do
        fen_parser_default = Chess::FENParser.new(Chess::DEFAULT_FEN)
        described_class.from_fen_parser(fen_parser_default)
      end

      it 'returns a partial FEN record based on the data' do
        result = board_default.to_partial_fen
        expect(result).to eq('rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR')
      end
    end

    context 'when testing with a non-default Board' do
      subject(:board_non_default) do
        fen_non_default = 'kq6/8/8/8/8/8/7P/7K b - - 0 65'
        fen_parser_non_default = Chess::FENParser.new(fen_non_default)
        described_class.from_fen_parser(fen_parser_non_default)
      end

      it 'returns a partial FEN record based on the data' do
        result = board_non_default.to_partial_fen
        expect(result).to eq('kq6/8/8/8/8/8/7P/7K')
      end
    end
  end

  describe '#assoc_at' do
    subject(:board_default) do
      fen_parser_default = Chess::FENParser.new(Chess::DEFAULT_FEN)
      described_class.from_fen_parser(fen_parser_default)
    end

    let(:expected) do
      [
        'e1',
        'The Square is occupied by a white King.'
      ]
    end

    it 'returns the association at the given Coord' do
      coord_e1 = Chess::Coord.from_s('e1')
      result = board_default.assoc_at(coord_e1)
      strings = result.map(&:to_s)
      expect(strings).to eq(expected)
    end
  end

  describe '#square_at' do
    subject(:board_default) do
      fen_parser_default = Chess::FENParser.new(Chess::DEFAULT_FEN)
      described_class.from_fen_parser(fen_parser_default)
    end

    it 'returns the Square at the given Coord' do
      coord_e1 = Chess::Coord.from_s('e1')
      result = board_default.square_at(coord_e1)
      string = result.to_s
      expect(string).to eq('The Square is occupied by a white King.')
    end
  end

  describe '#occupant_at' do
    subject(:board_default) do
      fen_parser_default = Chess::FENParser.new(Chess::DEFAULT_FEN)
      described_class.from_fen_parser(fen_parser_default)
    end

    example 'Coord e1 returns the expected Piece' do
      coord_e1 = Chess::Coord.from_s('e1')
      result = board_default.occupant_at(coord_e1)
      expect(result.to_s).to eq('The King is white.')
    end

    example 'Coord e4 returns nil' do
      coord_e4 = Chess::Coord.from_s('e4')
      result = board_default.occupant_at(coord_e4)
      expect(result).to be_nil
    end
  end

  describe '#fill_at' do
    subject(:board_default) do
      fen_parser_default = Chess::FENParser.new(Chess::DEFAULT_FEN)
      described_class.from_fen_parser(fen_parser_default)
    end

    let(:before) do
      [
        'e4',
        'The Square is vacant.'
      ]
    end
    let(:after) do
      [
        'e4',
        'The Square is occupied by a white Queen.'
      ]
    end

    it 'updates the occupant at the given Coord' do
      coord_e4 = Chess::Coord.from_s('e4')
      queen = Chess::Queen.new(:white)
      expect { board_default.fill_at(coord_e4, queen) }.to change \
        { board_default.assoc_at(coord_e4).map(&:to_s) }.from(before).to(after)
    end
  end

  describe '#empty_at' do
    subject(:board_default) do
      fen_parser_default = Chess::FENParser.new(Chess::DEFAULT_FEN)
      described_class.from_fen_parser(fen_parser_default)
    end

    let(:before) do
      [
        'e8',
        'The Square is occupied by a black King.'
      ]
    end
    let(:after) do
      [
        'e8',
        'The Square is vacant.'
      ]
    end

    it 'empties the occupant at the given Coord' do
      coord_e8 = Chess::Coord.from_s('e8')
      expect { board_default.empty_at(coord_e8) }.to change \
        { board_default.assoc_at(coord_e8).map(&:to_s) }.from(before).to(after)
    end
  end

  describe '#replace_at' do
    subject(:board_default) do
      fen_parser_default = Chess::FENParser.new(Chess::DEFAULT_FEN)
      described_class.from_fen_parser(fen_parser_default)
    end

    context 'when vacant at the given source' do
      let(:source) { Chess::Coord.from_s('e4') }
      let(:type) { Chess::Queen }

      it 'raises an argument error' do
        expect { board_default.replace_at(source, type) }.to raise_error(ArgumentError)
      end
    end

    context 'when occupied at the given source by white' do
      let(:source) { Chess::Coord.from_s('e2') }
      let(:type) { Chess::Queen }

      it 'replaces the given source with the given type' do
        expect { board_default.replace_at(source, type) }
          .to change(board_default, :to_partial_fen)
          .to('rnbqkbnr/pppppppp/8/8/8/8/PPPPQPPP/RNBQKBNR')
      end
    end

    context 'when occupied at the given source by black' do
      let(:source) { Chess::Coord.from_s('e7') }
      let(:type) { Chess::Knight }

      it 'replaces the given source with the given type' do
        expect { board_default.replace_at(source, type) }
          .to change(board_default, :to_partial_fen)
          .to('rnbqkbnr/ppppnppp/8/8/8/8/PPPPPPPP/RNBQKBNR')
      end
    end
  end

  describe '#occupied_at?' do
    subject(:board_default) do
      fen_parser_default = Chess::FENParser.new(Chess::DEFAULT_FEN)
      described_class.from_fen_parser(fen_parser_default)
    end

    context 'when occupied at the given Coord' do
      it 'returns true' do
        coord_e2 = Chess::Coord.from_s('e2')
        result = board_default.occupied_at?(coord_e2)
        expect(result).to be(true)
      end
    end

    context 'when vacant at the given Coord' do
      it 'returns false' do
        coord_e3 = Chess::Coord.from_s('e3')
        result = board_default.occupied_at?(coord_e3)
        expect(result).to be(false)
      end
    end
  end

  describe '#vacant_at?' do
    subject(:board_default) do
      fen_parser_default = Chess::FENParser.new(Chess::DEFAULT_FEN)
      described_class.from_fen_parser(fen_parser_default)
    end

    context 'when vacant at the given Coord' do
      it 'returns true' do
        coord_e3 = Chess::Coord.from_s('e3')
        result = board_default.vacant_at?(coord_e3)
        expect(result).to be(true)
      end
    end

    context 'when occupied at the given Coord' do
      it 'returns false' do
        coord_e2 = Chess::Coord.from_s('e2')
        result = board_default.vacant_at?(coord_e2)
        expect(result).to be(false)
      end
    end
  end

  describe '#pawn_at?' do
    subject(:board_default) do
      fen_parser_default = Chess::FENParser.new(Chess::DEFAULT_FEN)
      described_class.from_fen_parser(fen_parser_default)
    end

    context 'when occupied by a pawn at the given Coord' do
      it 'returns true' do
        expect(board_default.pawn_at?(Chess::Coord.from_s('e7'))).to be(true)
      end
    end

    context 'when not occupied by a pawn at the given Coord' do
      it 'returns false' do
        expect(board_default.pawn_at?(Chess::Coord.from_s('e1'))).to be(false)
      end
    end

    context 'when vacant at the given Coord' do
      it 'returns false' do
        expect(board_default.pawn_at?(Chess::Coord.from_s('e4'))).to be(false)
      end
    end
  end

  describe '#to_occupied_locations' do
    subject(:board_default) do
      fen_parser_default = Chess::FENParser.new(Chess::DEFAULT_FEN)
      described_class.from_fen_parser(fen_parser_default)
    end

    context 'when passed a white color' do
      let(:expected) do
        {
          'a2' => 'The Square is occupied by a white Pawn.',
          'b2' => 'The Square is occupied by a white Pawn.',
          'c2' => 'The Square is occupied by a white Pawn.',
          'd2' => 'The Square is occupied by a white Pawn.',
          'e2' => 'The Square is occupied by a white Pawn.',
          'f2' => 'The Square is occupied by a white Pawn.',
          'g2' => 'The Square is occupied by a white Pawn.',
          'h2' => 'The Square is occupied by a white Pawn.',
          'a1' => 'The Square is occupied by a white Rook.',
          'b1' => 'The Square is occupied by a white Knight.',
          'c1' => 'The Square is occupied by a white Bishop.',
          'd1' => 'The Square is occupied by a white Queen.',
          'e1' => 'The Square is occupied by a white King.',
          'f1' => 'The Square is occupied by a white Bishop.',
          'g1' => 'The Square is occupied by a white Knight.',
          'h1' => 'The Square is occupied by a white Rook.'
        }
      end

      it 'returns a hash containing only white-occupied associations' do
        result = board_default.to_occupied_locations(:white)
        result = result.transform_keys(&:to_s)
        result = result.transform_values(&:to_s)
        expect(result).to eq(expected)
      end
    end

    context 'when passed a black color' do
      let(:expected) do
        {
          'a7' => 'The Square is occupied by a black Pawn.',
          'b7' => 'The Square is occupied by a black Pawn.',
          'c7' => 'The Square is occupied by a black Pawn.',
          'd7' => 'The Square is occupied by a black Pawn.',
          'e7' => 'The Square is occupied by a black Pawn.',
          'f7' => 'The Square is occupied by a black Pawn.',
          'g7' => 'The Square is occupied by a black Pawn.',
          'h7' => 'The Square is occupied by a black Pawn.',
          'a8' => 'The Square is occupied by a black Rook.',
          'b8' => 'The Square is occupied by a black Knight.',
          'c8' => 'The Square is occupied by a black Bishop.',
          'd8' => 'The Square is occupied by a black Queen.',
          'e8' => 'The Square is occupied by a black King.',
          'f8' => 'The Square is occupied by a black Bishop.',
          'g8' => 'The Square is occupied by a black Knight.',
          'h8' => 'The Square is occupied by a black Rook.'
        }
      end

      it 'returns a hash containing only black-occupied associations' do
        result = board_default.to_occupied_locations(:black)
        result = result.transform_keys(&:to_s)
        result = result.transform_values(&:to_s)
        expect(result).to eq(expected)
      end
    end
  end

  describe '#to_ranks' do
    subject(:board_default) do
      fen_parser_default = Chess::FENParser.new(Chess::DEFAULT_FEN)
      described_class.from_fen_parser(fen_parser_default)
    end

    let(:expected) do
      {
        8 => [
          'The Square is occupied by a black Rook.',
          'The Square is occupied by a black Knight.',
          'The Square is occupied by a black Bishop.',
          'The Square is occupied by a black Queen.',
          'The Square is occupied by a black King.',
          'The Square is occupied by a black Bishop.',
          'The Square is occupied by a black Knight.',
          'The Square is occupied by a black Rook.'
        ],
        7 => [
          'The Square is occupied by a black Pawn.',
          'The Square is occupied by a black Pawn.',
          'The Square is occupied by a black Pawn.',
          'The Square is occupied by a black Pawn.',
          'The Square is occupied by a black Pawn.',
          'The Square is occupied by a black Pawn.',
          'The Square is occupied by a black Pawn.',
          'The Square is occupied by a black Pawn.'
        ],
        6 => [
          'The Square is vacant.',
          'The Square is vacant.',
          'The Square is vacant.',
          'The Square is vacant.',
          'The Square is vacant.',
          'The Square is vacant.',
          'The Square is vacant.',
          'The Square is vacant.'
        ],
        5 => [
          'The Square is vacant.',
          'The Square is vacant.',
          'The Square is vacant.',
          'The Square is vacant.',
          'The Square is vacant.',
          'The Square is vacant.',
          'The Square is vacant.',
          'The Square is vacant.'
        ],
        4 => [
          'The Square is vacant.',
          'The Square is vacant.',
          'The Square is vacant.',
          'The Square is vacant.',
          'The Square is vacant.',
          'The Square is vacant.',
          'The Square is vacant.',
          'The Square is vacant.'
        ],
        3 => [
          'The Square is vacant.',
          'The Square is vacant.',
          'The Square is vacant.',
          'The Square is vacant.',
          'The Square is vacant.',
          'The Square is vacant.',
          'The Square is vacant.',
          'The Square is vacant.'
        ],
        2 => [
          'The Square is occupied by a white Pawn.',
          'The Square is occupied by a white Pawn.',
          'The Square is occupied by a white Pawn.',
          'The Square is occupied by a white Pawn.',
          'The Square is occupied by a white Pawn.',
          'The Square is occupied by a white Pawn.',
          'The Square is occupied by a white Pawn.',
          'The Square is occupied by a white Pawn.'
        ],
        1 => [
          'The Square is occupied by a white Rook.',
          'The Square is occupied by a white Knight.',
          'The Square is occupied by a white Bishop.',
          'The Square is occupied by a white Queen.',
          'The Square is occupied by a white King.',
          'The Square is occupied by a white Bishop.',
          'The Square is occupied by a white Knight.',
          'The Square is occupied by a white Rook.'
        ]
      }
    end

    it 'returns a hash where each key is a rank integer pointing to an array of Squares' do
      result = board_default.to_ranks
      strings = result.transform_values do |square_a|
        square_a.map(&:to_s)
      end
      expect(strings).to eq(expected)
    end
  end
end
