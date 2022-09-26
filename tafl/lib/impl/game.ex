defmodule Tafl.Impl.Game do
  defstruct(
    spaces: [],
    turn: nil,
    # initializing, waiting, over, invalid_move
    state: :initializing,
    message: "",
    winner: nil
  )

  alias Tafl.Impl.{Spaces, GameConfiguration, Rules, WinConditions}

  def new() do
    spaces = GameConfiguration.new_game_spaces(:basic)
    %__MODULE__{spaces: spaces, turn: :p2, state: :waiting}
  end

  def make_move(game, _old_location, _new_location) when game.winner != nil do
    %__MODULE__{game | message: "The game is already over."}
  end

  def make_move(game, old_location, new_location) do
    move = {old_location, new_location}
    game = accept_move(game, move, valid_move?(game, move))
    evaluate_win(game, winner?(game))
  end

  def render(game) when game.state != :over do
    rendered_spaces = Spaces.render_spaces(game.spaces)

    %{
      spaces: rendered_spaces,
      state: game.state,
      message: game.message,
      turn: game.turn
    }
  end

  def render(game) when game.state == :over do
    rendered_spaces = Spaces.render_spaces(game.spaces)

    %{
      spaces: rendered_spaces,
      state: game.state,
      message: game.message,
      winner: game.winner
    }
  end

  #########################################

  defp valid_move?(game, move) do
    {res, msg} = Rules.bad_move(game, move)
    {!res, msg}
  end

  defp accept_move(game, {old_location, new_location}, {_valid = true, _msg}) do
    new_game = move_piece(game, old_location, new_location)
    %__MODULE__{new_game | state: :waiting, turn: alternate_turn(game.turn), message: ""}
  end

  defp accept_move(game, _, {_valid = false, msg}) do
    %__MODULE__{game | state: :invalid_move, message: msg}
  end

  defp move_piece(game, old_location, new_location) do
    {spaces, piece} = Spaces.remove_piece(game.spaces, old_location)
    new_spaces = Spaces.place_piece(spaces, new_location, piece)
    %__MODULE__{game | spaces: new_spaces}
  end

  defp alternate_turn(:p1), do: :p2
  defp alternate_turn(:p2), do: :p1

  #########################################

  defp evaluate_win(game, {_winner = true, player}) do
    %__MODULE__{
      game
      | state: :over,
        winner: player,
        message: "Congratulations #{player}, you win!",
        turn: nil
    }
  end

  defp evaluate_win(game, _no_winner), do: game

  defp winner?(game) do
    WinConditions.check(game)
  end
end
