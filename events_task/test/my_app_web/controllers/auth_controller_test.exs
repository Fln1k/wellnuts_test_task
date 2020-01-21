defmodule MyApp.AuthControllerTest do
  use MyAppWeb.ConnCase
  alias MyApp.Accounts
  alias MyAppWeb.Guardian

  @valid_email "sergei@example.com"
  @invalid_email ""
  @updated_email "sergeitrigubov@gmail.com"

  describe "users" do
    def create_test_user(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(%{email: "sergei@example.com"})
        |> Accounts.create_user()

      user
    end

    test "new login page" do
      conn = get(build_conn(), auth_path(build_conn(), :new))
      assert response(conn, 200) =~ "<h1 class=\"page-header\">Login</h1>"
    end

    test "fails create user with invalid params" do
      conn = build_conn()

      response =
        conn
        |> post(auth_path(conn, :create, %{"user" => %{"email" => @invalid_email}}))
        |> response(200)

      assert response =~ "can&#39;t be blank"
    end

    test "successfully create user with valid params" do
      conn = build_conn()

      response =
        conn
        |> post(auth_path(conn, :create, %{"user" => %{"email" => @valid_email}}))
        |> response(200)

      assert response =~ "Please check your email for a link to sign in."
    end

    test "authenticates successfully with valid magic link" do
      conn = build_conn()
      user = create_test_user()
      {_, token, _} = Guardian.send_magic_link(user)
      conn = get(conn, auth_path(conn, :callback, token))
      assert Guardian.Plug.current_resource(conn).email == @valid_email
    end

    test "fails authentication with invalid magic link" do
      conn = build_conn()
      user = create_test_user()
      Guardian.send_magic_link(user)

      conn =
        get(
          conn,
          auth_path(
            conn,
            :callback,
            "JzdWIiOiIzODg1IiwidHlwIjoibWFnaWMifQ.5SY7G8Jz7Dtkxvj6vhlWSmpBXUHwTFkpbxd3a4Z3ROmYKRD4ANLQ8yZ88JQNb6GHh7B1YFSNW8gpTzmFrcvxvw"
          )
        )

      assert Guardian.Plug.current_resource(conn) == nil
    end

    test "successfully logout" do
      conn = build_conn() |> Guardian.Plug.sign_in(create_test_user())
      assert Guardian.Plug.current_resource(conn) != nil
      conn = get(conn, auth_path(conn, :destroy))
      assert Guardian.Plug.current_resource(conn) == nil
    end

    test "successfully update user with valid params" do
      conn = build_conn() |> Guardian.Plug.sign_in(create_test_user())
      conn = post(conn, auth_path(conn, :update, %{"user" => %{"email" => "updated23@mail.ru"}}))

      assert get_flash(conn, :error) == nil
    end

    test "fails update user with invalid params(exsiting email)" do
      conn = build_conn()
      MyApp.Accounts.create_user(%{email: "existing2@gmail.com"})

      conn = build_conn() |> Guardian.Plug.sign_in(create_test_user())

      conn =
        post(conn, auth_path(conn, :update, %{"user" => %{"email" => "existing2@gmail.com"}}))

      assert get_flash(conn, :error) != nil
    end
  end
end
