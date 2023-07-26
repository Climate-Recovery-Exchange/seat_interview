defmodule SeatWeb.SeatLive do
  use SeatWeb, :live_view
  alias Seat.EventSeats
  alias Seat.State

  @impl true
  def render(assigns) do
    ~H"""
    <div class="flex w-full">
      <section class="w-8/12">
        <div class="flex">
          <div class="w-5 h-5"></div>
          <div :for={n <- @number_per_row} class="w-5 h-5 mx-2 text-center"><%= n %></div>
        </div>
        <div :for={{row, seats} <- @seats}>
          <div class="flex my-2">
            <div class="w-5 h-5"><%= row %></div>
            <div
              :for={seat <- seats}
              class={[
                "border border-black mx-2 w-5 h-5 cursor-pointer",
                if(selected_by_current_user?(seat, @user_session_id), do: "bg-yellow-200"),
                if(selected_by_others?(seat, @user_session_id), do: "bg-gray-200")
              ]}
            >
            </div>
          </div>
        </div>
      </section>

      <section class="w-4/12">
        <h2 class="text-lg font-medium">Shopping Cart</h2>
      </section>
    </div>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    user_session_id = Ecto.UUID.generate()
    EventSeats.initialize()

    state = State.fetch_current_state()

    socket =
      socket
      |> assign(state)
      |> assign(:number_per_row, 1..EventSeats.number_per_row())
      |> assign(:user_session_id, user_session_id)

    send(self(), {:updated_seats, state.seats})

    {:ok, socket}
  end

  defp selected_by_current_user?(seat, user_session_id) do
    seat.status == :reserved and seat.reserved_by == user_session_id
  end

  defp selected_by_others?(seat, user_session_id) do
    seat.status == :sold or (seat.status == :reserved and seat.reserved_by != user_session_id)
  end
end
