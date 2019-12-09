defmodule Validations do
  def check_queens_positions_differ(args) do
    if Enum.at(args, 0) != Enum.at(args, 2) || Enum.at(args, 1) != Enum.at(args, 3) do
        :ok
    else
        {:error, :same_position}
    end
  end

  def check_queens_positions(args) do
    if Enum.max(args)<=7 && Enum.min(args)>=0 do
        :ok
    else
        {:error, :out_of_board}
    end
  end
end

defmodule Game do
  def create_empty_board() do
    board = List.duplicate("_", 8) ++ ["\n"]
    board = List.duplicate(board, 8)
  end

  def insert_figure(board,figure) do
    List.update_at(board, figure.position_y, fn row ->
      List.replace_at(row, figure.position_x, figure.name)
    end)
  end

  def check(figure1, figure2) do
    if figure1.position_x == figure2.position_x || figure1.position_y == figure2.position_y ||
         abs(figure1.position_x - figure2.position_x) ==
           abs(figure1.position_y - figure2.position_y) do
      IO.puts("yes, they can attack each other")
    else
      IO.puts("no, they can't attack each other")
    end
  end
end

terminal_arguments_list = Enum.map(String.split(Enum.at(System.argv(), 0), ","), fn x -> String.to_integer(x) end)

with :ok <- Validations.check_queens_positions(terminal_arguments_list),
    :ok <- Validations.check_queens_positions_differ(terminal_arguments_list) do
  white = %{
    position_x: Enum.at(terminal_arguments_list, 0),
    position_y: Enum.at(terminal_arguments_list, 1),
    name: "W"
  }

 black = %{
    position_x: Enum.at(terminal_arguments_list, 2),
    position_y: Enum.at(terminal_arguments_list, 3),
    name: "B"
  }
board = Game.create_empty_board()
  |> Game.insert_figure(white)
  |> Game.insert_figure(black)

  IO.puts(board)
  Game.check(white, black)

else 
    {:error, :same_position} -> IO.puts("Wrong positions: queens can't be both in the same place.")
    {:error, :out_of_board} -> IO.puts("Cannot place the queen outside the board (8x8)")
end

