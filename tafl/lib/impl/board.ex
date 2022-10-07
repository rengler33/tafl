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
    spaces = GameConfiguration.coord_map(spaces_lists, board.size)
    %__MODULE__{board | spaces: spaces}
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
