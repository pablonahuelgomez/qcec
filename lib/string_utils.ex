defmodule StringUtils do
  def capitalize(text) do
    text
    |> String.split()
    |> Enum.map(&String.capitalize/1)
    |> Enum.join(" ")
  end

  def raw_binary_to_string(raw) do
    string = raw |> String.codepoints() |> helper()
    case String.valid?(string) do
      true  -> string
      false -> ""
    end
  end

  defp helper([]), do: ""

  defp helper(codepoints) do
    Enum.reduce(
      codepoints,
      fn w, result ->
        <<parsed, _::binary>> = w
        result <> <<parsed::utf8>>
      end
    )
  end
end
