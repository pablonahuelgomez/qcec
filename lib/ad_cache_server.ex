defmodule QCEC.AdCacheServer do
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

  def lookup(category_name, server \\ __MODULE__) do
    GenServer.call(server, {:lookup, category_name})
  end

  def populate(ads, server \\ __MODULE__) do
    GenServer.cast(server, {:populate, ads})
  end

  # Server
  @impl true
  def init(:ok) do
    :ets.new(:ads, [:named_table])
    {:ok, []}
  end

  @impl true
  def handle_call({:lookup, category_name}, _from, state) do
    {:reply, :ets.lookup(:ads, category_name), state}
  end

  @impl true
  def handle_cast({:populate, ads}, _) do
    :ets.insert(:ads, ads)
    {:noreply, []}
  end
end
