defmodule Acronim do
  def create(text) do
    IO.write "text: " <>text <>"\nacronim: "
    for word <- Regex.scan(~r/[A-z]+/,text) |> List.flatten() do
      String.upcase(String.first(word))
    end
  end
end

IO.puts Acronim.create("World wide Web")
IO.puts Acronim.create("World wide Web 23 54")
IO.puts Acronim.create("4 four 12 Words ,,., test -; Acronim")
