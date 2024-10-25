defmodule TextClient.Impl.Play do
  def start(server_name) do
    # player ids are not important in single-screen play so give them simple identifiers
    # if this step has already been done (re-connected game), this silently continues on
    Tafl.add_player_one(server_name, "1")
    Tafl.add_player_two(server_name, "2")
    render = Tafl.show_board(server_name)
    interact({server_name, render})
  end

  def interact({_server_name, render = %{state: :over}}) do
    IO.puts("Congratulations, #{render_player(render.winner)}. You won!")
  end

  def interact({server_name, render}) do
    IO.puts(IO.ANSI.clear())
    IO.puts("****************************************")
    IO.puts(feedback_for(render))
    IO.puts(current_board(render))
    IO.write("\n\n")
    IO.write(IO.ANSI.cursor_up(2))
    {old_loc, new_loc} = get_move()
    player_id = if render.turn == :p1, do: "1", else: "2"
    render = Tafl.make_move(server_name, old_loc, new_loc, player_id)
    interact({server_name, render})
  end

  ##################################################

  def feedback_for(render = %{state: :waiting}) do
    "It is #{render_player(render.turn)}'s turn."
  end

  def feedback_for(render = %{state: :invalid_move}) do
    "Invalid move: #{render.message}\nIt is #{render_player(render.turn)}'s turn again."
  end

  defp render_player(:p1), do: "Player 1"
  defp render_player(:p2), do: "Player 2"

  def current_board(render) do
    printable_render(render)
  end

  def get_move() do
    from =
      IO.gets("Move from: ")
      |> String.split(",")
      |> Enum.map(&String.trim/1)
      |> Enum.map(&String.to_integer/1)
      |> List.to_tuple()

    to =
      IO.gets("Move to: ")
      |> String.split(",")
      |> Enum.map(&String.trim/1)
      |> Enum.map(&String.to_integer/1)
      |> List.to_tuple()

    {from, to}
  end

  defp printable_render(render) do
    render.spaces
    |> Enum.map(&Enum.join(&1, " "))
    |> Enum.join("\n")
  end
end
