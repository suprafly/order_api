defmodule OrderApi.Payments.Payment do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "payments" do
    field :amount, :decimal
    field :applied_at, :naive_datetime
    field :note, :string
    field :order_id, :binary_id
    # this field comes from the client and allows us to ensure
    # that the same payment is not processed twice.
    field :idempotency_key, Ecto.UUID, autogenerate: false

    timestamps()
  end

  @doc false
  def changeset(payment, attrs) do
    payment
    |> cast(attrs, [:amount, :applied_at, :note])
    |> validate_required([:amount, :applied_at, :note, :idempotency_key])
    |> unique_constraint(:idempotency_key)
  end
end
