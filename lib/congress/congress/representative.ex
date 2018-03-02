defmodule Congress.Representative do
  alias Congress.Congress

  def get_reps(address, zip) do
  	places = get_state_and_district(address, zip)
  	state = Map.get(places, :state)
  	district = Map.get(places, :district)
  	reps = Enum.concat(parse_reps("members/senate/#{state}/current.json"),
                       parse_reps("members/house/#{state}/#{district}/current.json"))
  	
  	%{"state": String.upcase(state),
  		"district": district,
  		"senator1": Enum.at(reps, 0),
  	  "senator2": Enum.at(reps, 1),
  	  "house-rep": Enum.at(reps, 2)}
  end

  defp get_state_and_district(address, zip) do
  	places =
      Congress.get_google_request_body(
        "representatives?address="
        <> (String.split(address) |> Enum.concat([zip]) |> Enum.join("+"))
        <> "&includeOffices=false&levels=country&")
  	 
      |> Poison.decode
  	  |> elem(1)
  	  |> Map.get("divisions")
  	  |> Map.keys
  	  |> Enum.at(-1)
  	  |> String.split(["/", ":"])

		%{"state": Enum.at(places, 4), "district": Enum.at(places, 6) || "1"}
  end

  defp parse_reps(response) do
    response
    |> Congress.get_propublica_request_body()
    |> Poison.decode
    |> elem(1)
    |> Map.get("results")
  end
end
