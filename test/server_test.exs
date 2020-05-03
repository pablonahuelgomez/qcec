defmodule QCECTest.Server do
  use ExUnit.Case, async: true

  setup do
    server = start_supervised!(QCEC.Server)
    %{server: server}
  end

  test "default ads are empty", %{server: server} do
    assert QCEC.Server.get(:ads, server), []
  end

  test "default categories are empty", %{server: server} do
    assert QCEC.Server.get(:categories, server), []
  end
end
