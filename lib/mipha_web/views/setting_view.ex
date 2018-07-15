defmodule MiphaWeb.SettingView do
  use MiphaWeb, :view

  alias Mipha.Accounts

  @doc """
  location select option
  """
  def location_option do
    Accounts.list_locations
    |> Enum.map(&{&1.name, &1.id})
  end

  @doc """
  company select option
  """
  def company_option do
    Accounts.list_companies
    |> Enum.map(&{&1.name, &1.id})
  end
end
