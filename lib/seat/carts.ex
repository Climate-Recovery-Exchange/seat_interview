defmodule Seat.Carts do
  @moduledoc """
  Shopping cart context
  """

  @discount_codes %{
    "hello" => %{"type" => "percent", "value" => Decimal.new("0.2")}
  }
end
