defmodule MyAppWeb.RoomChannel do
  use Phoenix.Channel

  def join("room:lobby", _message, socket) do
    {:ok, socket}
  end

  def handle_in("message:new", %{"body" => body}, socket) do
    broadcast!(socket, "message:new", %{body: body})
    {:noreply, socket}
  end
end
