defmodule MyApp.Contents do
  @moduledoc """
  The Contents context.
  """

  import Ecto.Query, warn: false
  alias MyApp.Repo

  alias MyApp.Content.Event

  def list_events do
    Repo.all(Event)
  end

  def get_event(id) do
    Repo.get(Event, id)
  end
end
