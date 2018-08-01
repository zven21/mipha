defmodule MiphaWeb.Admin.CompanyController do
  use MiphaWeb, :controller

  alias Mipha.Accounts
  alias Mipha.Accounts.Queries

  def index(conn, params) do
    result = Queries.list_companies() |> Turbo.Ecto.turbo(params)
    render conn, :index, companies: result.datas, paginate: result.paginate
  end

  def delete(conn, %{"id" => id}) do
    company = Accounts.get_company!(id)
    {:ok, _company} = Accounts.delete_company(company)

    conn
    |> put_flash(:info, "Company deleted successfully.")
    |> redirect(to: admin_company_path(conn, :index))
  end
end
