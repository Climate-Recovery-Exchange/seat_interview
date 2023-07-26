defmodule Seat.EventSeats do
  @moduledoc """
  Event Seats context
  """
  alias Ecto.UUID
  alias Seat.State
  alias Seat.EventSeats.EventSeat

  @number_per_row 10
  @rows ~w(A B C D E F G H I J)
  # @rows ~w(A)
  @sections %{
    "A" => "blue",
    "B" => "green",
    "C" => "green",
    "D" => "green",
    "E" => "red",
    "F" => "red",
    "G" => "red",
    "H" => "yellow",
    "I" => "yellow",
    "J" => "yellow"
  }
  @price %{
    "blue" => "1000",
    "green" => "800",
    "red" => "500",
    "yellow" => "300"
  }

  def initialize do
    State.start_link()
  end

  def number_per_row, do: @number_per_row

  def load_seats do
    Enum.map(@rows, fn row ->
      Enum.map(1..@number_per_row, fn number ->
        EventSeat.new!(%{
          id: UUID.generate(),
          row: row,
          number: Integer.to_string(number),
          section: @sections[row],
          price: @price[@sections[row]]
        })
      end)
    end)
    |> List.flatten()
    |> Enum.group_by(& &1.row)
  end

  def select_seat(seats, row, number, session_id) do
    seat_row = Map.get(seats, row)

    new_seat_row =
      Enum.map(seat_row, fn seat ->
        cond do
          seat.number == number and seat.status == :available ->
            seat
            |> EventSeat.changeset(%{status: :reserved, reserved_by: session_id})
            |> Ecto.Changeset.apply_action!(:update)

          seat.number == number and seat.status == :reserved and seat.reserved_by == session_id ->
            seat
            |> EventSeat.changeset(%{status: :available, reserved_by: nil})
            |> Ecto.Changeset.apply_action!(:update)

          true ->
            seat
        end
      end)

    Map.put(seats, row, new_seat_row)
  end

  def release_seat(seats, row, number) do
    seat_row = Map.get(seats, row)

    new_seat_row =
      Enum.map(seat_row, fn seat ->
        if seat.number == number and seat.status == :reserved do
          seat
          |> EventSeat.changeset(%{status: :available, reserved_by: nil})
          |> Ecto.Changeset.apply_action!(:update)
        else
          seat
        end
      end)

    Map.put(seats, row, new_seat_row)
  end
end
