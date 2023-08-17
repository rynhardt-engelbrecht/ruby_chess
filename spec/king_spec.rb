require_relative '../lib/pieces/pieces'

RSpec.describe King do
  let(:board) { Board.new }
  subject(:king) { King.new(board, [7, 4], :white) }

  before do
    king.instance_variable_set(:@valid_moves, [])
  end

  describe '#generate_moves' do
    context 'when ineligible for castling' do
      context 'with no nearby pieces' do
        it 'correctly updates @valid_moves' do
          expected_moves = [
            [7, 3], [6, 3],
            [6, 4], [6, 5],
            [7, 5]
          ]

          expect { king.generate_moves(board, king.location[0], king.location[1]) }.to change { king.valid_moves }.from([])

          expect(king.valid_moves).to match_array(expected_moves)
        end
      end

      context 'when ally piece is in the way' do
        before do
          Queen.new(board, [7, 3], :white)
        end

        it 'does not add ally square to @valid_moves' do
          expect { king.generate_moves(board, king.location[0], king.location[1]) }.to change { king.valid_moves }.from([])

          expect(king.valid_moves.include?([7, 3])).to be false
        end
      end

      context 'when opponent piece is in the way' do
        before do
          Rook.new(board, [7, 5], :black)
        end

        it 'adds opponent square to @valid_moves' do
          expect { king.generate_moves(board, king.location[0], king.location[1]) }.to change { king.valid_moves }.from([])

          expect(king.valid_moves.include?([7, 5])).to be true
        end
      end
    end

    context 'when eligible for castling kingside' do
      before do
        Rook.new(board, [7, 7], :white)

        expect(king.king_side_castling?(board)).to be true
      end

      it 'correctly updates @valid_moves' do
        expected_moves = [
          [7, 3], [6, 3],
          [6, 4], [6, 5],
          [7, 5], [7, 6]
        ]

        expect { king.generate_moves(board, king.location[0], king.location[1]) }.to change { king.valid_moves }.from([])

        expect(king.valid_moves).to match_array(expected_moves)
      end
    end

    context 'when eligible for castling queenside' do
      before do
        Rook.new(board, [7, 0], :white)

        expect(king.queen_side_castling?(board)).to be true
      end

      it 'correctly updates @valid_moves' do
        expected_moves = [
          [7, 2], [7, 3],
          [6, 3], [6, 4],
          [6, 5], [7, 5]
        ]

        expect { king.generate_moves(board, king.location[0], king.location[1]) }.to change { king.valid_moves }.from([])

        expect(king.valid_moves).to match_array(expected_moves)
      end
    end
  end

  describe '#safe_moves' do
    it 'does not include moves that would put self in check' do
      Rook.new(board, [0, 5], :black)

      expect { king.generate_moves(board, king.location[0], king.location[1]) }.to change { king.valid_moves }.from([])

      expect(king.safe_moves(board).include?([7, 5])).to be false
    end

    context 'when in check' do
      it 'only includes moves that will uncheck self' do
        Rook.new(board, [0, 4], :black)

        expected_moves = [
          [7, 3], [6, 3],
          [6, 5], [7, 5]
        ]

        expect { king.generate_moves(board, king.location[0], king.location[1]) }.to change { king.valid_moves }.from([])

        expect(king.safe_moves(board)).to match_array(expected_moves)
      end
    end

    context 'when capturing opponent will put self in check' do
      it 'does not include capture move' do
        Rook.new(board, [6, 5], :black)
        Rook.new(board, [0, 5], :black)

        expect { king.generate_moves(board, king.location[0], king.location[1]) }.to change { king.valid_moves }.from([])

        expect(king.safe_moves(board).include?([6, 5])).to be false
      end
    end
  end
end
