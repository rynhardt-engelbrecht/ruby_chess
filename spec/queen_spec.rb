require_relative '../lib/pieces/pieces'

RSpec.describe Queen do
  let(:board) { Board.new }

  describe '#generate_moves' do
    context 'with no nearby pieces' do
      subject(:queen_valid_moves) { Queen.new(board, [3, 3], :white) }

      it 'correctly updates @valid_moves' do
        expected_moves = [
          [3, 2], [3, 1], [3, 0], [3, 4],
          [3, 5], [3, 6], [3, 7], [2, 3],
          [1, 3], [0, 3], [4, 3], [5, 3],
          [6, 3], [7, 3], [2, 2], [1, 1],
          [0, 0], [2, 4], [1, 5], [0, 6],
          [4, 2], [5, 1], [6, 0], [4, 4],
          [5, 5], [6, 6], [7, 7]
        ]

        expect { queen_valid_moves.generate_moves(board, 3, 3) }.to change { queen_valid_moves.valid_moves }.from([])

        expect(queen_valid_moves.valid_moves).to match_array(expected_moves)
      end
    end

    context 'when ally piece is in the way' do
      subject(:queen_blocked_ally) { Queen.new(board, [0, 0], :white) }

      before do
        King.new(board, [0, 4], :white)
      end

      it 'does not add ally square to @valid_moves' do
        expect { queen_blocked_ally.generate_moves(board, 0, 0) }.to change { queen_blocked_ally.valid_moves }.from([])

        expect(queen_blocked_ally.valid_moves.include?([0, 4])).to be false
      end

      it 'does not add squares past ally to @valid_moves' do
        bad_moves = [
          [0, 5], [0, 6], [0, 7]
        ]

        expect(queen_blocked_ally.valid_moves.intersect?(bad_moves)).to be false
      end
    end

    context 'when opponent piece is in the way' do
      subject(:queen_blocked_opponent) { Queen.new(board, [0, 0], :white) }

      before do
        Rook.new(board, [0, 4], :black)
      end

      it 'does add opponent square to @valid_moves' do
        expect { queen_blocked_opponent.generate_moves(board, 0, 0) }.to change { queen_blocked_opponent.valid_moves }.from([])

        expect(queen_blocked_opponent.valid_moves.include?([0, 4])).to be true
      end

      it 'does not add squares past opponent to @valid_moves' do
        bad_moves = [
          [0, 5], [0, 6], [0, 7]
        ]

        expect(queen_blocked_opponent.valid_moves.intersect?(bad_moves)).to be false
      end
    end

    describe '#safe_moves' do
      context 'when protecting king' do
        subject(:queen_protecting) { Queen.new(board, [0, 3], :white) }

        before do
          King.new(board, [0, 0], :white)
          Rook.new(board, [0, 7], :black)

          board.send(:changed_and_notify)
          queen_protecting.update(board)
        end

        it 'does not include moves that would put king in check' do
          bad_moves = [
            [1, 3], [2, 3], [3, 3],
            [4, 3], [5, 3], [6, 3],
            [7, 3], [1, 2], [2, 1],
            [3, 0], [1, 4], [1, 5],
            [1, 6], [1, 7]
          ]

          expect(queen_protecting.valid_moves).to_not be_empty

          expect(queen_protecting.safe_moves(board).intersect?(bad_moves)).to be false
        end
      end
    end

    context 'when own king is in check' do
      subject(:queen_checked_king) { Queen.new(board, [7, 3], :black) }

      before do
        King.new(board, [0, 0], :black)
        Rook.new(board, [0, 7], :white)

        board.send(:changed_and_notify)
        queen_checked_king.update(board)
      end

      it 'only includes moves that would take king out of check' do
        good_moves = [
          [0, 3]
        ]

        expect(queen_checked_king.valid_moves).to_not be_empty

        expect(queen_checked_king.safe_moves(board)).to match_array(good_moves)
      end
    end
  end
end
