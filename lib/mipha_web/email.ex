defmodule MiphaWeb.Email do
  @moduledoc """
  发送邮件集。
  """

  use Bamboo.Phoenix, view: MiphaWeb.EmailView

  @from "andzven@gmail.com"

  @doc """
  重置密码邮件。
  """
  def forgot_password(token, user) do
    subject = "重置密码信息"

    normal_email()
    |> from(@from)
    |> to(user.email)
    |> subject(subject)
    |> assign(:user, user)
    |> assign(:token, token)
    |> render("forgot_password.html")
  end

  @doc """
  欢迎邮件。
  """
  def welcome(token, user) do
    subject = "欢迎加入 Elixir China 社区"

    normal_email()
    |> from(@from)
    |> to(user.email)
    |> subject(subject)
    |> assign(:user, user)
    |> assign(:token, token)
    |> render("welcome.html")
  end

  @doc """
  验证用户登录邮箱
  """
  def verify_email(token, user) do
    subject = "激活邮箱"

    normal_email()
    |> from(@from)
    |> to(user.email)
    |> subject(subject)
    |> assign(:user, user)
    |> assign(:token, token)
    |> render("verify_email.html")
  end

  defp normal_email do
    new_email()
    |> put_html_layout({MiphaWeb.LayoutView, "email.html"})
  end
end
