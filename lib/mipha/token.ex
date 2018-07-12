defmodule Mipha.Token do
  @moduledoc false

  alias Mipha.Accounts.User

  @verification_salt "mipha"

  def generate_token(%User{id: user_id}) do
    Phoenix.Token.sign(MiphaWeb.Endpoint, @verification_salt, user_id)
  end

  def verify_token(token) do
    max_age = 86_400
    Phoenix.Token.verify(MiphaWeb.Endpoint, @verification_salt, token, max_age: max_age)
  end
end
