defmodule MiphaWeb.SettingController do
  use MiphaWeb, :controller
  alias Mipha.Accounts
  alias Mipha.Accounts.User
  alias Mipha.Qiniu

  plug MiphaWeb.Plug.RequireUser

  @intercepted_action ~w(show account password profile reward)a

  def action(conn, _) do
    if Enum.member?(@intercepted_action, action_name(conn)) do
      changeset = Accounts.change_user(current_user(conn))
      render conn, action_name(conn), changeset: changeset
    else
      apply(__MODULE__, action_name(conn), [conn, conn.params])
    end
  end

  def update(conn, %{"user" => user_params}) do
    case user_params["by"] do
      "show"     ->   update_account(conn, user_params)
      "profile"  ->   update_profile(conn, user_params)
      "password" ->   update_password(conn, user_params)
      "reward"   ->   update_reward(conn, user_params)
    end
  end

  defp update_account(conn, user_params) do
    attrs = %{
      "bio" => user_params["bio"],
      "email_public" => user_params["email_public"]
    }

    if user_params["avatar"] do
      avatar_path = user_params["avatar"].path
      {:ok, key} = upload(conn, avatar_path)
      attrs = Map.merge(attrs, %{"avatar" => key})
    end

    case Accounts.update_user(current_user(conn), attrs) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> render(:show, changeset: Accounts.change_user(user))

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_flash(:danger, "User updated failed.")
        |> render(:show, changeset: changeset)
    end
  end

  defp update_profile(conn, user_params) do
    case Accounts.update_user(current_user(conn), user_params) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: setting_profile_path(conn, :profile))

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_flash(:danger, "User updated failed.")
        |> render(:password, changeset: changeset)
    end
  end

  defp update_password(conn, user_params) do
    case Accounts.update_user_password(current_user(conn), user_params) do
      {:ok, _} ->
        conn
        |> configure_session(drop: true)
        |> put_flash(:info, "User updated password successfully.")
        |> redirect(to: "/")

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_flash(:danger, "Invalid password")
        |> render(:password, changeset: changeset)

      {:error, reason} ->
        changeset = User.update_password_changeset(%User{}, %{})
        conn
        |> put_flash(:danger, reason)
        |> render(:password, changeset: changeset)
    end
  end

  defp update_reward(conn, user_params) do
    attrs = %{}

    if user_params["wechat"] do
      wechat_path = user_params["wechat"].path
      {:ok, key} = upload(conn, wechat_path)
      attrs = Map.merge(attrs, %{"wechat" => key})
    end

    if user_params["alipay"] do
      alipay_path = user_params["alipay"].path
      {:ok, key} = upload(conn, alipay_path)
      attrs = Map.merge(attrs, %{"alipay" => key})
    end

    case Accounts.update_user(current_user(conn), attrs) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> render(:show, changeset: Accounts.change_user(user))

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_flash(:danger, "User updated failed.")
        |> render(:show, changeset: changeset)
    end
  end

  defp upload(conn, path) do
    case Qiniu.upload(path) do
      %HTTPoison.Response{status_code: 200, body: body} ->
        {:ok, body["key"]}

      %HTTPoison.Response{status_code: _} ->
        conn
        |> put_flash(:danger, "上传失败")
        |> render(:show, changeset: Accounts.change_user(current_user(conn)))
    end
  end
end
