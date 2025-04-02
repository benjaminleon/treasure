defmodule MyApp.Counter do
  use GenServer

  ## Public API

  def start_link(_) do
    GenServer.start_link(__MODULE__, 0, name: __MODULE__)
  end

  def increment do
    GenServer.call(__MODULE__, :increment)
  end

  ## GenServer Callbacks

  def init(initial_value) do
    {:ok, initial_value}
  end

  def handle_call(:increment, _from, state) do
    {:reply, state + 1, state + 1}
  end
end
