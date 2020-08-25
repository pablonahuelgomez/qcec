defmodule QCEC.CategoryServer do
  use GenServer

  require Logger

  # Client
  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  # Server
  @impl true
  def init(:ok) do
    Phoenix.PubSub.subscribe(QCEC.PubSub, "ads")

    {:ok, []}
  end

  @impl true
  def handle_info({:category_fetched, %{category: category}}, state) do
    Logger.info("#{category} html fetched")

    QCEC.AdServer.parse(category)

    {:noreply, state}
  end

  @impl true
  def handle_info({:category_parsed, %{category: category}}, state) do
    Logger.info("#{category} html parsed")

    {:noreply, state}
  end
end
