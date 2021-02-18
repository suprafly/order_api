defmodule OrderApi.Repo.Migrations.CreateOrders do
  use Ecto.Migration

  def change do
    create table(:orders, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :description, :string
      add :total, :decimal
      add :balance_due, :decimal

      timestamps()
    end

  end
end
