defmodule Congress.Vote do
  alias Congress.Congress

  def get_all_vote_info(votes, senators, house_reps) do
    %{"senate": get_vote_tally("Senate", votes, senators),
      "house": get_vote_tally("House", votes, house_reps)}
  end

  defp get_vote_tally(chamber, votes, reps) do
    roll_call_info = get_roll_call_info(chamber, votes)

    if roll_call_info do
      vote_data = get_vote_data(chamber, roll_call_info)
      rep_votes = get_rep_votes(reps, vote_data)
      %{"total": Map.get(vote_data, "total"), "rep_votes": rep_votes}
    end
  end

  defp get_roll_call_info(chamber, votes) do
    case Enum.find(votes, fn v -> is_passing_vote?(v, chamber) end) do
      nil -> nil
      vote -> Map.take(vote, ["roll_call", "date"])
    end
  end

  defp get_vote_data(chamber, roll_call_info) do
    Congress.congress_num
    <> "/#{chamber}/sessions/"
    <> (roll_call_info |> Map.get("date") |> get_session())
    <> "/votes/"
    <> (roll_call_info |> Map.get("roll_call"))
    <> ".json"

    |> Congress.get_propublica_request_body
    |> Congress.get_results
    |> elem(1)
    |> Map.get("vote")
  end

  defp get_rep_votes(reps, vote_data) do
    case Enum.count(reps) do
      0 -> nil
      _ -> for pos <- Map.get(vote_data, "positions"),
             Enum.member?(reps, pos["name"]), do: pos
    end
  end

  defp is_passing_vote?(vote, chamber) do
    Map.get(vote, "result") |> String.contains?("Passed")
      and Map.get(vote, "chamber") == chamber
  end

  defp get_session(date) do
    date
	  |> String.split("-")
	  |> Enum.at(0)
	  |> Integer.parse
	  |> elem(0)
	  |> rem(2)
    |> case do 1 -> "1"; 0 -> "2" end
  end
end
