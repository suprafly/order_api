defmodule OrderApi.Repo.Migrations.CreatePayments do
  use Ecto.Migration

  def change do
    create table(:payments, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :amount, :decimal
      add :applied_at, :naive_datetime
      add :note, :string
      add :order_id, references(:orders, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:payments, [:order_id])
  end
end
