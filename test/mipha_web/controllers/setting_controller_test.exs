defmodule MiphaWeb.SettingControllerTest do
  use MiphaWeb.ConnCase

  @tag :as_user
  test "renders profile page", %{conn: conn, user: user} do
    conn = get(conn, setting_path(conn, :show))

    assert conn.status == 200
    assert conn.resp_body =~ user.username
  end

  @tag :as_user
  test "renders update password page", %{conn: conn} do
    conn = get(conn, setting_password_path(conn, :password))
    assert conn.status == 200
  end

  @tag :as_user
  test "renders reward page", %{conn: conn} do
    conn = get(conn, setting_reward_path(conn, :reward))
    assert conn.status == 200
  end

  @tag :as_user
  test "renders account page", %{conn: conn} do
    conn = get(conn, setting_account_path(conn, :account))
    assert conn.status == 200
  end

  @tag :as_user
  test "updates profile" do
  end

  @tag :as_user
  test "updates account" do
  end

  @tag :as_user
  test "updates reward" do
  end

  @tag :as_user
  test "updates user password" do
  end
end
