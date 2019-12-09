defmodule BracketsBalance do
  @brackets %{
    "{" => "}",
    "(" => ")",
    "[" => "]"
  }

  def add_to_stack([], []), do: :ok
  def add_to_stack(_, []), do: :error

  def add_to_stack(stack, [current_symbol | rest_string]) do
        if Map.has_key?(@brackets, current_symbol) do
          add_to_stack([current_symbol] ++ stack, rest_string)
        else
            if current_symbol == @brackets[Enum.at(stack, 0)] do add_to_stack(tl(stack), rest_string)
            else
                if Map.values(@brackets) |> Enum.member?(current_symbol) do
                    :error
                else
                    add_to_stack(stack, rest_string)
                end           
            end
        end 	
  end

  def check(text) do
    IO.write(text <> " is_balanced? ")
    with :ok <- add_to_stack([], String.codepoints(text)) do
        IO.puts true
    else
        :error -> IO.puts false     
    end
  end
end

BracketsBalance.check("[22]{}()")
BracketsBalance.check("[asd]{azx}(1231)")
BracketsBalance.check("[[]{23}(zx)")
BracketsBalance.check("[asd2]{]}(asd)")
BracketsBalance.check("([asd]{23}())")