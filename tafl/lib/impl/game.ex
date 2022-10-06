defmodule Tafl.Impl.Game do
  alias Tafl.Impl.{Board, Captures, Rules, Utils, WinConditions}
  alias Tafl.Type

  @type t :: %__MODULE__{
          board: Board.t(),
          turn: Type.player(),
          state: Type.state(),
          message: String.t(),
          winner: Type.player() | nil
        }

  defstruct(
    board: nil,
    turn: nil,
    state: :initializing,
    message: "",
    winner: nil
  )

  @spec new() :: t()
  def new() do
    board = Board.new(:basic)
    %__MODULE__{board: board, turn: :p2, state: :waiting}
  end

  @spec make_move(t(), Type.rc_loc(), Type.rc_loc()) :: t()
  def make_move(game, _old_location, _new_location) when game.winner != nil do
    %__MODULE__{game | message: "The game is already over."}
  end

  def make_move(game, old_location, new_location) do
    move = {old_location, new_location}

    accept_move(game, move, valid_move?(game, move))
    |> perform_captures(new_location)
    |> evaluate_win()
    |> alternate_turn()
  end

  #########################################

  @spec valid_move?(t(), Type.rc_loc()) :: {boolean(), String.t()}
  defp valid_move?(game, move) do
    {res, msg} = Rules.bad_move(game, move)
    {!res, msg}
  end

  # @spec accept_move(t(), {Type.rc_loc(), Type.rc_loc()}, {boolean(), String.t()}) :: t()
  defp accept_move(game, {old_location, new_location}, {_valid = true, _msg}) do
    new_game = move_piece(game, old_location, new_location)
    %__MODULE__{new_game | state: :waiting, message: ""}
  end

  defp accept_move(game, _, {_valid = false, msg}) do
    %__MODULE__{game | state: :invalid_move, message: msg}
  end

  # @spec move_piece(t(), Type.rc_loc(), rc_loc()) :: t()
  defp move_piece(game, old_location, new_location) do
    {board, piece} = Board.remove_piece(game.board, old_location)
    new_board = Board.place_piece(board, new_location, piece)
    %__MODULE__{game | board: new_board}
  end

  #########################################

  @spec perform_captures(t(), Type.rc_loc()) :: t()
  defp perform_captures(game, new_location) do
    new_board = Captures.perform_captures(game.board, game.turn, new_location)
    %__MODULE__{game | board: new_board}
  end

  @spec evaluate_win(t()) :: t()
  defp evaluate_win(game) do
    do_evaluate_win(game, winner?(game))
  end

  @spec do_evaluate_win(t(), {boolean(), Type.player()}) :: t()
  defp do_evaluate_win(game, {winner, player}) when winner == true do
    %__MODULE__{
      game
      | state: :over,
        winner: player,
        message: "Congratulations #{player}, you win!"
    }
  end

  defp do_evaluate_win(game, _no_winner), do: game

  @spec winner?(t()) :: {boolean(), Type.player()}
  defp winner?(game) do
    WinConditions.check(game)
  end

  #########################################

  @spec alternate_turn(t()) :: t()
  defp alternate_turn(game) when game.state not in [:invalid_move, :over] do
    %__MODULE__{game | turn: Utils.other_player(game.turn)}
  end

  defp alternate_turn(game), do: game
end
