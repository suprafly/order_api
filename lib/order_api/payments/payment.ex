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

    timestamps()
  end

  @doc false
  def changeset(payment, attrs) do
    payment
    |> cast(attrs, [:amount, :applied_at, :note])
    |> validate_required([:amount, :applied_at, :note])
  end
end
