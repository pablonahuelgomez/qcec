defmodule QCEC.Server do
  use GenServer

  # Client
  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def stop(server \\ __MODULE__) do
    GenServer.stop(server)
  end

  def get(action, server \\ __MODULE__)
  def get(:ads, server), do: GenServer.call(server, {:get, :ads})
  def get(:categories, server), do: GenServer.call(server, {:get, :categories})

  def refresh(action, server \\ __MODULE__)
  def refresh(:ads, server), do: GenServer.cast(server, {:refresh, :ads})
  def refresh(:categories, server), do: GenServer.cast(server, {:refresh, :categories})

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
