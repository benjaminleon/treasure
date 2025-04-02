defmodule Counter do
  use GenServer
  # Client API

  def start_link(opts \\ []) do
    opts = Keyword.put_new(opts, :name, Counter)
    IO.puts("Counter.start_link called with opts: #{inspect(opts)}")

    GenServer.start_link(Counter, %{}, opts)
  end

  def add(string) do
    GenServer.cast(Counter, {:add, string})
  end

  def remove(string) do
    GenServer.cast(Counter, {:remove, string})
  end

  def get_all do
    GenServer.call(Counter, :get_all)
  end

  # Server callbacks

  @impl true
  def init(state) do
    IO.puts("Counter GenServer starting with state: #{inspect(state)}")
    {:ok, state}
  end

  @impl true
  def handle_cast({:add, string}, state) do
    # Schedule removal after 10 minutes (600,000 ms)
    Process.send_after(self(), {:auto_remove, string}, 600_000)

    # Add string to state with timestamp
    new_state = Map.put(state, string, %{
      inserted_at: DateTime.utc_now()
    })

    {:noreply, new_state}
  end

  @impl true
  def handle_cast({:remove, string}, state) do
    {:noreply, Map.delete(state, string)}
  end

  @impl true
  def handle_call(:get_all, _from, state) do
    strings = Map.keys(state)
    {:reply, strings, state}
  end

  @impl true
  def handle_info({:auto_remove, string}, state) do
    {:noreply, Map.delete(state, string)}
  end
end
