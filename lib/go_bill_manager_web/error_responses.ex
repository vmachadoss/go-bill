defmodule GoBillManagerWeb.ErrorResponses do
  @moduledoc """
  Handle with http error responses messages
  """
  import Plug.Conn
  alias Plug.Conn

  @typedoc """
  Valid possibles to parse as JSON
  """
  @type json :: String.t() | number() | list(json()) | %{required(String.t() | atom()) => json}

  @doc """
  HTTP status: 400

  The request is wrong
  """
  @spec bad_request(Conn.t(), error :: String.t() | atom() | map()) :: Conn.t()
  def bad_request(conn, error \\ "bad_request")

  def bad_request(conn, reason) when is_map(reason),
    do: parse_response_to_json(conn, 400, reason)

  def bad_request(conn, error) when is_binary(error) or is_atom(error) do
    parse_response_to_json(conn, 400, %{type: type(error)})
  end

  @spec not_found(Conn.t(), reason :: String.t() | atom()) :: Conn.t()
  def not_found(conn, reason) when is_binary(reason) or is_atom(reason) do
    parse_response_to_json(conn, 404, %{type: type(reason)})
  end

  @spec parse_response_to_json(Conn.t(), integer(), json()) :: Conn.t()
  def parse_response_to_json(conn, status, value) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(status, Jason.encode!(value))
  end

  @doc """
  Default type error responses
  """
  @spec type(type :: String.t() | atom()) :: String.t()
  def type(type), do: "error:#{type}"
end
