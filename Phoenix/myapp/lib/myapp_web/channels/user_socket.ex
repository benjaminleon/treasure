defmodule MyAppWeb.UserSocket do
  use Phoenix.Socket

  ## Channels
  channel "geometry", MyAppWeb.GeometryChannel

  # This function handles connection authorization
  def connect(_params, socket, _connect_info) do
    {:ok, socket}
  end

  # Identifies a socket (used for presence tracking)
  def id(_socket), do: nil
end
