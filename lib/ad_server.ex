defmodule QCEC.AdServer do
  @moduledoc """
  """
  use GenServer
  require Logger
  alias QCEC.AdCacheServer
  alias QCEC.Categories
  alias QCEC.HTMLCacheServer
  alias QCEC.Parser

  # Client
  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def stop(server \\ __MODULE__) do
    GenServer.stop(server)
  end

  def all(server \\ __MODULE__) do
    GenServer.call(server, :all, :infinity)
  end

  def lookup(category_name, server \\ __MODULE__) do
    GenServer.call(server, {:lookup, category_name}, :infinity)
  end

  def parse(category_name \\ :all, server \\ __MODULE__) do
    GenServer.cast(server, {:parse, category_name})
  end

  # Server
  @impl true
  def init(:ok) do
    {:ok, []}
  end

  @impl true
  def handle_call({:lookup, category_name}, _from, state) do
    {:reply, AdCacheServer.lookup(category_name), state}
  end

  @impl true
  def handle_call(:all, _from, state) do
    ads =
      Categories.list(:names)
      |> Enum.flat_map(&AdCacheServer.lookup(&1))

    {:reply, ads, state}
  end

  @impl true
  def handle_cast({:parse, :all}, state) do
    QCEC.Categories.list(:names)
    |> Enum.map(
      &(HTMLCacheServer.lookup(&1)
        |> Parser.parse_ads(&1))
    )

    {:noreply, state}
  end

  @impl true
  def handle_cast({:parse, category_name}, state) do
    QCEC.HTMLCacheServer.lookup(category_name)
    |> Parser.parse_ads(category_name)

    {:noreply, state}
  end
end
