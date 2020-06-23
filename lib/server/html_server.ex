defmodule QCEC.HTMLServer do
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

  def fetch(subscribers \\ [], server \\ __MODULE__) do
    GenServer.cast(server, {:fetch, subscribers})
  end

  # Server
  @impl true
  def init(:ok) do
    {:ok, []}
  end

  @impl true
  def handle_cast({:fetch, subscribers}, _) do
    QCEC.Categories.list(:names)
    |> Enum.map(fn category_name ->
      QCEC.Scraper.fetch_document(category_name, subscribers)
    end)
    |> Enum.map(&Task.await/1)

    {:noreply, []}
  end
end
