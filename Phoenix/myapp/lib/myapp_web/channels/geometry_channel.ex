defmodule MyAppWeb.GeometryChannel do
  use Phoenix.Channel

  def join("geometry", _message, socket) do
    Phoenix.PubSub.subscribe(MyApp.PubSub, "quest_progress")
    {:ok, socket}
  end

  def handle_in("message:new_joiner", %{"body" => body}, socket) do
    Counter.add(body)
    IO.puts("changes without restarting server")
    all_names = Counter.get_all()
    IO.puts("All names: #{inspect(all_names)}")
    if length(all_names) >= 3 do
      broadcast!(socket, "message:quest_progress", %{status: "begin"})
    end
    broadcast!(socket, "message:all_names", %{body: all_names})
    {:noreply, socket}
  end

  def handle_in("message:coords", %{"lat" => lat, "long" => long, "name" => name}, socket) do
    MyApp.CoordinatesStore.update_coordinates(name, lat, long)

    IO.puts("Stored coordinates for #{name}: #{lat}, #{long}")

    {:noreply, socket}
  end


  def handle_info({:quest_progress, status}, socket) do
    IO.puts("quest progress!! #{status}")
    broadcast!(socket, "message:quest_progress", %{status: status})
    {:noreply, socket}
  end
end
