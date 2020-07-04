defmodule QCEC.Supervisor do
  @moduledoc """
  Simple Supervisor
  """
  use Supervisor

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  @impl true
  def init(:ok) do
    children = [
      {QCEC.HTMLCacheServer, name: QCEC.HTMLCacheServer},
      {QCEC.HTMLServer, name: QCEC.HTMLServer},
      {QCEC.AdCacheServer, name: QCEC.AdCacheServer},
      {QCEC.AdServer, name: QCEC.AdServer},
      {Phoenix.PubSub, name: QCEC.PubSub}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
