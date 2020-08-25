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

  # Sync
  def all(server \\ __MODULE__) do
    case GenServer.call(server, :all, :infinity) do
      [] -> {:error, "Ads not loaded"}
      result -> {:ok, result}
    end
  end

  # Sync
  def lookup(category_name, server \\ __MODULE__) do
    case GenServer.call(server, {:lookup, category_name}, :infinity) do
      [] -> {:error, "Ads not loaded"}
      result -> {:ok, result}
    end
  end

  # Async
  def parse(category_name, server \\ __MODULE__) do
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
  def handle_cast({:parse, category}, state) do
    case HTMLCacheServer.lookup(category) do
      nil -> nil

      html ->
        Task.Supervisor.async_nolink(QCEC.TaskSupervisor, fn ->
          :ok = Parser.parse_ads(html, category)

          category
        end)
    end

    {:noreply, state}
  end

  @impl true
  def handle_info({ref, category}, state) do
    Process.demonitor(ref, [:flush])

    Phoenix.PubSub.broadcast(
      QCEC.PubSub,
      "ads",
      {:category_parsed, %{category: category}}
    )

    {:noreply, state}
  end

  @impl true
  def handle_info({:DOWN, _ref, :process, _pid, reason}, state) do
    Logger.error(reason)

    {:noreply, state}
  end
end
