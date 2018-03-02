defmodule Congress.Congress do

  # GENERAL METHODS
	def congress_num do
		"115"
	end

	def get_propublica_request_body(url_end) do
		get_curl_request_body("https://api.propublica.org/congress/v1/",
			                    url_end,
			                    ["X-API-Key": Application.get_env(:congress, :propublica)])
  end

  def get_google_request_body(url_end) do
  	get_curl_request_body("https://www.googleapis.com/civicinfo/v2/",
  		                    url_end <> Application.get_env(:congress, :google),
  		                    [])
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
