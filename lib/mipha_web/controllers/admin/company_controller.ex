defmodule MiphaWeb.Admin.CompanyController do
  use MiphaWeb, :controller

  alias Mipha.Accounts

  def index(conn, _params) do
    companies = Accounts.list_companies()
    render(conn, "index.html", companies: companies)
  end

  def delete(conn, %{"id" => id}) do
    company = Accounts.get_company!(id)
    {:ok, _company} = Accounts.delete_company(company)

    conn
    |> put_flash(:info, "Company deleted successfully.")
    |> redirect(to: admin_company_path(conn, :index))
  end
end
