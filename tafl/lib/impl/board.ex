defmodule Tafl.Impl.Board do
  alias Tafl.Impl.{GameConfiguration, Piece, Space}
  alias Tafl.Type

  @type kind :: :basic
  @type spaces :: %{required(Type.rc_loc()) => Space.t()}

  @type t :: %__MODULE__{
          spaces: spaces(),
          size: integer()
        }

  defstruct(
    spaces: %{},
    size: 11
  )

  @spec new(kind()) :: t()
  def new(kind) do
    board = %__MODULE__{}
    spaces_lists = GameConfiguration.new_game_spaces(kind)
    spaces = coord_map(spaces_lists, board.size)
    %__MODULE__{board | spaces: spaces}
  end

  # TODO spec this out with the game configuration
  def coord_map(spaces_lists, board_size, {row_offset, col_offset} \\ {0, 0}) do
    # provide a coordinate map like %{ {row, col}: Space, ... }
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

  @spec collect_spaces(t(), {Type.rc_loc(), Type.rc_loc()}) :: [Space.t()]
  def collect_spaces(board, {{old_row, old_col}, {new_row, new_col}}) when old_row == new_row do
    [_head | tail] =
      for c <- old_col..new_col do
        Map.get(board.spaces, {old_row, c})
      end

    tail
  end

  def collect_spaces(board, {{old_row, old_col}, {new_row, new_col}}) when old_col == new_col do
    [_head | tail] =
      for r <- old_row..new_row do
        Map.get(board.spaces, {r, old_col})
      end

    tail
  end

  @spec get_space(t(), Type.rc_loc()) :: Space.t()
  def get_space(board, location) do
    Map.get(board.spaces, location)
  end

  @spec get_piece(t(), Type.rc_loc()) :: Piece.t()
  def get_piece(board, location) do
    get_space(board, location)
    |> Space.get_piece()
  end

  @spec place_piece(t(), Type.rc_loc(), Piece.t()) :: t()
  def place_piece(board, location, piece) do
    space = get_space(board, location)
    new_space = Space.place_piece(space, piece)
    new_spaces = Map.put(board.spaces, location, new_space)
    %__MODULE__{board | spaces: new_spaces}
  end

  @spec remove_piece(t(), Type.rc_loc()) :: {t(), Piece.t()}
  def remove_piece(board, location) do
    piece = get_piece(board, location)

    space = get_space(board, location)
    new_space = Space.remove_piece(space)
    new_spaces = place_space(board, location, new_space)
    new_board = %__MODULE__{board | spaces: new_spaces}
    {new_board, piece}
  end

  @spec place_space(t(), Type.rc_loc(), Space.t()) :: spaces()
  def place_space(board, location, new_space) do
    Map.put(board.spaces, location, new_space)
  end
end
