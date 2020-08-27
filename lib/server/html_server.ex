defmodule QCEC.HTMLServer do
  @moduledoc """
  """
  use GenServer
  require Logger

  alias QCEC.Scraper
  alias QCEC.HTMLCacheServer, as: Cache

  # Client
  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def stop(server \\ __MODULE__) do
    GenServer.stop(server)
  end

  # Async
  def fetch(server \\ __MODULE__) do
    GenServer.cast(server, {:fetch})
  end

  # Server
  @impl true
  def init(:ok) do
    {:ok, []}
  end

  @impl true
  def handle_cast({:fetch}, _) do
    QCEC.Categories.list(:names)
    |> Enum.map(fn category ->
      Task.Supervisor.async_nolink(QCEC.TaskSupervisor, fn ->
        case Cache.lookup(category) do
          [] ->
            case Scraper.fetch_document(category) do
              {:ok, category, document} ->
                :ok = Cache.insert(category, document)

              {:error, error} ->
                {:error, error}
            end
          ads -> ads
        end

        category
      end)
    end)

    {:noreply, []}
  end

  @impl true
  def handle_info({ref, category}, state) do
    Process.demonitor(ref, [:flush])

    Phoenix.PubSub.broadcast(
      QCEC.PubSub,
      "ads",
      {:category_fetched, %{category: category}}
    )

    {:noreply, state}
  end

  @impl true
  def handle_info({:DOWN, _ref, :process, _pid, reason}, state) do
    Logger.error(reason)

    {:noreply, state}
  end
end
