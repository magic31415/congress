defmodule Congress.Congress do

  # GENERAL METHODS
  defp propublica_base_path do
		"https://api.propublica.org/congress/v1/"
	end

	defp google_base_path do
		"https://www.googleapis.com/civicinfo/v2/"
	end

	defp congress_number do
		"115/"
	end

	defp propublica_api_key do
		Application.get_env(:congress, :propublica)
	end

	defp google_api_key do
		Application.get_env(:congress, :google)
	end

	def get_propublica_request_body(url_end, include_congress_number) do
		addition = if include_congress_number, do: congress_number(), else: ""

		get_curl_request_body(propublica_base_path() <> addition, url_end,
			                    ["X-API-Key": propublica_api_key()])
  end

  def get_google_request_body(url_end) do
  	get_curl_request_body(google_base_path(), url_end <> google_api_key(), [])
  end

  defp get_curl_request_body(url_base, url_end, headers) do
  	HTTPotion.get(url_base <> url_end, headers: headers).body
  end

  def get_results(response) do
  	response
  	|> Poison.decode
  	|> elem(1)
  	|> Map.get("results")
  	|> Enum.at(0)
  end
end
