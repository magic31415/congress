defmodule Congress.Vote do
  alias Congress.Congress

  def get_session(date) do
  	date
  	|> String.split("-")
  	|> Enum.at(0)
  	|> Integer.parse
  	|> elem(0)
  	|> rem(2)
  	# odd years (rem = 1) are session 1, even years (rem = 0) are session 2
  	|> Kernel.*(-1)
  	|> Kernel.+(2)
  end

  def get_roll_call_info(chamber, votes) do
  		votes
	  	|> Enum.find(%{"roll_call": nil, "date": nil},
	  		           fn vote -> 
	  		             Map.get(vote, "chamber") == chamber
	  		           	   and String.contains?(Map.get(vote, "result"), "Passed")
	  		           end)
	  	|> Map.take(["roll_call", "date"])
  end

  defp get_vote_data(chamber, session, roll_call) do
  	Congress.get_propublica_request_body("#{chamber}/sessions/#{session}/votes/#{roll_call}.json", true)
  end

  def get_vote_tally(chamber, votes, reps) do
  	roll_call_info = get_roll_call_info(chamber, votes)
  	roll_call = Map.get(roll_call_info, "roll_call")

  	if roll_call do
	  	vote_data = get_vote_data(chamber, get_session(Map.get(roll_call_info, "date")), roll_call)
						  	|> Congress.get_results
						    |> elem(1)
						    |> Map.get("vote")

			rep_votes =
				if Enum.count(reps) do
					Map.get(vote_data, "positions")
					|> Enum.filter(fn pos -> Enum.member?(reps, pos["name"]) end)
				else
					nil
				end

			%{"total": Map.get(vote_data, "total"),
		    "rep_votes": rep_votes}
	  end
  end

  def get_all_vote_info(votes, senator1, senator2, house_rep) do
  	%{"senate": get_vote_tally("Senate", votes, [senator1, senator2]),
  	  "house": get_vote_tally("House", votes, [house_rep])}
  end
end
