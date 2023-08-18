require_relative '../lib/pieces/pieces'

RSpec.describe Pawn do
  let(:board) { Board.new }

  describe '#pending_promotion?' do
    context 'when ineligible for promotion' do
      subject(:pawn_no_promotion) { Pawn.new(board, [1, 0], :white, moved: true) }

      it 'returns false' do
        pawn_no_promotion.update(board)

        expect(pawn_no_promotion.pending_promotion?).to be false
      end
    end

    context 'when eligible for promotion' do
      subject(:pawn_promotion) { Pawn.new(board, [0, 0], :white, moved: true) }

      it 'returns true' do
        pawn_promotion.update(board)

        expect(pawn_promotion.pending_promotion?).to be true
      end
    end
  end

  describe '#en_passant?' do
    context 'when last played move is not a pawn' do
      subject(:pawn_not_last_move) { Pawn.new(board, [3, 0], :white, moved: true) }

      before do
        Bishop.new(board, [0, 4], :black)
        board.move_piece([0, 4], [3, 1])

        board.send(:changed_and_notify)
      end

      it 'returns false' do
        expect(pawn_not_last_move.en_passant?(board, 2, 1)).to be false
      end
    end

    context 'when last move is a pawn, but did not move two squares' do
      subject(:pawn_last_move) { Pawn.new(board, [3, 0], :white, moved: true) }

      before do
        Pawn.new(board, [1, 1], :black)
        board.move_piece([1, 1], [2, 1])

        board.send(:changed_and_notify)
      end

      it 'returns false' do
        expect(pawn_last_move.en_passant?(board, 2, 1)).to be false
      end
    end

    context 'when last move is a pawn, and did move two squares' do
      subject(:pawn_last_move_two_squares) { Pawn.new(board, [3, 0], :white, moved: true) }

      before do
        Pawn.new(board, [1, 1], :black)
        board.move_piece([1, 1], [3, 1])

        board.send(:changed_and_notify)
      end

      it 'returns true' do
        expect(pawn_last_move_two_squares.en_passant?(board, 2, 1)).to be true
      end
    end
  end

  describe '#generate_moves' do
    context 'when pawn has not moved' do
      subject(:unmoved_pawn) { Pawn.new(board, [6, 0], :white) }

      it 'adds 2 square move to @valid_moves' do
        expect { unmoved_pawn.generate_moves(board, 6, 0) }.to change { unmoved_pawn.valid_moves }.from([])

        expect(unmoved_pawn.valid_moves.include?([4, 0])).to be true
      end

      context 'when opponent piece is in capture range' do
        subject(:unmoved_pawn_capture) { Pawn.new(board, [1, 0], :black) }

        it 'adds capture square to @valid_moves' do
          Pawn.new(board, [2, 1], :white)
          expect { unmoved_pawn_capture.generate_moves(board, 1, 0) }.to change { unmoved_pawn_capture.valid_moves }.from([])

          expect(unmoved_pawn_capture.valid_moves.size).to eql(3)
        end
      end
    end

    context 'when pawn has moved' do
      subject(:moved_pawn) { Pawn.new(board, [5, 0], :white, moved: true) }

      it 'does not add 2 square move to @valid_moves' do
        expect { moved_pawn.generate_moves(board, 5, 0) }.to change { moved_pawn.valid_moves }.from([])

        expect(moved_pawn.valid_moves.size).to eql(1)
      end

      context 'when opponent piece is in capture range' do
        subject(:moved_pawn_capture) { Pawn.new(board, [2, 0], :black, moved: true) }

        it 'adds capture square to @valid_moves' do
          Pawn.new(board, [3, 1], :white)
          expect { moved_pawn_capture.generate_moves(board, 2, 0) }.to change { moved_pawn_capture.valid_moves }.from([])

          expect(moved_pawn_capture.valid_moves.include?([3, 1])).to be true
        end
      end
    end

    context 'when #en_passant? returns true' do
      subject(:pawn_en_passant) { Pawn.new(board, [4, 0], :white) }

      before do
        allow(pawn_en_passant).to receive(:en_passant?).and_return(true)
      end

      it 'correctly adds en passant square to @valid_moves' do
        Pawn.new(board, [4, 1], :black, moved: true)
        expect { pawn_en_passant.generate_moves(board, 4, 0) }.to change { pawn_en_passant.valid_moves }.from([])

        expect(pawn_en_passant.valid_moves.include?([3, 1])).to be true
      end
    end
  end
end
