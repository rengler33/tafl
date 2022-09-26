defmodule Tafl.Impl.Spaces do
  @board_size 11
  alias Tafl.Impl.Space

  def remove_piece(spaces, location) do
    index_to_update = index_on_flat_board(location)
    piece = get_piece(spaces, location)

    new_spaces =
      spaces
      |> List.flatten()
      |> Enum.with_index()
      |> Enum.map(fn
        {space, ^index_to_update} -> Space.remove_piece(space)
        {space, _} -> space
      end)
      |> Enum.chunk_every(@board_size)

    {new_spaces, piece}
  end

  def get_space(spaces, location) do
    spaces
    |> List.flatten()
    |> Enum.at(index_on_flat_board(location))
  end

  def get_piece(spaces, location) do
    get_space(spaces, location)
    |> Map.get(:piece)
  end

  def place_piece(spaces, location, piece) do
    index_to_update = index_on_flat_board(location)

    spaces
    |> List.flatten()
    |> Enum.with_index()
    |> Enum.map(fn
      {space, ^index_to_update} -> Space.place_piece(space, piece)
      {space, _} -> space
    end)
    |> Enum.chunk_every(@board_size)
  end

  defp index_on_flat_board({1, y}), do: y - 1

  defp index_on_flat_board({x, y}) do
    # when row and colum counts start at 1, e.g. where {2, 3}
    # is second row, third column
    # i.e. 14th space/13th index in flat list
    (x - 1) * @board_size + y - 1
  end

  def collect_spaces(spaces, {{old_row, old_col}, {new_row, new_col}}) when old_row == new_row do
    # collect the spaces between these two locations
    # excluding the "old" space, including the new space
    amount = if old_col <= new_col, do: new_col - old_col, else: old_col - new_col
    leftmost = if old_col <= new_col, do: old_col, else: new_col - 1
    Enum.slice(Enum.at(spaces, old_row - 1), leftmost, amount)
  end

  def collect_spaces(spaces, {{old_row, old_col}, {new_row, new_col}}) when old_col == new_col do
    transpose(spaces)
    |> collect_spaces({{old_col, old_row}, {new_col, new_row}})
  end

  defp transpose(spaces) do
    spaces
    |> Enum.zip()
    |> Enum.map(&Tuple.to_list/1)
  end

  def render_spaces(spaces) do
    spaces
    |> List.flatten()
    |> Enum.map(&Space.render/1)
    |> Enum.chunk_every(@board_size)
  end
end
