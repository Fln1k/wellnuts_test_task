defmodule MyAppWeb.ConfirmationsResolver do
  alias MyApp.Content

  def all_confirmations(_root, _args, _info) do
    confirmations = Content.list_confirmations()
    {:ok, confirmations}
  end

  def find_confirmation(%{id: id}, _info) do
    case Content.get_confirmation!(id) do
      nil -> {:error, "Confirmation id #{id} not found!"}
      confirmation -> {:ok, confirmation}
    end
  end

  def list_confirmations_by_event(root, _args, _info) do
    confirmations = Content.list_confirmations_by_event(root.id)
    {:ok, confirmations}
  end

  def list_confirmations_by_user(root, _args, _info) do
    confirmations = Content.list_confirmations_by_user(root.id)
    {:ok, confirmations}
  end

  def create_confirmation(_root, args, _info) do
    case Content.create_confirmation(args) do
      confirmation ->
        confirmation

      nil ->
        {:error, "Confirmation not created!"}
    end
  end
end
