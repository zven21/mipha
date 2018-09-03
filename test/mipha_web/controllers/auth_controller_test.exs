defmodule MiphaWeb.AuthControllerTest do
  use MiphaWeb.ConnCase

  test "getting the sign in form" do
    # conn = get(conn, auth_path(conn, :login))
    # assert html_response(conn, 200) =~ "Sign In"
  end

  test "submitting the form with unknow username/email" do
  end

  test "submitting the form with wrong password" do
  end

  describe "github auth" do
    test "successful auth on existing person signs you in" do
    end

    test "failed auth doesn't sign you in" do
    end
  end

  test "successful sign with correct infomation" do
  end
end
