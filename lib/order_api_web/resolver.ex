defmodule OrderApiWeb.Resolver do
  alias OrderApi.{Orders, Payments}

  def all_orders(_root, _args, _info) do
    {:ok, Orders.list_orders()}
  end

  def create_order(_root, args, _info) do
    case Orders.create_order(args) do
      {:ok, order} ->
        {:ok, order}
      _error ->
        {:error, "could not create order"}
    end
  end

  def create_payment(_root, args, _info) do
    case Payments.create_payment(args) do
      {:ok, payment} ->
        {:ok, payment}
      _error ->
        {:error, "could not create payment"}
    end
  end

  def create_order_and_payment(_root, args, _info) do
    case Orders.create_order_with_payment(args) do
      {:ok, {order, payment}} ->
        {:ok,
          order
          |> Map.from_struct()
          |> Map.put(:amount, payment.amount)
          |> Map.put(:note, payment.note)}
      {:error, error} ->
        {:error, error}
    end
  end
end
