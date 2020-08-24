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
      {Phoenix.PubSub, name: QCEC.PubSub},
      {QCEC.HTMLCacheServer, name: QCEC.HTMLCacheServer},
      {QCEC.HTMLServer, name: QCEC.HTMLServer},
      {QCEC.AdCacheServer, name: QCEC.AdCacheServer},
      {QCEC.AdServer, name: QCEC.AdServer},
      {QCEC.CategoryServer, name: QCEC.CategoryServer},
      {QCEC.Server, name: QCEC.Server}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
