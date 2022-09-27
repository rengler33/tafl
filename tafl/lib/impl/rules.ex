defmodule Tafl.Impl.Rules do
  alias Tafl.Impl.{Piece, Spaces}

  def bad_move(game, move) do
    checks = [
      &is_not_moving/2,
      &is_moving_off_the_board/2,
      &is_not_moving_within_row_or_column/2,
      # everything after here is related to the piece(s)
      &is_trying_to_move_from_a_space_without_a_piece/2,
      &is_not_players_turn/2,
      &is_stopping_on_hostile_square_when_not_king/2,
      &is_trying_to_move_through_other_pieces/2
    ]

    check_bad_move(checks, game, move)
  end

  defp check_bad_move([], _game, _move) do
    {false, ""}
  end

  defp check_bad_move([check_fn | tail], game, move) do
    case check_fn.(game, move) do
      {true, message} -> {true, message}
      _ -> check_bad_move(tail, game, move)
    end
  end

  #########################################
  # The function name should describe something wrong to do
  # and return true if wrong thing was done

  defp is_not_moving(_, {old_loc, new_loc}) do
    msg = "You cannot move to the same space you are on."
    res = old_loc == new_loc
    {res, msg}
  end

  defp is_moving_off_the_board(game, {_, {newx, newy}}) do
    msg = "You cannot move off the board."
    res = newx > Enum.count(List.first(game.spaces)) or newy > Enum.count(game.spaces)
    {res, msg}
  end

  defp is_not_moving_within_row_or_column(_, {{oldx, oldy}, {newx, newy}}) do
    msg = "You must move within the row or column."
    res = oldx != newx and oldy != newy
    {res, msg}
  end

  defp is_trying_to_move_from_a_space_without_a_piece(game, {old_loc, _}) do
    msg = "You cannot move a piece from an empty space."
    piece = Spaces.get_piece(game.spaces, old_loc)
    res = piece == %Piece{}
    {res, msg}
  end

  defp is_not_players_turn(game, {old_location, _}) do
    msg = "That piece cannot be moved by you."
    piece = Spaces.get_piece(game.spaces, old_location)
    res = game.turn != piece.owner
    {res, msg}
  end

  defp is_stopping_on_hostile_square_when_not_king(game, {old_loc, new_loc}) do
    msg = "You cannot stop on hostile square if not king."
    old_piece = Spaces.get_piece(game.spaces, old_loc)
    new_space = Spaces.get_space(game.spaces, new_loc)
    res = old_piece.kind != :king and new_space.kind in [:corner, :center]
    {res, msg}
  end

  defp is_trying_to_move_through_other_pieces(game, move) do
    msg = "You cannot move through or stop on another piece."

    res =
      Spaces.collect_spaces(game.spaces, move)
      |> Enum.any?(fn space -> space.piece != %Piece{} end)

    {res, msg}
  end
end
