defmodule QCEC.Application do
  @moduledoc """
  Simple Application
  """
  use Application

  @impl true
  def start(_type, _args) do
    QCEC.Supervisor.start_link(name: QCEC.Supervisor)
  end
end
