defmodule OrderApiWeb.Schema do
  use Absinthe.Schema

  alias OrderApiWeb.OrderResolver

  object :order do
    field :id, non_null(:id)
    field :balance_due, non_null(:string)
    field :description, non_null(:string)
    field :total, non_null(:string)
  end

  query do
    @desc "Get all orders"
    field :all_orders, non_null(list_of(non_null(:order))) do
      resolve(&OrderResolver.all_orders/3)
    end
  end

  mutation do
    @desc "Create a new order"
    field :create_order, :order do
      arg :balance_due, non_null(:string)
      arg :description, non_null(:string)
      arg :total, non_null(:string)


      resolve &NewsResolver.create_order/3
    end
  end
end
