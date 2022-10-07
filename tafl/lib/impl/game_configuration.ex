defmodule Tafl.Impl.GameConfiguration do
  alias Tafl.Impl.{Board, Piece, Space}
  alias Tafl.Type

  @spec new_game_spaces(Type.game_type()) :: list(list(Space.t()))
  def new_game_spaces(setup) do
    game_components(setup)
    |> Enum.map(&make_row(&1))
  end

  @spec game_components(Type.game_type()) :: list(list())
  def game_components(:basic) do
    king = Piece.make_piece(:p1, :king)
    pawn1 = Piece.make_piece(:p1, :pawn)
    pawn2 = Piece.make_piece(:p2, :pawn)

    [
      [{:corner, 1}, {:edge, 2}, {:edge, 5, pawn2}, {:edge, 2}, {:corner, 1}],
      [{:edge, 1}, {:basic, 4}, {:basic, 1, pawn2}, {:basic, 4}, {:edge, 1}],
      [{:edge, 1}, {:basic, 9}, {:edge, 1}],
      [{:edge, 1, pawn2}, {:basic, 4}, {:basic, 1, pawn1}, {:basic, 4}, {:edge, 1, pawn2}],
      [{:edge, 1, pawn2}, {:basic, 3}, {:basic, 3, pawn1}, {:basic, 3}, {:edge, 1, pawn2}],
      [
        {:edge, 2, pawn2},
        {:basic, 1},
        {:basic, 2, pawn1},
        {:center, 1, king},
        {:basic, 2, pawn1},
        {:basic, 1},
        {:edge, 2, pawn2}
      ],
      [{:edge, 1, pawn2}, {:basic, 3}, {:basic, 3, pawn1}, {:basic, 3}, {:edge, 1, pawn2}],
      [{:edge, 1, pawn2}, {:basic, 4}, {:basic, 1, pawn1}, {:basic, 4}, {:edge, 1, pawn2}],
      [{:edge, 1}, {:basic, 9}, {:edge, 1}],
      [{:edge, 1}, {:basic, 4}, {:basic, 1, pawn2}, {:basic, 4}, {:edge, 1}],
      [{:corner, 1}, {:edge, 2}, {:edge, 5, pawn2}, {:edge, 2}, {:corner, 1}]
    ]
  end

  @spec make_row(list()) :: list(Space.t())
  defp make_row(components) do
    components
    |> Enum.map(&make_spaces(&1))
    |> List.flatten()
  end

  @spec make_spaces({Space.space_kind(), integer(), Piece.t()}) :: list(Space.t())
  defp make_spaces({kind, quantity}) do
    for _ <- 1..quantity, do: Space.make_space(kind)
  end

  defp make_spaces({kind, quantity, piece}) do
    for _ <- 1..quantity, do: Space.make_space(kind, piece)
  end

  @spec coord_map(list(list()), integer(), Type.rc_loc()) :: Board.spaces()
  def coord_map(spaces_lists, board_size, {row_offset, col_offset} \\ {0, 0}) do
    # provide a row and column offset to make a "relative" map
    # to that location
    coords =
      for r <- (1 - row_offset)..(board_size - row_offset) do
        for c <- (1 - col_offset)..(board_size - col_offset) do
          {r, c}
        end
      end

    Enum.zip(List.flatten(coords), List.flatten(spaces_lists))
    |> Enum.into(%{})
  end
end
