defmodule MugwarriorWeb.EnsureUserAuthorizedPlug do
  @moduledoc """
  Logic for handling errors during the auth process
  """

  import Plug.Conn

  @spec init(any) :: any
  def init(opts), do: opts

  @spec call(Plug.Conn.t(), any) :: Plug.Conn.t()
  def call(%{assigns: %{current_user_is_member: true}} = conn, _opts), do: conn

  def call(conn, _opts) do
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(401, to_string("Unauthorized"))
    |> halt
  end
end
