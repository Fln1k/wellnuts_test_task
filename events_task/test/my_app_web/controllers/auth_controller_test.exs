defmodule MyApp.AuthControllerTest do
  use MyAppWeb.ConnCase

  @valid_email "sergei@gmail.com"
  @invalid_email ""
  @updated_email "sergeitrigubov@gmail.com"

  describe "users" do
    test "new login page" do
      conn = get(build_conn(), auth_path(build_conn(), :new))
      assert conn.path_info == ["login"]
      assert conn.method == "GET"
    end

    test "create user with invalid params" do
      conn = build_conn()

      response =
        conn
        |> post(auth_path(conn, :create, %{"user" => %{"email" => @invalid_email}}))
        |> response(200)

      assert response =~ "can&#39;t be blank"
    end

    test "create user with valid params" do
      conn = build_conn()

      response =
        conn
        |> post(auth_path(conn, :create, %{"user" => %{"email" => @valid_email}}))
        |> response(200)

      assert response =~ "Please check your email for a link to sign in."
    end

    test "login with valid magik link" do
      conn = build_conn()
      conn = post(conn, auth_path(conn, :create, %{"user" => %{"email" => @valid_email}}))
      conn = get(conn, auth_path(conn, :callback, conn.assigns[:token]))
      assert Guardian.Plug.current_resource(conn).email == @valid_email
    end

    test "login with invalid magik link" do
      conn = build_conn()
      conn = post(conn, auth_path(conn, :create, %{"user" => %{"email" => @valid_email}}))

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

    test "logout" do
      conn = build_conn()
      conn = post(conn, auth_path(conn, :create, %{"user" => %{"email" => @valid_email}}))
      conn = get(conn, auth_path(conn, :callback, conn.assigns[:token]))
      assert Guardian.Plug.current_resource(conn) != nil
      conn = get(conn, auth_path(conn, :destroy))
      assert Guardian.Plug.current_resource(conn) == nil
    end

    test "update user with valid params" do
      conn = build_conn()

      conn = post(conn, auth_path(conn, :create, %{"user" => %{"email" => @valid_email}}))
      conn = get(conn, auth_path(conn, :callback, conn.assigns[:token]))
      conn = post(conn, auth_path(conn, :update, %{"user" => %{"email" => "Updated23mail.ru"}}))

      assert conn.private[:plug_session]["phoenix_flash"] == %{
               "info" => "User updated successfully."
             }
    end

    test "update user with invalid params(exsiting email)" do
      conn = build_conn()

      %{email: "existing@gmail.com"}
      |> MyApp.Accounts.create_user()

      conn = post(conn, auth_path(conn, :create, %{"user" => %{"email" => @valid_email}}))
      conn = get(conn, auth_path(conn, :callback, conn.assigns[:token]))

      conn = post(conn, auth_path(conn, :update, %{"user" => %{"email" => "existing@gmail.com"}}))

      assert conn.private[:plug_session]["phoenix_flash"] == %{
               "error" => "this e-mail is already in use"
             }
    end
  end
end
