defmodule MugwarriorWeb.Guardian.CurrentUserPlug do
  @moduledoc """
  Plug that populates the current_user assigns
  """

  alias MugwarriorWeb.Guardian.Tokenizer.Plug, as: GuardianPlug
  alias Plug.Conn

  @spec init(any) :: any
  def init(opts), do: opts

  @spec call(Plug.Conn.t(), any) :: Plug.Conn.t()
  def call(conn, _opts) do
    Conn.assign(conn, :current_user, GuardianPlug.current_resource(conn))
  end
end
