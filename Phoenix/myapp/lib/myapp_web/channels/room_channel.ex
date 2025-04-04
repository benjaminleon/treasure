defmodule MyAppWeb.RoomChannel do
  use Phoenix.Channel

  def join("room:lobby", _message, socket) do
    {:ok, socket}
  end

  def handle_in("message:new_joiner", %{"body" => body}, socket) do
    Counter.add(body)
    all_names = Counter.get_all()
    IO.puts("All names: #{inspect(all_names)}")
    broadcast!(socket, "message:all_names", %{body: all_names})
    {:noreply, socket}
  end

  def handle_in("message:coords", %{"lat" => lat, "long" => long, "name" => name}, socket) do
    MyApp.CoordinatesStore.update_coordinates(name, lat, long)

    IO.puts("Stored coordinates for #{name}: #{lat}, #{long}")

    {:noreply, socket}
  end
end
