defmodule OrderApi.Repo.Migrations.AddIdempotencyKeyToPayments do
  use Ecto.Migration

  def change do
    alter table(:payments) do
      add :idempotency_key, :uuid, null: false
    end

    create unique_index(:payments, [:idempotency_key])
  end
end
