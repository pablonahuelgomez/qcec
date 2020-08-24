![Elixir CI](https://github.com/pablonahuelgomez/qcec/workflows/Elixir%20CI/badge.svg?branch=master)

# QCEC
QCEC is an OTP application which collects and retrieves information from [Quilmes Compra En Casa](https://quilmes.gov.ar/servicios/compra_en_casa.php).

QCEC fetches html information from the site using:

```bash
qcec $ iex -S mix
```

```elixir
# Wait for it, a logger will list fetched & parsed categories
iex> :ok = QCEC.Server.load_ads
```

And that's it with scraping. QCEC stores the parsed and fetched information in ETS tables, making them accessible via this API:

```elixir
iex> {:ok, ads} = QCEC.AdServer.lookup :bakery
iex> hd(ads)
%QCEC.Ad{
  address: "Example",
  category_name: :bakery,
  city: "City",
  image_url: "url",
  links: [
    %{
      link: "https://maps.google.com/",
      type: "google"
    },
    %{link: "https://www.facebook.com/etc/", type: "facebook"},
    %{link: "https://www.instagram.com/etc/", type: "instagram"},
    %{
      link: "https://api.whatsapp.com/etc",
      type: "whatsapp"
    }
  ],
  responsible: "etc",
  title: "etc",
  whatsapp: "etc"
}
```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `qcec` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:qcec, "~> 0.1.0"}
  ]
end
```

