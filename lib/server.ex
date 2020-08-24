defmodule QCEC.Server do
  use GenServer

  # Client
  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def stop(server \\ __MODULE__) do
    GenServer.stop(server)
  end

  def load_ads(server \\ __MODULE__) do
    GenServer.cast(server, :load_ads)
  end

  # Server
  @impl true
  def init(:ok) do
    {:ok, []}
  end

  @impl true
  def handle_cast(:load_ads, state) do
    :ok = QCEC.HTMLServer.fetch()

    {:noreply, state}
  end

end
