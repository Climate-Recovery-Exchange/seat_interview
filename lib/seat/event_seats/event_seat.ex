defmodule Seat.EventSeats.EventSeat do
  @moduledoc """
  The model for event seat.
  """
  use Ecto.Schema
  alias Ecto.UUID
  alias Seat.EventSeats.EventSeat

  import Ecto.Changeset

  embedded_schema do
    field :row, :string
    field :number, :string
    field :status, Ecto.Enum, values: ~w(available reserved sold)a, default: :available
    field :section, :string
    field :price, :decimal
    field :reserved_by, UUID
  end

  def new!(attrs) do
    EventSeat
    |> struct()
    |> changeset(attrs)
    |> apply_action!(:new)
  end

  def new(attrs) do
    EventSeat
    |> struct()
    |> changeset(attrs)
    |> apply_action(:new)
  end

  @required_fields ~w( id row number status section price )a
  @optional_fields ~w( status reserved_by )a
  @all_fields @required_fields ++ @optional_fields

  def changeset(event_seat, attrs) do
    event_seat
    |> cast(attrs, @all_fields)
    |> validate_required(@required_fields)
  end
end
