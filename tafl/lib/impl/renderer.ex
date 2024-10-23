defmodule Tafl.Impl.Renderer do
  alias Tafl.Impl.{Board, Game, Piece, Space}
  alias Tafl.Type

  @type t :: %__MODULE__{
          spaces: list(),
          state: Type.state(),
          message: String.t(),
          turn: Type.player_indicator()
        }

  defstruct(
    spaces: %{},
    state: nil,
    message: "",
    turn: nil,
    winner: nil
  )

  @spec render_game(Game.t()) :: t()
  def render_game(game) when game.state != :over do
    rendered_spaces = render_spaces(game.board)

    %__MODULE__{
      spaces: rendered_spaces,
      state: game.state,
      message: game.message,
      turn: game.turn
    }
  end

  def render_game(game) when game.state == :over do
    rendered_spaces = render_spaces(game.board)

    %__MODULE__{
      spaces: rendered_spaces,
      state: game.state,
      message: game.message,
      winner: game.winner
    }
  end

  @spec render_spaces(Board.t()) :: list(list(String.t()))
  def render_spaces(board) do
    for r <- 1..board.size do
      for c <- 1..board.size do
        render_space(Map.get(board.spaces, {r, c}))
      end
    end
  end

  @spec render_space(Space.t()) :: String.t()
  def render_space(space) do
    case {space.kind, space.piece} do
      {:corner, %{kind: nil}} -> "X"
      {:center, %{kind: nil}} -> "X"
      {_, %{kind: nil}} -> " "
      {_, piece} -> render_piece(piece)
    end
  end

  @spec render_piece(Piece.t()) :: String.t()
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
