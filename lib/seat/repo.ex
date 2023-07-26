defmodule Seat.Repo do
  use Ecto.Repo,
    otp_app: :seat,
    adapter: Ecto.Adapters.Postgres
end
