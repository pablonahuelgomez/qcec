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
    case GenServer.call(server, :all, :infinity) do
      [] -> {:error, "Ads not loaded"}
      result -> {:ok, result}
    end
  end

  def lookup(category_name, server \\ __MODULE__) do
    case GenServer.call(server, {:lookup, category_name}, :infinity) do
      [] -> {:error, "Ads not loaded"}
      result -> {:ok, result}
    end
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
      |> Enum.map(&AdCacheServer.lookup(&1))
      |> List.flatten()

    {:reply, ads, state}
  end

  @impl true
  def handle_cast({:parse, :all}, state) do
    Categories.list(:names)
    |> Enum.map(&parse_from/1)
    |> Enum.map(&Task.await/1)

    {:noreply, state}
  end

  @impl true
  def handle_cast({:parse, category}, state) do
    HTMLCacheServer.lookup(category)
    |> parse_ads(category)
    |> Task.await()

    {:noreply, state}
  end

  defp parse_from(category) do
    HTMLCacheServer.lookup(category) |> parse_ads(category)
  end

  defp parse_ads(html, category) do
    Parser.parse_ads(html, category, fn category -> Logger.debug("#{category} parsed") end)
  end
end
