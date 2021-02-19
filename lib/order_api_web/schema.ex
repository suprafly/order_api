defmodule OrderApiWeb.Schema do
  use Absinthe.Schema

  alias OrderApiWeb.Resolver

  import_types Absinthe.Type.Custom

  object :order do
    field :id, non_null(:id)
    field :balance_due, non_null(:string)
    field :description, non_null(:string)
    field :total, non_null(:string)
    field :payments_applied, list_of(:payment)
  end

  object :payment do
    field :id, non_null(:id)
    field :amount, non_null(:string)
    field :applied_at, :naive_datetime
    field :note, non_null(:string)
    field :order_id, non_null(:id)
    field :idempotency_key, non_null(:string)
  end

  object :order_and_payment do
    field :order, :order do
      resolve &Resolver.order/2
    end

    field :payment, :payment do
      resolve &Resolver.payment/2
    end
  end

  query do
    @desc "Get all orders"
    field :all_orders, non_null(list_of(non_null(:order))) do
      resolve(&Resolver.all_orders/3)
    end
  end

  mutation do
    @desc "Create a new order"
    field :create_order, :order do
      arg :balance_due, non_null(:string)
      arg :description, non_null(:string)
      arg :total, non_null(:string)

      resolve &Resolver.create_order/3
    end

    @desc "Create a new payment"
    field :create_payment, :payment do
      arg :order_id, non_null(:id)
      arg :amount, non_null(:string)
      arg :note, non_null(:string)

      resolve &Resolver.create_payment/3
    end

    @desc "Place order and pay"
    field :create_order_and_payment, :order_and_payment do
      # order fields
      arg :balance_due, non_null(:string)
      arg :description, non_null(:string)
      arg :total, non_null(:string)

      # payment fields
      arg :amount, non_null(:string)
      arg :note, non_null(:string)
      arg :idempotency_key, non_null(:string)

      resolve &Resolver.create_order_and_payment/3
    end
  end
end
