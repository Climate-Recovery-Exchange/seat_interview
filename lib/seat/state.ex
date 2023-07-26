defmodule Seat.State do
  @moduledoc """
  This module is responsible for managing the state of the seats.
  """
  use GenServer
  alias Seat.EventSeats

  # Client

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def fetch_current_state do
    GenServer.call(__MODULE__, :fetch_current_state)
  end

  def select_seat(row, number, session_id) do
    GenServer.call(__MODULE__, {:select_seat, row, number, session_id})
  end

  # Server
  @impl true
  def init(_opts) do
    seats = EventSeats.load_seats()
    {:ok, %{seats: seats}}
  end

  @impl true
  def handle_call(:fetch_current_state, _from, state) do
    {:reply, state, state}
  end
end
