defmodule QCEC.LinkParser do
  @doc """
  Parses the links

  ## Examples

      iex> QCEC.LinkParser.parse(["https://roberto.arlt", "https://api.whatsapp.com", "https://www.facebook.com/test", "https://instagram.com/test", "https://facebook.com/aira"])
      [
        %{link: "https://roberto.arlt", type: "www"},
        %{link: "https://api.whatsapp.com", type: "whatsapp"},
        %{link: "https://www.facebook.com/test", type: "facebook"},
        %{link: "https://instagram.com/test", type: "instagram"},
        %{link: "https://facebook.com/aira", type: "facebook"}
      ]
  """
  def parse(links) do
    links
    |> Enum.map(fn link ->
      %{link: link, type: define_link_type(link)}
    end)
  end

  defp define_link_type(link) do
    types = ["instagram", "facebook", "google", "whatsapp", "pedidosya"]

    Enum.find(types, "www", fn type ->
      String.contains?(link, type)
    end)
  end
end
