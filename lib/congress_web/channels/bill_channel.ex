defmodule CongressWeb.BillChannel do
  use CongressWeb, :channel
  alias Congress.Bill
  alias Congress.Vote
  alias Congress.Representative
  alias Congress.Congress

  def join(chan, payload, socket) do
    if authorized?(payload) do
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end

  def handle_in("bill", payload, socket) do
    # picks a random bill by slug
    results = payload["number"]
            |> String.replace(".", "")
            |> String.downcase
            |> Bill.pick_random_bill_except
            |> Congress.get_results
            |> Map.take(["number", "title", "enacted",
                         "congressdotgov_url", "vetoed", "votes"])
    
    broadcast! socket, "bill", results
    get_tallies socket, results["votes"], payload["reps"]
    {:noreply, socket}
  end

  def handle_in("bill-count", payload, socket) do
    broadcast! socket, "bill-count", %{count: Bill.get_bill_count}
    {:noreply, socket}
  end

  def handle_in("reps", payload, socket) do
    broadcast! socket, "reps", Representative.get_reps(payload["address"], payload["zip"])
    {:noreply, socket}
  end

  def get_tallies(socket, votes, reps) do
    broadcast! socket, "tallies", %{"tallies": Vote.get_all_vote_info(votes,
                                                                      reps["senator1"],
                                                                      reps["senator2"],
                                                                      reps["house_rep"])}
    {:noreply, socket}
  end
end
