defmodule MiphaWeb.SettingController do
  use MiphaWeb, :controller

  alias Mipha.{Accounts, Qiniu}

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
    # FIXME need more better method.
    attrs =
      user_params
      |> Map.pop("avatar")
      |> build_attrs("avatar")

    case Accounts.update_user(current_user(conn), attrs) do
      {:ok, user} ->
        conn
        |> put_flash(:info, gettext("Profile updated successfully"))
        |> render(:show, changeset: Accounts.change_user(user))

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_flash(:danger, gettext("Profile updated failed"))
        |> render(:show, changeset: changeset)
    end
  end

  defp update_profile(conn, user_params) do
    case Accounts.update_user(current_user(conn), user_params) do
      {:ok, _} ->
        conn
        |> put_flash(:info, gettext("User updated successfully."))
        |> redirect(to: setting_profile_path(conn, :profile))

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_flash(:danger, gettext("User updated failed."))
        |> render(:password, changeset: changeset)
    end
  end

  defp update_password(conn, user_params) do
    case Accounts.update_user_password(current_user(conn), user_params) do
      {:ok, _} ->
        conn
        |> configure_session(drop: true)
        |> put_flash(:info, gettext("User updated password successfully."))
        |> redirect(to: "/")

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_flash(:danger, gettext("Invalid password"))
        |> render(:password, changeset: changeset)

      {:error, reason} ->
        changeset = Accounts.user_update_password_changeset()
        conn
        |> put_flash(:danger, reason)
        |> render(:password, changeset: changeset)
    end
  end

  defp update_reward(conn, user_params) do
    attrs =
      user_params
      |> Map.pop("wechat")
      |> build_attrs("wechat")
      |> Map.pop("alipay")
      |> build_attrs("alipay")

    case Accounts.update_user(current_user(conn), attrs) do
      {:ok, user} ->
        changeset = Accounts.change_user(user)

        conn
        |> put_flash(:info, gettext("User updated successfully."))
        |> render(:show, changeset: changeset)

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_flash(:danger, gettext("User updated failed."))
        |> render(:show, changeset: changeset)
    end
  end

  defp build_attrs({nil, params}, _), do: params
  defp build_attrs({%Plug.Upload{} = avatar, params}, field) do
    # FIXME need set global callback
    with %HTTPoison.Response{status_code: 200, body: body} <- Qiniu.upload(avatar.path) do
      Map.merge(params, %{field => body["key"]})
    end
  end
end
