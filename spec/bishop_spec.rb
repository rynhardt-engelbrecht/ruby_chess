require_relative '../lib/pieces/pieces'

RSpec.describe Bishop do
  let(:board) { Board.new }
  subject(:bishop) { Bishop.new(board, [3, 3], :white) }

  describe '#generate_moves' do
    context 'with no nearby pieces' do
      it 'correctly updates @valid_moves' do
        expected_moves = [
          [4, 4], [5, 5], [6, 6], [7, 7],
          [2, 4], [1, 5], [0, 6],
          [4, 2], [5, 1], [6, 0],
          [2, 2], [1, 1], [0, 0]
        ]

        expect { bishop.generate_moves(board, 3, 3) }.to change { bishop.valid_moves }.from([])

        expect(bishop.valid_moves).to match_array(expected_moves)
      end
    end

    context 'when ally piece is in the way' do
      before do
        Bishop.new(board, [5, 5], :white)
        bishop.instance_variable_set(:@valid_moves, [])
      end

      it 'does not include ally position or squares past ally' do
        expect { bishop.generate_moves(board, 3, 3) }.to change { bishop.valid_moves }.from([])

        expect(bishop.valid_moves.any? { |move| [[5, 5], [6, 6], [7, 7]].include?(move) }).to be false
      end
    end

    context 'when opponent piece is in the way' do
      before do
        Bishop.new(board, [2, 4], :black)
        bishop.instance_variable_set(:@valid_moves, [])
      end

      it 'includes opponent position, but not any squares past the opponent' do
        expect { bishop.generate_moves(board, 3, 3) }.to change { bishop.valid_moves }.from([])

        expect(bishop.valid_moves.any? { |move| [[1, 4], [0, 5]].include?(move) }).to be false
        expect(bishop.valid_moves.include?([2, 4])).to be true
      end
    end
  end

  describe '#safe_moves' do
    subject(:bishop_safe) { Bishop.new(board, [3, 3], :white) }

    context 'when blocking path to king' do
      before do
        Bishop.new(board, [1, 1], :black)
        King.new(board, [4, 4], :white)

        bishop_safe.update(board)
      end

      it 'does not include moves that would put the king in check' do
        bad_moves = [
          [5, 5], [6, 6], [7, 7],
          [2, 4], [1, 5], [0, 6],
          [4, 2], [5, 1], [6, 0]
        ]

        expect(bishop_safe.valid_moves).to_not be_empty # ensure that the valid moves array isn't just empty, which
        # would also cause the below test to pass

        expect(bishop_safe.safe_moves(board).any? { |move| bad_moves.include?(move) }).to be false
      end
    end

    context 'when own king is in check' do
      before do
        Bishop.new(board, [3, 7], :black)
        King.new(board, [6, 4], :white)

        bishop_safe.update(board)
      end

      it 'only includes moves that will uncheck own king' do
        good_moves = [
          [5, 5]
        ]

        expect(bishop_safe.valid_moves).to_not be_empty

        expect(bishop_safe.safe_moves(board)).to match_array(good_moves)
      end
    end
  end
end
