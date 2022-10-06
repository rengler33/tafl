defmodule Tafl.Impl.Captures do
  alias Tafl.Impl.{Board, Space, Utils}

  defp directions({r, c}) do
    # left, right, up, down
    [{r, c - 1}, {r, c + 1}, {r - 1, c}, {r + 1, c}]
  end

  def perform_captures(board, player, new_location) do
    directions(new_location)
    |> Enum.map(&check_if_captured(&1, player, board))
    |> IO.inspect(label: "captures (l/r/u/d)")
    |> Enum.reduce(board, &capture(&1, &2))
  end

  defp check_if_captured(check_location, attacker, board) do
    IO.puts("****************")
    IO.puts("checking if captured")

    defender =
      Utils.other_player(attacker)
      |> IO.inspect(label: "defender")

    IO.inspect(attacker, label: "attacker")

    surrounding_spaces =
      check_location
      |> get_surrounding_spaces(board.spaces)

    captured? =
      get_space_from_coord_map(check_location, board.spaces)
      |> IO.inspect(label: "space")
      |> Map.fetch!(:piece)
      |> captured?(defender, surrounding_spaces)

    {check_location, captured?}
  end

  def get_surrounding_spaces(location, coord_map) do
    # left, right, up, down
    # [{r, c - 1}, {r, c + 1}, {r - 1, c}, {r + 1, c}]
    directions(location)
    |> get_spaces_from_coord_map(coord_map)
    |> IO.inspect(label: "surrounding spaces")
  end

  defp get_spaces_from_coord_map(locations, coord_map) do
    locations
    |> Enum.map(&get_space_from_coord_map(&1, coord_map))
  end

  defp get_space_from_coord_map(location, coord_map) do
    Map.get(coord_map, location, %Space{})
  end

  defp captured?(piece, defender, surrounding_spaces)
       when piece.kind == :king and piece.owner == defender do
    attacker = Utils.other_player(defender)

    surrounding_spaces
    |> Enum.map(&space_can_capture?(&1, attacker))
    |> Enum.all?()
  end

  defp captured?(piece, defender, surrounding_spaces)
       when piece.kind != nil and piece.owner == defender do
    attacker = Utils.other_player(defender)
    IO.inspect(piece, label: "checking piece")
    IO.inspect(defender, label: "defender")

    surrounding_spaces
    |> Enum.map(&space_can_capture?(&1, attacker))
    # chunk to horizontal, vertical
    |> Enum.chunk_every(2)
    # check if both sides
    |> Enum.map(&Enum.all?/1)
    # if either horizontal or vertical
    |> IO.inspect(label: "h,v")
    |> Enum.any?()
  end

  defp captured?(_piece, _defender, _surrounding_spaces), do: false

  defp space_can_capture?(space, attacker)
       when space.piece.owner == attacker or space.kind == :corner or space.kind == :center do
    IO.puts("checking if space can capture because attacker present")
    IO.inspect(space)
    IO.puts("attacker: #{attacker}")
    true
  end

  defp space_can_capture?(_, _), do: false

  defp capture({location, captured?}, board) when captured? == true do
    # TODO decide - if capturing king, i don't actually want to capture
    # but do want to return game state over? maybe not, maybe this is better
    IO.inspect(location, label: "CAPTURING")

    {new_board, _piece} =
      board
      |> Board.remove_piece(location)

    new_board
  end

  defp capture(_, board), do: board
end
