defmodule Tafl.Impl.Game do
  alias Tafl.Impl.{Board, Captures, Player, Rules, Utils, WinConditions}
  alias Tafl.Type

  @type t :: %__MODULE__{
          board: Board.t() | nil,
          turn: Type.player_indicator() | nil,
          state: Type.state(),
          message: String.t(),
          winner: Type.player_indicator() | nil,
          players: %{:p1 => Player.t() | nil, :p2 => Player.t() | nil}
        }

  defstruct(
    board: nil,
    turn: nil,
    state: :initializing,
    message: "",
    winner: nil,
    players: %{p1: nil, p2: nil}
  )

  @spec new() :: t()
  def new() do
    board = Board.new(:basic)
    %__MODULE__{board: board, message: "Waiting for players..."}
  end

  @spec set_player(t(), Type.player_indicator(), String.t()) :: t()
  def set_player(game, indicator, id)
      when game.state == :initializing and indicator in [:p1, :p2] do
    new_player = Player.new(id, indicator)
    players = Map.put(game.players, indicator, new_player)

    {state, turn, message} =
      case not is_nil(players.p1) and not is_nil(players.p2) do
        true -> {:waiting, :p2, "Game is started."}
        false -> {game.state, game.turn, "Player added."}
      end

    %__MODULE__{game | players: players, state: state, turn: turn, message: message}
  end

  def set_player(game, _indicator, _id) when game.state != :initializing do
    %__MODULE__{game | message: "The game is already started."}
  end

  def set_player(game, indicator, id) do
    %__MODULE__{game | message: "Unable to add player with #{indicator} and id #{id}"}
  end

  @spec make_move(t(), Type.rc_loc(), Type.rc_loc(), String.t()) :: t()
  def make_move(game, _old_location, _new_location, _player_id) when game.winner != nil do
    %__MODULE__{game | message: "The game is already over."}
  end

  def make_move(game, old_location, new_location, player_id) do
    move = {old_location, new_location}

    with true <- players_turn?(game, player_id),
         {true, _} <- valid_move?(game, move) do
      accept_move(game, move)
      |> perform_captures(new_location)
      |> evaluate_win()
      |> alternate_turn()
    else
      false -> %__MODULE__{game | state: :invalid_move, message: "Not player's turn."}
      {false, msg} -> %__MODULE__{game | state: :invalid_move, message: msg}
    end
  end

  #########################################

  defp players_turn?(game, player_id) do
    player_id == Map.get(game.players, game.turn).id
  end

  @spec valid_move?(t(), Type.move()) :: {boolean(), String.t()}
  defp valid_move?(game, move) do
    {res, msg} = Rules.bad_move(game, move)
    {!res, msg}
  end

  @spec accept_move(t(), Type.move()) :: t()
  defp accept_move(game, {old_location, new_location}) do
    new_game = move_piece(game, old_location, new_location)
    %__MODULE__{new_game | state: :waiting, message: ""}
  end

  @spec move_piece(t(), Type.rc_loc(), Type.rc_loc()) :: t()
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

  @spec do_evaluate_win(t(), {boolean(), Type.player_indicator()}) :: t()
  defp do_evaluate_win(game, {winner, player}) when winner == true do
    %__MODULE__{
      game
      | state: :over,
        winner: player,
        message: "Congratulations #{player}, you win!"
    }
  end

  defp do_evaluate_win(game, _no_winner), do: game

  @spec winner?(t()) :: {boolean(), Type.player_indicator()}
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
