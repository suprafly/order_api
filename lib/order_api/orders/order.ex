defmodule OrderApi.Orders.Order do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "orders" do
    field :balance_due, :decimal
    field :description, :string
    field :total, :decimal

    has_many :payments, OrderApi.Payments.Payment

    timestamps()
  end

  @doc false
  def changeset(order, attrs) do
    order
    |> cast(attrs, [:description, :total, :balance_due])
    |> validate_required([:description, :total, :balance_due])
  end
end
