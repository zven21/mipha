defmodule MiphaWeb.Email do
  @moduledoc false

  use Bamboo.Phoenix, view: MiphaWeb.EmailView

  def forgot_password(user, token) do
    from = "mipha@mipha.com"
    subject = "重置密码信息"

    normal_email()
    |> from(from)
    |> to(user.email)
    |> subject(subject)
    |> assign(:user, user)
    |> assign(:token, token)
    |> render("forgot_password.html")
  end

  def verify_email(user, token) do
    from = "mipha@mipha.com"
    subject = "激活邮箱"

    normal_email()
    |> from(from)
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
