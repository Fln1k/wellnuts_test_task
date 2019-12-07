defmodule BracketsBalance do
  @brackets %{
    "{" => "}",
    "(" => ")",
    "[" => "]"
  }

  def add_to_stack(stack, counter, check_string) do
    if counter < length(check_string) do
      stack =
        if Map.has_key?(@brackets, Enum.at(check_string, counter)) do
          stack ++ [Enum.at(check_string, counter)]
        else
            if Enum.at(check_string, counter) == @brackets[Enum.at(stack, -1)] do
                stack |> Enum.reverse() |> tl() |> Enum.reverse()
            else
                if Map.values(@brackets) |> Enum.member?(Enum.at(check_string, counter)) do
                    [Enum.at(check_string, counter)]++stack
                else
                    stack
                end           
            end 
        end
      add_to_stack(stack, counter + 1, check_string)
    else
      if length(stack)==0 do
        :ok
      else
        :error
      end
    end
  end

  def check(text) do
    IO.write(text <> " is_balanced? ")
    with :ok <- add_to_stack([], 0, String.codepoints(text)) do
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
BracketsBalance.check("([)]{}()")