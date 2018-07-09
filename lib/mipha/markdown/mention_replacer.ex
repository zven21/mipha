defmodule Mipha.Markdown.MentionReplacer do
  @moduledoc """
  Replacer
  """

  alias Mipha.Accounts

  @user_regex ~r{@([a-z1-9]+)}

  def run(body) do
    @user_regex
    |> Regex.replace(body, &existed_user_replacer/2)
  end

  defp existed_user_replacer(whole_match, match_name) do
    case Accounts.get_user_by_username(match_name) do
      nil -> whole_match
      user -> ~s(<a href="/u/#{user.username}" title="#{user.username}">#{user.username}</a>)
    end
  end
end
