defmodule MiphaWeb.TagHelpers do
  @moduledoc """
  View helpers for generating particular tags with some internal logic.
  """

  import Phoenix.HTML.Tag
  require Integer
  alias Mipha.Qiniu

  @doc """
  Generate an abbr to wrap an ISO time to be rendered nicely via JS in the frontend.
  """
  def time_tag(time) do
    time_string =
      time
      |> Timex.format!("{ISO:Extended:Z}")

    content_tag(:addr, class: "timeago", title: time_string) do
      time_string
    end
  end

  @doc """
  Returns user level.
  """
  def user_level_tag(user) do
    level_name = user.is_admin && "管理员" || "会员"
    level_class = user.is_admin && "badge-alert" || "badge-success"
    content_tag(:span, level_name, class: "badge #{level_class} role")
  end

  @doc """
  Return if rem(number) == 0, return odd, else return even.
  """
  def cycle_tag(number) do
    Integer.is_odd(number) && "odd" || "even"
  end

  @doc """
  Return featured if type == :featured
  """
  def topic_featured_tag(topic) do
    if topic.type == :featured do
      content_tag(:i, "", title: "精华帖", class: "fa fa-diamond", style: "color: red;")
    end
  end

  def qn_url(string) do
    Qiniu.q_url(string)
  end
end
