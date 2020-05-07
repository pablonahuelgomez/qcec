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

  def fetch_html(server \\ __MODULE__) do
    GenServer.cast(server, {:fetch_html})
  end

  # Server
  @impl true
  def init(:ok) do
    {:ok, %{ads: [], categories: [], documents: []}}
  end

  @impl true
  def handle_call({:get, :ads}, _from, state), do: {:reply, state.ads, state}
  @impl true
  def handle_call({:get, :categories}, _from, state), do: {:reply, state.categories, state}

  @impl true
  def handle_cast({:refresh, :ads}, state) do
    {:noreply,
     %{
       ads: QCEC.Parser.parse_ads(state.documents),
       categories: state.categories,
       documents: state.documents
     }}
  end

  @impl true
  def handle_cast({:refresh, :categories}, state) do
    {:noreply,
     %{
       ads: state.ads,
       categories: QCEC.Parser.parse_categories(state.documents),
       documents: state.documents
     }}
  end

  def handle_cast({:fetch_html}, state) do
    {:noreply,
     %{
       ads: state.ads,
       categories: state.categories,
       documents: QCEC.Scraper.fetch_html_pages()
     }}
  end
end
