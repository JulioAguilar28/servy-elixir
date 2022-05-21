defmodule Servy.Parse do
  alias Servy.Conv

  def parse(request) do
    [top, params_string] = String.split(request, "\n\n")
    [request_line | _headers_string] = String.split(top, "\n")
    [method, path, _] = String.split(request_line, " ")
    params = parse_params(params_string)

    %Conv{method: method, params: params, path: path}
  end

  defp parse_params(params), do: params |> String.trim() |> URI.decode_query()
end
