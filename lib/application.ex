defmodule QCEC.Application do
  use Application

  @impl true
  def start(_type, _args) do
    QCEC.Supervisor.start_link(name: QCEC.Supervisor)
  end

end
