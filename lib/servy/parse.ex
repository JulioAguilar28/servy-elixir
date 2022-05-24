defmodule Servy.Parse do
  alias Servy.Conv

  def parse(request) do
    [top, params_string] = String.split(request, "\n\n")
    [request_line | header_line] = String.split(top, "\n")
    [method, path, _] = String.split(request_line, " ")
    headers = parse_headers(header_line, %{})
    params = parse_params(headers["Content-Type"], params_string)

    %Conv{method: method, params: params, headers: headers, path: path}
  end

  defp parse_params("application/x-www-form-urlencoded", params),
    do: params |> String.trim() |> URI.decode_query()

  defp parse_params(_, _), do: %{}

  defp parse_headers([head | tail], headers) do
    [key, value] = String.split(head, ": ")
    headers = Map.put(headers, key, value)
    parse_headers(tail, headers)
  end

  defp parse_headers([], headers), do: headers
end
