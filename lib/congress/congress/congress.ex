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

  # # BILL METHODS
  # def get_bill_count do
  # 	Repo.one(from b in Bill, select: count(b.id))
  # end

  # def get_bill(id) do
  # 	Repo.get!(Bill, id)
  # end

  # def get_bill_slug_by_id(id) do
  # 	get_bill(id).bill_slug
  # end

  # def pick_random_bill_except(old_slug) do
  # 	new_slug = get_bill_slug_by_id(:rand.uniform(get_bill_count())) # random id

  # 	if old_slug == new_slug do
  # 		pick_random_bill_except(old_slug)
  # 	else
  # 		get_propublica_request_body("#{congress_number()}/bills/#{new_slug}.json")
  # 	end
  # end

  # def get_new_bills do
  # 	get_propublica_request_body("#{congress_number()}/house/bills/enacted.json")
  # end

  # # VOTE METHODS
  # def get_session(date) do
  # 	date
  # 	|> String.split("-")
  # 	|> Enum.at(0)
  # 	|> Integer.parse
  # 	|> elem(0)
  # 	|> rem(2)
  # 	# odd years (rem = 1) are session 1, even years (rem = 0) are session 2
  # 	|> Kernel.*(-1)
  # 	|> Kernel.+(2)
  # end

  # def get_roll_call_info(chamber, votes) do
  # 		votes
	 #  	|> Enum.find(%{"roll_call": nil, "date": nil},
	 #  		           fn vote -> 
	 #  		             Map.get(vote, "chamber") == chamber
	 #  		           	   and String.contains?(Map.get(vote, "result"), "Passed")
	 #  		           end)
	 #  	|> Map.take(["roll_call", "date"])
  # end

  # defp get_vote_data(chamber, session, roll_call) do
  # 	get_propublica_request_body("#{congress_number()}/#{chamber}/sessions/#{session}/votes/#{roll_call}.json")
  # end

  # def get_vote_tally(chamber, votes, reps) do
  # 	roll_call_info = get_roll_call_info(chamber, votes)
  # 	roll_call = Map.get(roll_call_info, "roll_call")

  # 	if roll_call do
	 #  	vote_data = get_vote_data(chamber, get_session(Map.get(roll_call_info, "date")), roll_call)
		# 				  	|> get_results
		# 				    |> elem(1)
		# 				    |> Map.get("vote")

		# 	rep_votes =
		# 		if Enum.count(reps) do
		# 			Map.get(vote_data, "positions")
		# 			|> Enum.filter(fn pos -> Enum.member?(reps, pos["name"]) end)
		# 		else
		# 			nil
		# 		end

		# 	%{"total": Map.get(vote_data, "total"),
		#     "rep_votes": rep_votes}
	 #  end
  # end

  # def get_all_vote_info(votes, senator1, senator2, house_rep) do
  # 	%{"senate": get_vote_tally("Senate", votes, [senator1, senator2]),
  # 	  "house": get_vote_tally("House", votes, [house_rep])}
  # end

  # # MY REPS METHODS
  # def get_reps(address, zip) do
  # 	places = get_state_and_district(address, zip)
  # 	state = Map.get(places, :state)
  # 	district = Map.get(places, :district)
  # 	reps = Enum.concat(get_senators(state), get_house_rep(state, district))
  	
  # 	%{"state": state,
  # 		"district": district,
  # 		"senator1": Enum.at(reps, 0),
  # 	  "senator2": Enum.at(reps, 1),
  # 	  "house-rep": Enum.at(reps, 2)}
  # end

  # def get_state_and_district(address, zip) do
  # 	address_param = address
  # 	              |> String.split
  # 	              |> Enum.concat([zip])
  # 	              |> Enum.join("+")

  # 	places = get_google_request_body(
  # 		"representatives?address=#{address_param}&includeOffices=false&levels=country&"
  # 		  <> google_api_key())
		# 	  	 |> Poison.decode
		# 	  	 |> elem(1)
		# 	  	 |> Map.get("divisions")
		# 	  	 |> Map.keys
		# 	  	 |> Enum.at(-1)
		# 	  	 |> String.split(["/", ":"])

		# %{"state": Enum.at(places, 4), "district": Enum.at(places, 6) || "1"}
  # end

  # def get_senators(state) do
  # 	get_propublica_request_body("members/senate/#{state}/current.json")
  # 	|> Poison.decode
  # 	|> elem(1)
  # 	|> Map.get("results")
  # end

  # def get_house_rep(state, district) do
  # 	get_propublica_request_body("members/house/#{state}/#{district}/current.json")
  # 	|> Poison.decode
  # 	|> elem(1)
  # 	|> Map.get("results")
  # end
end
