defmodule MyApp.CoordinatesStore do
  use GenServer

  # Client API
  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def update_coordinates(name, lat, lng) do
    GenServer.cast(__MODULE__, {:update_coordinates, name, lat, lng})
  end

  def get_coordinates(name) do
    GenServer.call(__MODULE__, {:get_coordinates, name})
  end

  def get_all_coordinates do
    GenServer.call(__MODULE__, :get_all_coordinates)
  end

  def broadcast_quest_progress(status) do
    Phoenix.PubSub.broadcast(MyApp.PubSub, "quest_progress", {:quest_progress, status})
  end

  # Server Callbacks
  @impl true
  def init(_) do
    # Start the periodic task
    schedule_periodic_task()
    {:ok, %{}}
  end

  @impl true
  def handle_cast({:update_coordinates, name, lat, lng}, state) do
    {:noreply, Map.put(state, name, %{lat: lat, lng: lng, timestamp: DateTime.utc_now()})}
  end

  @impl true
  def handle_call({:get_coordinates, name}, _from, state) do
    {:reply, Map.get(state, name), state}
  end

  @impl true
  def handle_call(:get_all_coordinates, _from, state) do
    {:reply, state, state}
  end

  @impl true
  def handle_info(:process_coordinates, state) do
    state
    |> Enum.each(fn {name, %{lat: lat, lng: lng, timestamp: timestamp}} ->
      IO.puts("Name: #{name}, Latitude: #{lat}, Longitude: #{lng}, Updated at: #{timestamp}")
    end)

    # Get all coordinates as tuples
    coordinates = state
    |> Enum.map(fn {_name, %{lat: lat, lng: lng}} -> {lat, lng} end)

    if length(coordinates) >= 3 do
      IO.puts("We have #{length(coordinates)} and are ready to try")
      # Check if points are collinear
      if Collinear.roughly_collinear(coordinates) do
        IO.puts("Points are collinear!")
        broadcast_quest_progress("success")
        {:noreply, state}
      else
        IO.puts("Points are not collinear!")
      end
    else
      IO.puts("only #{length(coordinates)}")
    end

    schedule_periodic_task()
    {:noreply, state}
  end

  defp schedule_periodic_task do
    Process.send_after(self(), :process_coordinates, 2000) # 1000ms = 1 second
  end
end
