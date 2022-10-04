defmodule Tafl.Impl.Renderer do
  alias Tafl.Impl.Piece

  def render_game(game) when game.state != :over do
    rendered_spaces = render_spaces(game.board)

    %{
      spaces: rendered_spaces,
      state: game.state,
      message: game.message,
      turn: game.turn
    }
  end

  def render_game(game) when game.state == :over do
    rendered_spaces = render_spaces(game.board)

    %{
      spaces: rendered_spaces,
      state: game.state,
      message: game.message,
      winner: game.winner
    }
  end

  def render_spaces(board) do
    for r <- 1..board.size do
      for c <- 1..board.size do
        render_space(Map.get(board.spaces, {r, c}))
      end
    end
  end

  def render_space(space) do
    empty = %Piece{}

    case {space.kind, space.piece} do
      {:corner, ^empty} -> "X"
      {:center, ^empty} -> "X"
      {_, ^empty} -> " "
      {_, piece} -> render_piece(piece)
    end
  end

  def render_piece(piece) do
    case {piece.owner, piece.kind} do
      {:p1, :pawn} -> "+"
      {:p2, :pawn} -> "o"
      {_, :king} -> "K"
      # this would actually mean an error
      {_, _} -> "?"
    end
  end
end
