# frozen_string_literal: true

describe Chess::AuxPosData do
  describe '::from_fen_parser' do
    context 'when passed a FENParser with a default FEN record' do
      subject { described_class }

      let(:expected) do
        { active_color: 'w',
          castling_availability: 'KQkq',
          en_passant_target: '-',
          half_move_clock: '0',
          full_move_number: '1' }
      end

      it 'returns an AuxPosData with the expected state' do
        fen_default = Chess::DEFAULT_FEN
        fen_parser_default = Chess::FENParser.new(fen_default)
        result = described_class.from_fen_parser(fen_parser_default)
        data_fields = result.instance_variable_get(:@data_fields)
        expect(data_fields).to eq(expected)
      end
    end

    context 'when passed a FENParser with an endgame FEN record' do
      subject { described_class }

      let(:expected) do
        { active_color: 'b',
          castling_availability: '-',
          en_passant_target: '-',
          half_move_clock: '0',
          full_move_number: '65' }
      end

      it 'returns an AuxPosData with the expected state' do
        fen_endgame = 'kq6/8/8/8/8/8/7P/7K b - - 0 65'
        fen_parser_endgame = Chess::FENParser.new(fen_endgame)
        result = described_class.from_fen_parser(fen_parser_endgame)
        data_fields = result.instance_variable_get(:@data_fields)
        expect(data_fields).to eq(expected)
      end
    end
  end

  describe '#to_partial_fen' do
    context 'when testing with a default AuxPosData' do
      subject(:aux_pos_data_default) { described_class.new(data_fields_default) }

      let(:data_fields_default) do
        { active_color: 'w',
          castling_availability: 'KQkq',
          en_passant_target: '-',
          half_move_clock: '0',
          full_move_number: '1' }
      end

      it 'returns a partial FEN record based on the data' do
        result = aux_pos_data_default.to_partial_fen
        expect(result).to eq('w KQkq - 0 1')
      end
    end

    context 'when testing with an endgame AuxPosData' do
      subject(:aux_pos_data_endgame) { described_class.new(data_fields_endgame) }

      let(:data_fields_endgame) do
        { active_color: 'b',
          castling_availability: '-',
          en_passant_target: '-',
          half_move_clock: '0',
          full_move_number: '65' }
      end

      it 'returns a partial FEN record based on the data' do
        result = aux_pos_data_endgame.to_partial_fen
        expect(result).to eq('b - - 0 65')
      end
    end
  end

  describe '#white_has_the_move?' do
    context 'when white has the move' do
      subject(:aux_pos_data_white_active) { described_class.new(data_fields_white_active) }

      let(:data_fields_white_active) do
        { active_color: 'w',
          castling_availability: 'KQkq',
          en_passant_target: '-',
          half_move_clock: '0',
          full_move_number: '1' }
      end

      it 'returns true' do
        result = aux_pos_data_white_active.white_has_the_move?
        expect(result).to be(true)
      end
    end

    context 'when black has the move' do
      subject(:aux_pos_data_black_active) { described_class.new(data_fields_black_active) }

      let(:data_fields_black_active) do
        { active_color: 'b',
          castling_availability: '-',
          en_passant_target: '-',
          half_move_clock: '0',
          full_move_number: '65' }
      end

      it 'returns false' do
        result = aux_pos_data_black_active.white_has_the_move?
        expect(result).to be(false)
      end
    end
  end

  describe '#black_has_the_move?' do
    context 'when black has the move' do
      subject(:aux_pos_data_black_active) { described_class.new(data_fields_black_active) }

      let(:data_fields_black_active) do
        { active_color: 'b',
          castling_availability: '-',
          en_passant_target: '-',
          half_move_clock: '0',
          full_move_number: '65' }
      end

      it 'returns true' do
        result = aux_pos_data_black_active.black_has_the_move?
        expect(result).to be(true)
      end
    end

    context 'when white has the move' do
      subject(:aux_pos_data_white_active) { described_class.new(data_fields_white_active) }

      let(:data_fields_white_active) do
        { active_color: 'w',
          castling_availability: 'KQkq',
          en_passant_target: '-',
          half_move_clock: '0',
          full_move_number: '1' }
      end

      it 'returns false' do
        result = aux_pos_data_white_active.black_has_the_move?
        expect(result).to be(false)
      end
    end
  end

  describe '#swap_active_color' do
    context 'when white is active' do
      subject(:aux_pos_data_white_active) { described_class.new(data_fields_white_active) }

      let(:data_fields_white_active) do
        { active_color: 'w',
          castling_availability: 'KQkq',
          en_passant_target: '-',
          half_move_clock: '0',
          full_move_number: '1' }
      end

      it 'swaps the active color to black' do
        expect { aux_pos_data_white_active.swap_active_color }.to change \
          { aux_pos_data_white_active.instance_variable_get(:@data_fields)[:active_color] }
          .from('w').to('b')
      end
    end

    context 'when black is active' do
      subject(:aux_pos_data_black_active) { described_class.new(data_fields_black_active) }

      let(:data_fields_black_active) do
        { active_color: 'b',
          castling_availability: '-',
          en_passant_target: '-',
          half_move_clock: '0',
          full_move_number: '65' }
      end

      it 'swaps the active color to white' do
        expect { aux_pos_data_black_active.swap_active_color }.to change \
          { aux_pos_data_black_active.instance_variable_get(:@data_fields)[:active_color] }
          .from('b').to('w')
      end
    end
  end

  describe '#white_kingside_castle_available?' do
    context 'when white kingside castling is available' do
      subject(:aux_pos_data_white_kingside) { described_class.new(data_fields_white_kingside) }

      let(:data_fields_white_kingside) do
        { active_color: 'w',
          castling_availability: 'KQkq',
          en_passant_target: '-',
          half_move_clock: '0',
          full_move_number: '25' }
      end

      it 'returns true' do
        result = aux_pos_data_white_kingside.white_kingside_castle_available?
        expect(result).to be(true)
      end
    end

    context 'when white kingside castling is not available' do
      subject(:aux_pos_data_no_white_kingside) { described_class.new(data_fields_no_white_kingside) }

      let(:data_fields_no_white_kingside) do
        { active_color: 'w',
          castling_availability: 'Qkq',
          en_passant_target: '-',
          half_move_clock: '0',
          full_move_number: '25' }
      end

      it 'returns false' do
        result = aux_pos_data_no_white_kingside.white_kingside_castle_available?
        expect(result).to be(false)
      end
    end
  end

  describe '#white_queenside_castle_available?' do
    context 'when white queenside castling is available' do
      subject(:aux_pos_data_white_queenside) { described_class.new(data_fields_white_queenside) }

      let(:data_fields_white_queenside) do
        { active_color: 'w',
          castling_availability: 'KQkq',
          en_passant_target: '-',
          half_move_clock: '0',
          full_move_number: '25' }
      end

      it 'returns true' do
        result = aux_pos_data_white_queenside.white_queenside_castle_available?
        expect(result).to be(true)
      end
    end

    context 'when white queenside castling is not available' do
      subject(:aux_pos_data_no_white_queenside) { described_class.new(data_fields_no_white_queenside) }

      let(:data_fields_no_white_queenside) do
        { active_color: 'w',
          castling_availability: 'Kkq',
          en_passant_target: '-',
          half_move_clock: '0',
          full_move_number: '25' }
      end

      it 'returns false' do
        result = aux_pos_data_no_white_queenside.white_queenside_castle_available?
        expect(result).to be(false)
      end
    end
  end

  describe '#black_kingside_castle_available?' do
    context 'when black kingside castling is available' do
      subject(:aux_pos_data_black_kingside) { described_class.new(data_fields_black_kingside) }

      let(:data_fields_black_kingside) do
        { active_color: 'w',
          castling_availability: 'KQkq',
          en_passant_target: '-',
          half_move_clock: '0',
          full_move_number: '25' }
      end

      it 'returns true' do
        result = aux_pos_data_black_kingside.black_kingside_castle_available?
        expect(result).to be(true)
      end
    end

    context 'when black kingside castling is not available' do
      subject(:aux_pos_data_no_black_kingside) { described_class.new(data_fields_no_black_kingside) }

      let(:data_fields_no_black_kingside) do
        { active_color: 'w',
          castling_availability: 'KQq',
          en_passant_target: '-',
          half_move_clock: '0',
          full_move_number: '25' }
      end

      it 'returns false' do
        result = aux_pos_data_no_black_kingside.black_kingside_castle_available?
        expect(result).to be(false)
      end
    end
  end

  describe '#black_queenside_castle_available?' do
    context 'when black queenside castling is available' do
      subject(:aux_pos_data_black_queenside) { described_class.new(data_fields_black_queenside) }

      let(:data_fields_black_queenside) do
        { active_color: 'w',
          castling_availability: 'KQkq',
          en_passant_target: '-',
          half_move_clock: '0',
          full_move_number: '25' }
      end

      it 'returns true' do
        result = aux_pos_data_black_queenside.black_queenside_castle_available?
        expect(result).to be(true)
      end
    end

    context 'when black queenside castling is not available' do
      subject(:aux_pos_data_no_black_queenside) { described_class.new(data_fields_no_black_queenside) }

      let(:data_fields_no_black_queenside) do
        { active_color: 'w',
          castling_availability: 'KQk',
          en_passant_target: '-',
          half_move_clock: '0',
          full_move_number: '25' }
      end

      it 'returns false' do
        result = aux_pos_data_no_black_queenside.black_queenside_castle_available?
        expect(result).to be(false)
      end
    end
  end

  describe '#remove_white_kingside_castle' do
    context 'when white kingside castling is available' do
      subject(:aux_pos_data_white_kingside) { described_class.new(data_fields_white_kingside) }

      let(:data_fields_white_kingside) do
        { active_color: 'w',
          castling_availability: 'KQkq',
          en_passant_target: '-',
          half_move_clock: '0',
          full_move_number: '25' }
      end

      it 'removes white kingside castling availability' do
        expect { aux_pos_data_white_kingside.remove_white_kingside_castle }.to change \
          { aux_pos_data_white_kingside.instance_variable_get(:@data_fields)[:castling_availability] }
          .from('KQkq').to('Qkq')
      end
    end

    context 'when white kingside castling is not available' do
      subject(:aux_pos_data_no_white_kingside) { described_class.new(data_fields_no_white_kingside) }

      let(:data_fields_no_white_kingside) do
        { active_color: 'w',
          castling_availability: 'Qkq',
          en_passant_target: '-',
          half_move_clock: '0',
          full_move_number: '25' }
      end

      it 'returns nil' do
        result = aux_pos_data_no_white_kingside.remove_white_kingside_castle
        expect(result).to be_nil
      end
    end

    context 'when removal results in empty castling availability' do
      subject(:aux_pos_data_only_white_kingside) { described_class.new(data_fields_only_white_kingside) }

      let(:data_fields_only_white_kingside) do
        { active_color: 'w',
          castling_availability: 'K',
          en_passant_target: '-',
          half_move_clock: '0',
          full_move_number: '25' }
      end

      it 'removes white kingside castling availability and denotes empty castling availability' do
        expect { aux_pos_data_only_white_kingside.remove_white_kingside_castle }.to change \
          { aux_pos_data_only_white_kingside.instance_variable_get(:@data_fields)[:castling_availability] }
          .from('K').to('-')
      end
    end
  end

  describe '#remove_white_queenside_castle' do
    context 'when white queenside castling is available' do
      subject(:aux_pos_data_white_queenside) { described_class.new(data_fields_white_queenside) }

      let(:data_fields_white_queenside) do
        { active_color: 'w',
          castling_availability: 'KQkq',
          en_passant_target: '-',
          half_move_clock: '0',
          full_move_number: '25' }
      end

      it 'removes white queenside castling availability' do
        expect { aux_pos_data_white_queenside.remove_white_queenside_castle }.to change \
          { aux_pos_data_white_queenside.instance_variable_get(:@data_fields)[:castling_availability] }
          .from('KQkq').to('Kkq')
      end
    end

    context 'when white queenside castling is not available' do
      subject(:aux_pos_data_no_white_queenside) { described_class.new(data_fields_no_white_queenside) }

      let(:data_fields_no_white_queenside) do
        { active_color: 'w',
          castling_availability: 'Kkq',
          en_passant_target: '-',
          half_move_clock: '0',
          full_move_number: '25' }
      end

      it 'returns nil' do
        result = aux_pos_data_no_white_queenside.remove_white_queenside_castle
        expect(result).to be_nil
      end
    end

    context 'when removal results in empty castling availability' do
      subject(:aux_pos_data_only_white_queenside) { described_class.new(data_fields_only_white_queenside) }

      let(:data_fields_only_white_queenside) do
        { active_color: 'w',
          castling_availability: 'Q',
          en_passant_target: '-',
          half_move_clock: '0',
          full_move_number: '25' }
      end

      it 'removes white queenside castling availability and denotes empty castling availability' do
        expect { aux_pos_data_only_white_queenside.remove_white_queenside_castle }.to change \
          { aux_pos_data_only_white_queenside.instance_variable_get(:@data_fields)[:castling_availability] }
          .from('Q').to('-')
      end
    end
  end

  describe '#remove_black_kingside_castle' do
    context 'when black kingside castling is available' do
      subject(:aux_pos_data_black_kingside) { described_class.new(data_fields_black_kingside) }

      let(:data_fields_black_kingside) do
        { active_color: 'w',
          castling_availability: 'KQkq',
          en_passant_target: '-',
          half_move_clock: '0',
          full_move_number: '25' }
      end

      it 'removes black kingside castling availability' do
        expect { aux_pos_data_black_kingside.remove_black_kingside_castle }.to change \
          { aux_pos_data_black_kingside.instance_variable_get(:@data_fields)[:castling_availability] }
          .from('KQkq').to('KQq')
      end
    end

    context 'when black kingside castling is not available' do
      subject(:aux_pos_data_no_black_kingside) { described_class.new(data_fields_no_black_kingside) }

      let(:data_fields_no_black_kingside) do
        { active_color: 'w',
          castling_availability: 'KQq',
          en_passant_target: '-',
          half_move_clock: '0',
          full_move_number: '25' }
      end

      it 'returns nil' do
        result = aux_pos_data_no_black_kingside.remove_black_kingside_castle
        expect(result).to be_nil
      end
    end

    context 'when removal results in empty castling availability' do
      subject(:aux_pos_data_only_black_kingside) { described_class.new(data_fields_only_black_kingside) }

      let(:data_fields_only_black_kingside) do
        { active_color: 'w',
          castling_availability: 'k',
          en_passant_target: '-',
          half_move_clock: '0',
          full_move_number: '25' }
      end

      it 'removes black kingside castling availability and denotes empty castling availability' do
        expect { aux_pos_data_only_black_kingside.remove_black_kingside_castle }.to change \
          { aux_pos_data_only_black_kingside.instance_variable_get(:@data_fields)[:castling_availability] }
          .from('k').to('-')
      end
    end
  end

  describe '#remove_black_queenside_castle' do
    context 'when black queenside castling is available' do
      subject(:aux_pos_data_black_queenside) { described_class.new(data_fields_black_queenside) }

      let(:data_fields_black_queenside) do
        { active_color: 'w',
          castling_availability: 'KQkq',
          en_passant_target: '-',
          half_move_clock: '0',
          full_move_number: '25' }
      end

      it 'removes black queenside castling availability' do
        expect { aux_pos_data_black_queenside.remove_black_queenside_castle }.to change \
          { aux_pos_data_black_queenside.instance_variable_get(:@data_fields)[:castling_availability] }
          .from('KQkq').to('KQk')
      end
    end

    context 'when black queenside castling is not available' do
      subject(:aux_pos_data_no_black_queenside) { described_class.new(data_fields_no_black_queenside) }

      let(:data_fields_no_black_queenside) do
        { active_color: 'w',
          castling_availability: 'KQk',
          en_passant_target: '-',
          half_move_clock: '0',
          full_move_number: '25' }
      end

      it 'returns nil' do
        result = aux_pos_data_no_black_queenside.remove_black_queenside_castle
        expect(result).to be_nil
      end
    end

    context 'when removal results in empty castling availability' do
      subject(:aux_pos_data_only_black_queenside) { described_class.new(data_fields_only_black_queenside) }

      let(:data_fields_only_black_queenside) do
        { active_color: 'w',
          castling_availability: 'q',
          en_passant_target: '-',
          half_move_clock: '0',
          full_move_number: '25' }
      end

      it 'removes black queenside castling availability and denotes empty castling availability' do
        expect { aux_pos_data_only_black_queenside.remove_black_queenside_castle }.to change \
          { aux_pos_data_only_black_queenside.instance_variable_get(:@data_fields)[:castling_availability] }
          .from('q').to('-')
      end
    end
  end

  describe '#remove_all_castling_rights' do
    subject(:aux_pos_data) do
      fen = Chess::DEFAULT_FEN
      fen_parser = Chess::FENParser.new(fen)
      described_class.from_fen_parser(fen_parser)
    end

    context 'with white' do
      it 'removes all white castling rights' do
        expect { aux_pos_data.remove_all_castling_rights(:white) }
          .to change(aux_pos_data, :to_partial_fen)
          .to('w kq - 0 1')
      end
    end

    context 'with black' do
      it 'removes all black castling rights' do
        expect { aux_pos_data.remove_all_castling_rights(:black) }
          .to change(aux_pos_data, :to_partial_fen)
          .to('w KQ - 0 1')
      end
    end
  end

  describe '#en_passant_target_available?' do
    context 'when an en passant target is available' do
      subject(:aux_pos_data_en_passant) { described_class.new(data_fields_en_passant) }

      let(:data_fields_en_passant) do
        { active_color: 'b',
          castling_availability: 'KQkq',
          en_passant_target: 'e3',
          half_move_clock: '0',
          full_move_number: '1' }
      end

      it 'returns true' do
        result = aux_pos_data_en_passant.en_passant_target_available?
        expect(result).to be(true)
      end
    end

    context 'when an en passant target is not available' do
      subject(:aux_pos_data_no_en_passant) { described_class.new(data_fields_no_en_passant) }

      let(:data_fields_no_en_passant) do
        { active_color: 'w',
          castling_availability: 'KQkq',
          en_passant_target: '-',
          half_move_clock: '0',
          full_move_number: '1' }
      end

      it 'returns false' do
        result = aux_pos_data_no_en_passant.en_passant_target_available?
        expect(result).to be(false)
      end
    end
  end

  describe '#access_en_passant_target' do
    subject(:aux_pos_data_en_passant) { described_class.new(data_fields_en_passant) }

    let(:data_fields_en_passant) do
      { active_color: 'b',
        castling_availability: 'KQkq',
        en_passant_target: 'e3',
        half_move_clock: '0',
        full_move_number: '1' }
    end

    it 'returns the en passant target data field' do
      result = aux_pos_data_en_passant.access_en_passant_target
      expect(result).to eq('e3')
    end
  end

  describe '#update_en_passant_target' do
    subject(:aux_pos_data_default) { described_class.new(data_fields_default) }

    let(:data_fields_default) do
      { active_color: 'w',
        castling_availability: 'KQkq',
        en_passant_target: '-',
        half_move_clock: '0',
        full_move_number: '1' }
    end
    let(:new_coord_s) { 'e3' }

    it 'updates the en passant target coordinates' do
      expect { aux_pos_data_default.update_en_passant_target(new_coord_s) }.to change \
        { aux_pos_data_default.instance_variable_get(:@data_fields)[:en_passant_target] }
        .from('-').to(new_coord_s)
    end

    it 'returns the new en passant target coordinates' do
      result = aux_pos_data_default.update_en_passant_target(new_coord_s)
      expect(result).to be(new_coord_s)
    end
  end

  describe '#reset_en_passant_target' do
    subject(:aux_pos_data_en_passant) { described_class.new(data_fields_en_passant) }

    let(:data_fields_en_passant) do
      { active_color: 'b',
        castling_availability: 'KQkq',
        en_passant_target: 'e3',
        half_move_clock: '0',
        full_move_number: '1' }
    end

    it 'resets the en passant target' do
      expect { aux_pos_data_en_passant.reset_en_passant_target }.to change \
        { aux_pos_data_en_passant.instance_variable_get(:@data_fields)[:en_passant_target] }
        .from('e3').to('-')
    end
  end

  describe '#fifty_move_rule_satisfied?' do
    context 'when the half move clock is at one hundred' do
      subject(:aux_pos_data_fifty_move_rule) do
        described_class.new(data_fields_half_move_clock_one_hundred)
      end

      let(:data_fields_half_move_clock_one_hundred) do
        { active_color: 'b',
          castling_availability: '-',
          en_passant_target: '-',
          half_move_clock: '100',
          full_move_number: '150' }
      end

      it 'returns true' do
        result = aux_pos_data_fifty_move_rule.fifty_move_rule_satisfied?
        expect(result).to be(true)
      end
    end

    context 'when the half move clock is at greater than one hundred' do
      subject(:aux_pos_data_fifty_move_rule) do
        described_class.new(data_fields_half_move_clock_one_hundred_and_one)
      end

      let(:data_fields_half_move_clock_one_hundred_and_one) do
        { active_color: 'b',
          castling_availability: '-',
          en_passant_target: '-',
          half_move_clock: '101',
          full_move_number: '150' }
      end

      it 'returns true' do
        result = aux_pos_data_fifty_move_rule.fifty_move_rule_satisfied?
        expect(result).to be(true)
      end
    end

    context 'when the half move clock is at less than one hundred' do
      subject(:aux_pos_data_no_fifty_move_rule) do
        described_class.new(data_fields_half_move_clock_ninety_nine)
      end

      let(:data_fields_half_move_clock_ninety_nine) do
        { active_color: 'b',
          castling_availability: '-',
          en_passant_target: '-',
          half_move_clock: '99',
          full_move_number: '150' }
      end

      it 'returns false' do
        result = aux_pos_data_no_fifty_move_rule.fifty_move_rule_satisfied?
        expect(result).to be(false)
      end
    end
  end

  describe '#seventy_five_move_rule_satisfied?' do
    context 'when the half move clock is at one hundred and fifty' do
      subject(:aux_pos_data_seventy_five_move_rule) do
        described_class.new(data_fields_half_move_clock_one_hundred_and_fifty)
      end

      let(:data_fields_half_move_clock_one_hundred_and_fifty) do
        { active_color: 'b',
          castling_availability: '-',
          en_passant_target: '-',
          half_move_clock: '150',
          full_move_number: '250' }
      end

      it 'returns true' do
        result = aux_pos_data_seventy_five_move_rule.seventy_five_move_rule_satisfied?
        expect(result).to be(true)
      end
    end

    context 'when the half move clock is at greater than one hundred and fifty' do
      subject(:aux_pos_data_seventy_five_move_rule) do
        described_class.new(data_fields_half_move_clock_one_hundred_and_fifty_one)
      end

      let(:data_fields_half_move_clock_one_hundred_and_fifty_one) do
        { active_color: 'b',
          castling_availability: '-',
          en_passant_target: '-',
          half_move_clock: '151',
          full_move_number: '250' }
      end

      it 'returns true' do
        result = aux_pos_data_seventy_five_move_rule.seventy_five_move_rule_satisfied?
        expect(result).to be(true)
      end
    end

    context 'when the half move clock is at less than one hundred and fifty' do
      subject(:aux_pos_data_no_seventy_five_move_rule) do
        described_class.new(data_fields_half_move_clock_one_hundred_and_forty_nine)
      end

      let(:data_fields_half_move_clock_one_hundred_and_forty_nine) do
        { active_color: 'b',
          castling_availability: '-',
          en_passant_target: '-',
          half_move_clock: '149',
          full_move_number: '250' }
      end

      it 'returns false' do
        result = aux_pos_data_no_seventy_five_move_rule.seventy_five_move_rule_satisfied?
        expect(result).to be(false)
      end
    end
  end

  describe '#increment_half_move_clock' do
    subject(:aux_pos_data_default) { described_class.new(data_fields_default) }

    let(:data_fields_default) do
      { active_color: 'w',
        castling_availability: 'KQkq',
        en_passant_target: '-',
        half_move_clock: '0',
        full_move_number: '1' }
    end

    it 'increments the half move clock by one' do
      expect { aux_pos_data_default.increment_half_move_clock }.to change \
        { aux_pos_data_default.instance_variable_get(:@data_fields)[:half_move_clock] }
        .from('0').to('1')
    end
  end

  describe '#reset_half_move_clock' do
    subject(:aux_pos_data_half_move_clock_positive) do
      described_class.new(data_fields_half_move_clock_twenty_five)
    end

    let(:data_fields_half_move_clock_twenty_five) do
      { active_color: 'b',
        castling_availability: '-',
        en_passant_target: '-',
        half_move_clock: '25',
        full_move_number: '75' }
    end

    it 'resets the half move clock to zero' do
      expect { aux_pos_data_half_move_clock_positive.reset_half_move_clock }.to change \
        { aux_pos_data_half_move_clock_positive.instance_variable_get(:@data_fields)[:half_move_clock] }
        .from('25').to('0')
    end
  end

  describe '#increment_full_move_number' do
    subject(:aux_pos_data_first_move) { described_class.new(data_fields_first_move) }

    let(:data_fields_first_move) do
      { active_color: 'b',
        castling_availability: 'KQkq',
        en_passant_target: '-',
        half_move_clock: '1',
        full_move_number: '1' }
    end

    it 'increments the full move number by one' do
      expect { aux_pos_data_first_move.increment_full_move_number }.to change \
        { aux_pos_data_first_move.instance_variable_get(:@data_fields)[:full_move_number] }
        .from('1').to('2')
    end
  end
end
