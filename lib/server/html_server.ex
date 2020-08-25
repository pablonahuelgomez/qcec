defmodule QCEC.HTMLServer do
  @moduledoc """
  """
  use GenServer
  require Logger

  alias QCEC.Scraper

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
        :ok = Scraper.fetch_document(category)

        category
      end)
    end)

    {:noreply, []}
  end

  @impl true
  def handle_info({ref, _category}, state) do
    Process.demonitor(ref, [:flush])

    {:noreply, state}
  end

  @impl true
  def handle_info({:DOWN, _ref, :process, _pid, reason}, state) do
    Logger.error(reason)

    {:noreply, state}
  end
end
