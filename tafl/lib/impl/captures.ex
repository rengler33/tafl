defmodule Tafl.Impl.Captures do
  alias Tafl.Impl.{Piece, Space, Spaces}

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

  defp other_player(:p1), do: :p2
  defp other_player(:p2), do: :p1
end
