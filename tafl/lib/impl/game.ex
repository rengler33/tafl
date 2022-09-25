defmodule Tafl.Impl.Game do
  # makes iex less messy by showing less info
  @derive {Inspect, only: [:turn, :state, :message]}

  defstruct(
    spaces: nil,
    turn: nil,
    # waiting, over, invalid_move
    state: :initializing,
    message: ""
  )

  alias Tafl.Impl.{Space, Spaces, GameConfiguration, Rules}

  @board_size 11

  def new() do
    spaces = GameConfiguration.new_game_spaces(:basic)
    %__MODULE__{spaces: spaces, turn: :p2, state: :waiting}
  end

  def make_move(game, old_location, new_location) do
    move = {old_location, new_location}
    accept_move(game, move, valid_move?(game, move))
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

  # TODO these things need to eventually move to a proper text client
  def print(game) do
    IO.puts("\n")
    IO.puts(game.state)
    IO.puts(game.turn)
    IO.puts(game.message)
    IO.puts("\n")

    render(game)
    |> Enum.map(&Enum.join(&1, " "))
    |> Enum.join("\n")
    |> IO.puts()
  end

  defp render(game) do
    game.spaces
    |> List.flatten()
    |> Enum.map(&Space.render/1)
    |> Enum.chunk_every(@board_size)
  end
end
