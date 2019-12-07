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
        stack = 
            if Enum.at(check_string, counter) == @brackets[Enum.at(stack, -1)] do
                stack |> Enum.reverse() |> tl() |> Enum.reverse()
            else
                stack = 
                if Map.values(@brackets) |> Enum.member?(Enum.at(check_string, counter)) do
                    [Enum.at(check_string, counter)]++stack
                else
                    stack
                end           
                stack
            end 
        end
      add_to_stack(stack, counter + 1, check_string)
    else
      stack
    end
  end

  def check(text) do
    IO.puts(text)
    if length(add_to_stack([], 0, String.codepoints(text))) == 0 do
        IO.puts true
    else
        IO.puts false     
    end
  end
end

BracketsBalance.check("[22]{}({})")
