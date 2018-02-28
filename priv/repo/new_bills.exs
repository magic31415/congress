#
# Run with:
#
#		mix run priv/repo/new_bills.exs
#

import Ecto.Query
alias Congress.Repo
alias Congress.Bill
alias Congress.Congress

bills = Bill.get_new_bills
      |> Congress.get_results
      |> Map.get("bills")

Enum.each bills, fn bill ->
	[bill_slug, congress] = String.split(bill["bill_id"], "-")

	query = from b in Bill,
  	      where: b.bill_slug == ^bill_slug
  	      and b.congress == ^congress,
  	      select: b

  unless Repo.all(query) do
  	  Repo.insert! %Bill{bill_slug: bill_slug, congress: congress}
  	  IO.puts "#{bill_slug} added!"
  end
end
