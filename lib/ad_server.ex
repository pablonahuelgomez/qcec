defmodule QCEC.AdServer do
  @moduledoc """
  """
  use GenServer
  require Logger

  # Client
  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def stop(server \\ __MODULE__) do
    GenServer.stop(server)
  end

  def all(server \\ __MODULE__) do
    GenServer.call(server, :get, :infinity)
  end

  def lookup(category_name, server \\ __MODULE__) do
    GenServer.call(server, {:lookup, category_name}, :infinity)
  end

  def parse(server \\ __MODULE__) do
    GenServer.cast(server, :parse)
  end

  # Server
  @impl true
  def init(:ok) do
    {:ok, []}
  end

  @impl true
  def handle_call({:lookup, category_name}, _from, state) do
    ads = QCEC.AdCacheServer.lookup(category_name)
    {:reply, ads, state}
  end

  @impl true
  def handle_call(:all, _from, state) do
    ads = QCEC.Categories.list(:names)
    |> Enum.map(fn category_name -> QCEC.AdCacheServer.lookup(category_name) end)
    {:reply, ads, state}
  end

  @impl true
  def handle_cast(:parse, state) do
    QCEC.Categories.list(:names)
    |> Enum.map(fn category_name -> QCEC.HTMLCacheServer.lookup(category_name) end)
    |> Enum.map(fn documents -> QCEC.Parser.parse_ads(documents) end)
    |> Enum.map(fn ads -> QCEC.AdCacheServer.populate(ads) end)

    {:noreply, state}
  end
end
