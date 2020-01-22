defmodule MyAppWeb.Schema do
  use Absinthe.Schema

  alias MyAppWeb.EventsResolver
  alias MyAppWeb.UsersResolver
  alias MyAppWeb.ConfirmationsResolver

  import_types(Absinthe.Type.Custom)

  object :event do
    field(:id, non_null(:id))
    field(:timestamp, non_null(:naive_datetime))
    field(:time, non_null(:string))
    field(:description, non_null(:string))
    field(:user_id, non_null(:string))

    field(:author, non_null(:user)) do
      resolve(&UsersResolver.find_author/3)
    end

    field(:users_confirmed, non_null(list_of(non_null(:user)))) do
      resolve(&UsersResolver.list_users_confirmed_event/3)
    end

    field(:confirmations, non_null(list_of(non_null(:confirmation)))) do
      resolve(&ConfirmationsResolver.list_confirmations_by_event/3)
    end
  end

  object :user do
    field(:id, non_null(:id))
    field(:email, non_null(:string))

    field(:created_events, non_null(list_of(non_null(:event)))) do
      resolve(&EventsResolver.list_events_by_author_id/3)
    end

    field(:events_confirmed, non_null(list_of(non_null(:event)))) do
      resolve(&EventsResolver.list_events_confirmed_by_user/3)
    end

    field(:confirmations, non_null(list_of(non_null(:confirmation)))) do
      resolve(&ConfirmationsResolver.list_confirmations_by_user/3)
    end
  end

  object :confirmation do
    field(:id, non_null(:id))
    field(:event_id, non_null(:id))
    field(:user_id, non_null(:id))

    field(:event, non_null(:event)) do
      resolve(&EventsResolver.find_event_by_confirmation/3)
    end

    field(:user, non_null(:user)) do
      resolve(&UsersResolver.find_author/3)
    end
  end

  query do
    field(:get_events, non_null(list_of(non_null(:event)))) do
      resolve(&EventsResolver.all_events/3)
    end

    field(:get_event, :event) do
      arg(:id, non_null(:id))
      resolve(&EventsResolver.find_event/2)
    end

    field(:get_user, :user) do
      arg(:id, :id)
      arg(:email, :string)
      resolve(&UsersResolver.find_user/2)
    end

    field(:get_users, non_null(list_of(non_null(:user)))) do
      resolve(&UsersResolver.all_users/3)
    end

    field(:get_confirmation, :confirmation) do
      arg(:id, non_null(:id))
      resolve(&ConfirmationsResolver.find_confirmation/2)
    end

    field(:get_confirmations, non_null(list_of(non_null(:confirmation)))) do
      resolve(&ConfirmationsResolver.all_confirmations/3)
    end
  end

  mutation do
    field(:create_user, :user) do
      arg(:email, non_null(:string))
      resolve(&UsersResolver.create_user/3)
    end

    field(:create_event, :event) do
      arg(:description, non_null(:string))
      arg(:timestamp, non_null(:naive_datetime))
      arg(:user_id, non_null(:id))
      resolve(&EventsResolver.create_event/3)
    end

    field(:create_confirmation, :confirmation) do
      arg(:user_id, non_null(:id))
      arg(:event_id, non_null(:id))
      resolve(&ConfirmationsResolver.create_confirmation/3)
    end
  end
end
