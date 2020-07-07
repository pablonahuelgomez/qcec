defmodule QCEC.LinkParser do
  @doc """
  Parses the links

  ## Examples

      iex> QCEC.LinkParser.parse(["https://roberto.arlt", "https://api.whatsapp.com", "https://www.facebook.com/test"])
      [
        %{link: "https://roberto.arlt", type: "www"},
        %{link: "https://api.whatsapp.com", type: "whatsapp"},
        %{link: "https://www.facebook.com/test", type: "facebook"}
      ]
  """
  def parse(links) do
    links
    |> Enum.map(fn link ->
      %{link: link, type: define_link_type(link)}
    end)
  end

  defp define_link_type(link) do
    striped = link |> String.split(".")
    types = ["instagram", "facebook", "google", "whatsapp", "pedidosya"]

    case Enum.find(striped, "www", fn x ->
           Enum.member?(types, x)
         end) do
      nil -> nil
      type -> type
    end
  end
end
