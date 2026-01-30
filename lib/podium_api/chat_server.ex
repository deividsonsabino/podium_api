defmodule PodiumApi.ChatServer do
  use GenServer

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def add_message(message) when is_binary(message) do
    GenServer.cast(__MODULE__, {:add_message, message})
  end

  def get_history do
    GenServer.call(__MODULE__, :get_history)
  end

  @impl true
  def init(_), do: {:ok, []}

  @impl true
  def handle_cast({:add_message, message}, state) do
    {:noreply, [message | state]}
  end

  @impl true
  def handle_call(:get_history, _from, state) do
    {:reply, Enum.reverse(state), state}
  end
end
