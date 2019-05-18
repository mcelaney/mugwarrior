defmodule Mugwarrior.Repo do
  use Ecto.Repo,
    otp_app: :mugwarrior,
    adapter: Ecto.Adapters.Postgres
end
