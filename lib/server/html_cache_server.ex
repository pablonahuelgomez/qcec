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

  # Sync
  def lookup(category_name, server \\ __MODULE__) do
    case GenServer.call(server, {:lookup, category_name}) do
      [] -> []
      [{_, html}] -> html
    end
  end

  # Async
  def insert(category_name, document, server \\ __MODULE__) do
    GenServer.cast(server, {:insert, category_name, document})
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
  def handle_cast({:insert, category_name, document}, _) do
    :ets.insert(:documents, {category_name, document})
    {:noreply, []}
  end
end
