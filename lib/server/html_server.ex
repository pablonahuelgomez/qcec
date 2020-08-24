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
    |> Enum.map(fn category -> Task.async(fn -> Scraper.fetch_document(category) end) end)
    |> Enum.map(fn task -> Task.await(task, 25000) end)

    {:noreply, []}
  end

end
