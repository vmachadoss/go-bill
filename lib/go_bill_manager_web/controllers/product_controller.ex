defmodule GoBillManagerWeb.ProductController do
  @moduledoc """
    Exposes an API interface to create, show and list product data
  """
  use GoBillManagerWeb, :controller

  import GoBillManager.Utils.EctoUtils

  alias GoBillManager.Commands.ProductCreate
  alias GoBillManager.Repositories.ProductRepository
  alias GoBillManager.Commands.ProductBillCreate

  @spec create(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def create(conn, params) do
    with {:ok, product} <- ProductCreate.run(params) do
      render(conn, "create.json", %{product: product})
    else
      {:error, %Ecto.Changeset{}} ->
        ErrorResponses.bad_request(conn, "invalid_params")

      {:error, reason} ->
        {:error, reason}
    end
  end

  @spec index(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def index(conn, _params) do
    render(conn, "index.json", %{products: ProductRepository.list_products()})
  end

  @spec show(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def show(conn, %{"id" => id}) do
    with {:ok, product_id} <- validate_uuid(id),
         {:ok, product} <- ProductRepository.find(product_id) do
      render(conn, "simplified_product.json", %{product: product})
    else
      {:error, :invalid_uuid} ->
        ErrorResponses.bad_request(conn, "invalid_product_id")

      {:error, :product_not_found} ->
        ErrorResponses.not_found(conn, "product_not_found")
    end
  end

  @spec product_bill(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def product_bill(conn, %{"bill_id" => bill_id, "product_id" => product_id} = params) do
    with true <- all_valid_uuids?([bill_id, product_id]),
         {:ok, product_bill} <- ProductBillCreate.run(params) do
      render(conn, "product_bill.json", %{product_bill: product_bill})
    else
      false ->
        ErrorResponses.bad_request(conn, "invalid_uuid")

      {:error, reason} when reason in ~w(bill_not_found product_not_found)a ->
        ErrorResponses.not_found(conn, Atom.to_string(reason))

      {:error, :bill_isnt_opened = reason} ->
        ErrorResponses.bad_request(conn, Atom.to_string(reason))

      {:error, %Ecto.Changeset{}} ->
        ErrorResponses.bad_request(conn, "invalid_params")
    end
  end
end
