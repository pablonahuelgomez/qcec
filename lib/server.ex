defmodule QCEC.Server do
  use GenServer

  # Client
  def start_link(_opts) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def stop do
    GenServer.stop(__MODULE__)
  end

  def get(:ads) do
    GenServer.call(__MODULE__, {:get, :ads})
  end

  def get(:categories) do
    GenServer.call(__MODULE__, {:get, :categories})
  end

  def refresh(:ads) do
    GenServer.cast(__MODULE__, {:refresh, :ads})
  end

  def refresh(:categories) do
    GenServer.cast(__MODULE__, {:refresh, :categories})
  end

  # Server
  @impl true
  def init(:ok) do
    {:ok, %{ads: [], categories: []}}
  end

  @impl true
  def handle_call({:get, :ads}, _from, state), do: {:reply, state.ads, state}
  @impl true
  def handle_call({:get, :categories}, _from, state), do: {:reply, state.categories, state}

  @impl true
  def handle_cast({:refresh, :ads}, state) do
    {:noreply,
     %{
       ads: QCEC.list_all_ads(),
       categories: state.categories
     }}
  end

  @impl true
  def handle_cast({:refresh, :categories}, state) do
    {:noreply,
     %{
       ads: state.ads,
       categories: QCEC.list_all_categories()
     }}
  end
end
