defmodule MyAppWeb.ConfirmationsResolver do
  def all_confirmations(_root, _args, _info) do
    confirmations = MyApp.Content.list_confirmations()
    {:ok, confirmations}
  end

  def find_confirmation(%{id: id}, _info) do
    case MyApp.Content.get_confirmation!(id) do
      nil -> {:error, "Confirmation id #{id} not found!"}
      confirmation -> {:ok, confirmation}
    end
  end

  def list_confirmations_by_event(_root, _args, _info) do
    confirmations = MyApp.Content.list_confirmations_by_event(_root.id)
    {:ok, confirmations}
  end

  def list_confirmations_by_user(_root, _args, _info) do
    confirmations = MyApp.Content.list_confirmations_by_user(_root.id)
    {:ok, confirmations}
  end
end
