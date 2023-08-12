# frozen_string_literal: true

# contains logic to handle determing score per player
module ScoreCalculator
  def score(color)
    calculate_score(color)
  end

  private

  def calculate_score(color)
    pieces = find_pieces(color)

    calculate_check_score(color) + calculate_piece_difference(pieces, color) +
      calculate_piece_score(pieces)
  end

  def calculate_piece_difference(pieces, color)
    opponent_color = color == :white ? :black : :white
    opponent_pieces = find_pieces(opponent_color)
    (pieces.size - opponent_pieces.size) * 1.5
  end

  def calculate_piece_score(pieces)
    scores = pieces.map do |p|
      pawn_path_score = open_pawn_path?(p) ? 1 : 0

      p.score_map[p.location[0]][p.location[1]] + p.value + pawn_path_score
    end

    scores.sum
  end

  def calculate_check_score(color)
    opponent_color = color == :white ? :black : :white

    if in_check?(opponent_color)
      6
    elsif checkmate?(opponent_color)
      20
    end

    0
  end

  def open_pawn_path?(piece)
    return unless piece.instance_of?(Pawn)

    left_file = piece.location[1] - 1
    right_file = piece.location[1] + 1

    check_pawn_path(left_file, right_file, piece)
  end

  def check_pawn_path(left_file, right_file, piece)
    (left_file..right_file).all? do |file|
      next unless file.between?(0, 7)

      rank = piece.location[0]

      until [0, 7].include?(rank)
        rank += piece.direction

        return false unless data[rank][file].nil?
      end
    end
  end
end
