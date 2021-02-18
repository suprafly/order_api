defmodule OrderApiWeb.OrderResolver do
  alias OrderApi.Orders

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
end
