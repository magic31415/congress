defmodule Congress.Representative do
  alias Congress.Congress

  def get_reps(address, zip) do
  	places = get_state_and_district(address, zip)
  	state = Map.get(places, :state)
  	district = Map.get(places, :district)
  	reps = Enum.concat(get_senators(state), get_house_rep(state, district))
  	
  	%{"state": String.upcase(state),
  		"district": district,
  		"senator1": Enum.at(reps, 0),
  	  "senator2": Enum.at(reps, 1),
  	  "house-rep": Enum.at(reps, 2)}
  end

  def get_state_and_district(address, zip) do
  	address_param = address
  	              |> String.split
  	              |> Enum.concat([zip])
  	              |> Enum.join("+")

  	places = Congress.get_google_request_body(
  		"representatives?address=#{address_param}&includeOffices=false&levels=country&")
			  	 |> Poison.decode
			  	 |> elem(1)
			  	 |> Map.get("divisions")
			  	 |> Map.keys
			  	 |> Enum.at(-1)
			  	 |> String.split(["/", ":"])

		%{"state": Enum.at(places, 4), "district": Enum.at(places, 6) || "1"}
  end

  def get_senators(state) do
  	Congress.get_propublica_request_body("members/senate/#{state}/current.json", false)
  	|> Poison.decode
  	|> elem(1)
  	|> Map.get("results")
  end

  def get_house_rep(state, district) do
  	Congress.get_propublica_request_body("members/house/#{state}/#{district}/current.json", false)
  	|> Poison.decode
  	|> elem(1)
  	|> Map.get("results")
  end
end
