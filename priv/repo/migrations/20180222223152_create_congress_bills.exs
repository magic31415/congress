defmodule Congress.Repo.Migrations.CreateCongressBills do
  use Ecto.Migration

  def change do
    create table(:congress_bills) do
      add :bill_slug, :string
      add :congress, :integer

      timestamps()
    end

  end
end
