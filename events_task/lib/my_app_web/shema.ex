defmodule MyAppWeb.Schema do
  use Absinthe.Schema

  alias MyAppWeb.EventsResolver
  alias MyAppWeb.UsersResolver

  import_types(Absinthe.Type.Custom)

  object :event do
    field(:id, non_null(:id))
    field(:timestamp, non_null(:naive_datetime))
    field(:time, non_null(:string))
    field(:description, non_null(:string))
    field(:author_id, non_null(:string))
    field(:author_email, non_null(:string))

    field(:confirmed_users_email, non_null(list_of(non_null(:user)))) do
      resolve(&EventsResolver.event_confirmed_users_list_by_event_id/3)
    end

    field(:confirmations, non_null(list_of(non_null(:confirmation)))) do
      resolve(&EventsResolver.event_confirmations_list_by_event_id/3)
    end
  end

  object :user do
    field(:id, non_null(:id))
    field(:email, non_null(:string))
  end

  object :confirmation do
    field(:id, non_null(:id))
    field(:event_id, non_null(:id))
    field(:user_id, non_null(:id))
  end

  query do
    field(:events, non_null(list_of(non_null(:event)))) do
      resolve(&EventsResolver.all_events/3)
    end

    field(:event, :event) do
      arg(:id, non_null(:id))
      resolve(&EventsResolver.find_event/2)
    end

    field(:user, :user) do
      arg(:id, non_null(:id))
      resolve(&UsersResolver.find_user/2)
    end

    field(:users, :user) do
      resolve(&UsersResolver.all_users/3)
    end
  end
end
