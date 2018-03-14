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

  def handle_in("bill-count", _payload, socket) do
    {:reply, {:ok, %{count: Bill.get_bill_count}}, socket}
  end

  def handle_in("reps", payload, socket) do
    {:reply, {:ok, Representative.get_reps(payload["address"], payload["zip"])}, socket}
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

    tallies = Vote.get_all_vote_info(results["votes"],
                                     payload["senators"],
                                     payload["houseReps"])

    {:reply, {:ok, Map.put(results, "tallies", tallies)}, socket}
  end

  def handle_in("first-votes", payload, socket) do
    {:reply, {:ok, Vote.get_all_vote_info(payload["votes"],
                                          payload["senators"],
                                          payload["houseReps"])}, socket}
  end

  def handle_in("later-votes", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end
end
