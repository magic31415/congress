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

  def get_bill(id) do
    Repo.get!(Bill, id)
  end

  def get_bill_slug_by_id(id) do
    get_bill(id).bill_slug
  end

  def pick_random_bill_except(old_slug) do
    new_slug = get_bill_slug_by_id(:rand.uniform(get_bill_count())) # random id

    if old_slug == new_slug do
      pick_random_bill_except(old_slug)
    else
      Congress.get_propublica_request_body("bills/#{new_slug}.json", true)
    end
  end

  def get_new_bills do
    Congress.get_propublica_request_body("house/bills/enacted.json", true)
  end
end
