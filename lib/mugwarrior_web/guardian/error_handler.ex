defmodule MugwarriorWeb.Guardian.ErrorHandler do
  @moduledoc """
  Logic for handling errors during the auth process
  """

  import Plug.Conn

  @spec auth_error(Plug.Conn.t(), {atom, any}, any) :: Plug.Conn.t()
  def auth_error(conn, {type, reason}, _opts) do
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(401, to_string(type))
  end
end
