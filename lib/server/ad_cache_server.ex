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

  def insert(ads, category_name, server \\ __MODULE__) do
    GenServer.cast(server, {:insert, ads, category_name})
  end

  # Server
  @impl true
  def init(:ok) do
    :ets.new(:ads, [:named_table])
    {:ok, []}
  end

  @impl true
  def handle_call({:lookup, category_name}, _from, state) do
    {:reply, :ets.lookup(:ads, category_name) |> Keyword.get(category_name), state}
  end

  @impl true
  def handle_cast({:insert, ads, category_name}, _) do
    :ets.insert(:ads, {category_name, ads})
    {:noreply, []}
  end
end
