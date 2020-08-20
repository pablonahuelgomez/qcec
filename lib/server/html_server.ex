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
    |> Enum.map(fn category_name ->
      category_name
      |> QCEC.Scraper.fetch_document(fn category ->
        Logger.debug("#{category} html fetched")
      end)
    end)
    |> Enum.map(&Task.await/1)

    {:noreply, []}
  end
end
