defmodule MyAppWeb.RoomChannel do
  use Phoenix.Channel

  def join("room:lobby", _message, socket) do
    {:ok, socket}
  end

  def handle_in("message:new_joiner", %{"body" => body}, socket) do
    Counter.add(body)
    all_names = Counter.get_all()
    cond do
      length(all_names) > 4 ->
        IO.puts("Sending start quest message to everyone")
        broadcast!(socket, "message:new_joiner", %{body: "start_quest"})
      true ->
        IO.puts("Waiting for more people to join")
    end

    IO.puts("All names: #{inspect(all_names)}")
    broadcast!(socket, "message:new_joiner", %{body: all_names})

    {:noreply, socket}
  end

  def handle_in("message:coords", %{"lat" => lat, "long" => long}, socket) do

    IO.puts("received #{lat}, #{long}")

    {:noreply, socket}
  end
end
