defmodule Congress.Bill do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias Congress.Repo
  alias Congress.Bill
  alias Congress.Congress

  schema "congress_bills" do
    field :bill_slug, :string
    field :congress, :integer

    timestamps()
  end

  @doc false
  def changeset(%Bill{} = bill, attrs) do
    bill
    |> cast(attrs, [:bill_slug, :congress])
    |> validate_required([:bill_slug, :congress])
  end

  def get_bill_count do
    Repo.one(from b in Bill, select: count(b.id))
  end

  def pick_random_bill_except(old_slug) do
    new_slug = get_bill_count() |> :rand.uniform |> get_bill_slug_by_id

    if old_slug == new_slug do
      pick_random_bill_except(old_slug)
    else
      Congress.get_propublica_request_body("#{Congress.congress_num}/bills/#{new_slug}.json")
    end
  end

  def get_new_bills do
    Congress.get_propublica_request_body("#{Congress.congress_num}/house/bills/enacted.json")
  end

  defp get_bill_slug_by_id(id) do
    Repo.get!(Bill, id).bill_slug
  end
end
