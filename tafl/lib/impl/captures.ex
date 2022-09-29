defmodule Tafl.Impl.Captures do
  alias Tafl.Impl.{Piece, Space, Spaces}

  def perform_captures3(spaces, player, new_location) do
    coord_map = Spaces.coord_map(spaces, new_location)
    # left, right, up, down
    [{0, -1}, {0, 1}, {-1, 0}, {1, 0}]
    |> Enum.map(&check_if_captured(&1, player, coord_map))
    |> IO.inspect(label: "captures (l/r/u/d)")
    |> Enum.reduce(spaces, &capture(&1, &2, new_location))
  end

  defp check_if_captured(check_location, attacker, coord_map) do
    IO.puts("****************")
    IO.puts("checking if captured")

    defender =
      other_player(attacker)
      |> IO.inspect(label: "defender")

    IO.inspect(attacker, label: "attacker")

    surrounding_spaces =
      check_location
      |> get_surrounding_spaces(coord_map)

    captured? =
      get_space_from_coord_map(check_location, coord_map)
      |> IO.inspect(label: "piece")
      |> Map.fetch!(:piece)
      |> captured?(defender, surrounding_spaces)

    {check_location, captured?}
  end

  def get_surrounding_spaces({r, c}, coord_map) do
    # left, right, up, down
    [{r, c - 1}, {r, c + 1}, {r - 1, c}, {r + 1, c}]
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
    attacker = other_player(defender)

    surrounding_spaces
    |> Enum.map(&space_can_capture?(&1, attacker))
    |> Enum.all?()
  end

  defp captured?(piece, defender, surrounding_spaces)
       when piece.kind != nil and piece.owner == defender do
    attacker = other_player(defender)
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

  defp space_can_capture?(space, attacker) when space.piece.owner == attacker do
    IO.puts("checking if space can capture because attacker present")
    IO.inspect(space)
    IO.puts("attacker: #{attacker}")
    space.kind == :corner or space.kind == :center or space.piece.kind != nil
  end

  defp space_can_capture?(_, _), do: false

  defp capture({{r_rel, c_rel}, captured?}, spaces, {r, c}) when captured? == true do
    location = {r_rel + r, c_rel + c}
    IO.inspect(location, label: "CAPTURING")

    {new_spaces, _piece} =
      spaces
      |> Spaces.remove_piece(location)

    new_spaces
  end

  defp capture(_, spaces, _) do
    spaces
  end

  # def perform_captures2(spaces, player, new_location) do
  #   x = Spaces.index_on_flat_board(new_location)
  #   b = Spaces.board_size()

  #   chunks_flat =
  #     [
  #       # up, left, right, down
  #       [x - 2 * b, x - b, x],
  #       [x - 2, x - 1, x],
  #       [x, x + 1, x + 2],
  #       [x, x + b, x + 2 * b]
  #     ]
  #     # drop any chunks that contain a negative number
  #     |> Enum.map(fn values ->
  #       if Enum.any?(values, fn val -> val < 0 end), do: [], else: values
  #     end)
  #     |> IO.inspect()
  #     |> List.flatten()

  #   chunk_set = MapSet.new(chunks_flat)
  #   IO.inspect(chunk_set)

  #   pieces =
  #     spaces
  #     |> List.flatten()
  #     |> Enum.with_index()
  #     |> Enum.filter(fn {_, ind} -> ind in chunk_set end)
  #     |> Enum.map(fn {val, ind} -> {ind, val} end)
  #     |> Map.new()

  #   IO.inspect(pieces)

  #   chunks =
  #     chunks_flat
  #     |> Enum.map(fn val -> {val, pieces[val]} end)
  #     |> Enum.chunk_every(3)

  #   IO.inspect(chunks)
  #   spaces

  # using index counts on a flattened spaces:
  # get 2 upper spaces, 2 left spaces, 2 right spaces, & 2 lower spaces
  # (dropping any negative index values)
  # upper and lower calculations can use a multiple of board_size
  # then check each chunk for a capture
  # then replace each space at the capture index with null piece, if captured
  # then chunk flattened list back into rows

  # nevermind, this is incomplete - my formula sucks because a right edge
  # piece plus two actually gives a piece from next row when dealing with
  # flattened list structure

  # might as well just be a little inefficient and use the collect_spaces
  # functions i already have (just need to make the option to being inclusive
  # of the original space, + 2 spaces on each side)
  # end

  def perform_captures(spaces, player) do
    spaces_after_horizontal_capture =
      spaces
      |> Enum.map(&perform_row_captures(&1, player))

    spaces_after_vertical_capture_too =
      spaces_after_horizontal_capture
      |> Spaces.transpose()
      |> Enum.map(&perform_row_captures(&1, player))
      |> Spaces.transpose()

    spaces_after_vertical_capture_too
  end

  def perform_row_captures(row, player) do
    middle_values =
      row
      |> Enum.chunk_every(3, 1, :discard)
      |> Enum.map(&do_capture_on_chunk(&1, player))
      # unchunk by taking the middle (updated) spaces
      |> Enum.map(&Enum.at(&1, 1))
      |> List.flatten()

    # add back the first and last space
    [Enum.at(row, 0), middle_values, List.last(row)] |> List.flatten()
  end

  defp do_capture_on_chunk(chunk, player) do
    other_player = other_player(player)

    case chunk do
      [
        s1 = %{kind: :corner},
        s2 = %{piece: %{owner: ^other_player}},
        s3 = %{piece: %{owner: ^player}}
      ] ->
        [s1, capture_piece(s2), s3]

      [
        s1 = %{piece: %{owner: ^player}},
        s2 = %{piece: %{owner: ^other_player}},
        s3 = %{piece: %{owner: ^player}}
      ] ->
        [s1, capture_piece(s2), s3]

      [
        s1 = %{piece: %{owner: ^player}},
        s2 = %{piece: %{owner: ^other_player}},
        s3 = %{kind: :corner}
      ] ->
        [s1, capture_piece(s2), s3]

      [
        s1 = %{piece: %{owner: ^player}},
        s2 = %{piece: %{owner: ^other_player}},
        s3 = %{kind: :center}
      ] ->
        [s1, capture_piece(s2), s3]

      [
        s1 = %{kind: :center},
        s2 = %{piece: %{owner: ^other_player}},
        s3 = %{piece: %{owner: ^player}}
      ] ->
        [s1, capture_piece(s2), s3]

      _ ->
        chunk
    end
  end

  defp capture_piece(space) do
    case space.piece.kind do
      # king is uncapturable (signals end of game win condition)
      :king -> space
      _ -> %Space{space | piece: %Piece{}}
    end
  end

  # TODO refactor, copying from Game
  defp other_player(:p1), do: :p2
  defp other_player(:p2), do: :p1
end
