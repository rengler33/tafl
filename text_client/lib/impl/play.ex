defmodule TextClient.Impl.Play do
  def start(game) do
    render = Tafl.show_board(game)
    interact({game, render})
  end

  def interact({_game, render = %{state: :over}}) do
    IO.puts("Congratulations, #{render_player(render.winner)}. You won!")
  end

  def interact({game, render}) do
    IO.puts(IO.ANSI.clear())
    IO.puts("****************************************")
    IO.puts(feedback_for(render))
    IO.puts(current_board(render))
    IO.write("\n\n")
    IO.write(IO.ANSI.cursor_up(2))
    {old_loc, new_loc} = get_move()
    render = Tafl.make_move(game, old_loc, new_loc)
    interact({game, render})
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
