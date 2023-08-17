require_relative '../lib/pieces/pieces'

RSpec.describe Knight do
  let(:board) { Board.new }
  subject(:knight) { Knight.new(board, [3, 3], :white) }

  describe '#generate_moves' do
    before do
      knight.instance_variable_set(:@valid_moves, [])
    end

    context 'with no other pieces in range' do
      it 'correctly updates @valid_moves' do
        expected_moves = [
          [1, 2], [1, 4],
          [2, 1], [2, 5],
          [4, 1], [4, 5],
          [5, 2], [5, 4]
        ]

        expect { knight.generate_moves(board, 3, 3) }.to change { knight.valid_moves }.from([])

        expect(knight.valid_moves).to match_array(expected_moves)
      end
    end

    context 'with ally piece in range' do
      it 'does not add ally square to @valid_moves' do
        Knight.new(board, [2, 1], :white)
        expect { knight.generate_moves(board, 3, 3) }.to change { knight.valid_moves }.from([])

        expect(knight.valid_moves.include?([2, 1])).to be false
      end
    end

    context 'with opponent piece in range' do
      it 'adds opponent square to @valid_moves' do
        Knight.new(board, [4, 5], :black)
        expect { knight.generate_moves(board, 3, 3) }.to change { knight.valid_moves }.from([])

        expect(knight.valid_moves.include?([4, 5])).to be true
      end
    end
  end

  describe '#safe_moves' do
    context 'when protecting king' do
      it 'does not include moves that will put king in check' do
        King.new(board, [5, 3], :white)
        Rook.new(board, [0, 3], :black)

        knight.generate_moves(board, knight.location[0], knight.location[1])

        expect(knight.safe_moves(board)).to be_empty
      end
    end

    context 'when king is in check' do
      it 'only includes moves that will take king out of check' do
        King.new(board, [7, 5], :white)
        Rook.new(board, [0, 5], :black)

        knight.generate_moves(board, knight.location[0], knight.location[1])

        expected_moves = [
          [2, 5], [4, 5]
        ]

        expect(knight.safe_moves(board)).to match_array(expected_moves)
      end
    end
  end
end
