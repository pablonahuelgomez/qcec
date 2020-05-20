defmodule QCEC.HTMLCacheServer do
  @moduledoc """
  """
  use GenServer

  # Client
  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def stop(server \\ __MODULE__) do
    GenServer.stop(server)
  end

  def all(server \\ __MODULE__) do
    GenServer.call(server, {:all})
  end

  def lookup(category_name, server \\ __MODULE__) do
    GenServer.call(server, {:lookup, category_name})
  end

  def populate(documents, server \\ __MODULE__) do
    GenServer.cast(server, {:populate, documents})
  end

  # Server
  @impl true
  def init(:ok) do
    :ets.new(:documents, [:named_table])
    {:ok, []}
  end

  @impl true
  def handle_call({:lookup, category_name}, _from, state) do
    {:reply, :ets.lookup(:documents, category_name), state}
  end

  @impl true
  def handle_cast({:populate, documents}, _) do
    :ets.insert(:documents, documents)
    {:noreply, []}
  end
end
