defmodule QCEC.HTMLServer do
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

  def fetch(server \\ __MODULE__) do
    GenServer.cast(server, :fetch)
  end

  # Server
  @impl true
  def init(:ok) do
    {:ok, []}
  end

  @impl true
  def handle_cast(:fetch, _) do
    QCEC.Scraper.fetch_documents() |> QCEC.HTMLCacheServer.populate()

    {:noreply, []}
  end
end
