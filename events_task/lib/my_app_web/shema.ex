defmodule MyAppWeb.Schema do
  use Absinthe.Schema

  alias MyAppWeb.EventsResolver
  import_types(Absinthe.Type.Custom)

  object :event do
    field(:id, non_null(:id))
    field(:timestamp, non_null(:naive_datetime))
    field(:time, non_null(:string))
    field(:description, non_null(:string))
    field(:author_id, non_null(:string))
    field(:author_email, non_null(:string))

    field(:confirmed_users_email, non_null(list_of(non_null(:user)))) do
      resolve(&EventsResolver.event_confirmed_users_email_list/3)
    end
  end

  object :user do
    field(:email, non_null(:string))
  end

  query do
    field(:all_events, non_null(list_of(non_null(:event)))) do
      resolve(&EventsResolver.all_events/3)
    end
  end
end
