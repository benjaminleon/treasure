defmodule MyAppWeb.RoomChannel do
  use Phoenix.Channel

  def join("room:lobby", _message, socket) do
    {:ok, socket}
  end

  def handle_in("message:new", %{"body" => body}, socket) do
    Counter.add(body)
    # broadcast!(socket, "message:new", %{body: body})
    IO.puts("About to call Counter.get_all()")
    all_names = Counter.get_all()
    IO.puts("Did call Counter.get_all()")
    IO.puts("All names: #{inspect(all_names)}")
    broadcast!(socket, "message:new", %{body: all_names})
    {:noreply, socket}
  end
end
