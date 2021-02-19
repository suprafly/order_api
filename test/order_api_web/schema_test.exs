defmodule OrderApiWeb.SchemaTest do
  use OrderApiWeb.ConnCase, async: true

  describe "order_api graphql schema" do
    alias OrderApi.Orders

    @valid_attrs %{balance_due: "120.5", description: "some description", total: "120.5"}

    def order_fixture(attrs \\ %{}) do
      {:ok, order} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Orders.create_order()

      order
    end

    setup do
      [order: order_fixture()]
    end

    test "get all orders", %{conn: conn, order: %{id: order_id}} do
      query = """
      {
        allOrders {
          id
        }
      }
      """
      resp =
        conn
        |> post("/api", %{query: query})
        |> json_response(200)

      assert resp == %{"data" => %{"allOrders" => [%{"id" => order_id}]}}
    end

    test "create new order", %{conn: conn} do
      query = """
      mutation {
        createOrder(balanceDue: "#{@valid_attrs.balance_due}", description: "#{@valid_attrs.description}", total: "#{@valid_attrs.total}")
        {
          id
          balanceDue
          description
          total
        }
      }
      """
      resp =
        conn
        |> post("/api", %{query: query})
        |> json_response(200)

      assert %{"data" => %{"createOrder" => %{
        "balanceDue" => "120.5",
        "description" => "some description",
        "id" => _,
        "total" => "120.5"}}} = resp
    end

    test "create new payment", %{conn: conn, order: %{id: order_id}} do
      key = Ecto.UUID.generate()
      query = """
      mutation {
        createPayment(orderId: "#{order_id}", amount: "10", note: "some note", idempotencyKey: "#{key}")
        {
          id
          orderId
          amount
          idempotencyKey
          note
        }
      }
      """
      resp =
        conn
        |> post("/api", %{query: query})
        |> json_response(200)

      assert %{"data" => %{"createPayment" => %{
        "amount" => "10",
        "note" => "some note",
        "id" => _,
        "orderId" => ^order_id,
        "idempotencyKey" => ^key}}} = resp
    end

    test "ensure payment idempotency", %{conn: conn, order: %{id: order_id}} do
      key = Ecto.UUID.generate()
      query = """
      mutation {
        createPayment(orderId: "#{order_id}", amount: "10", note: "some note", idempotencyKey: "#{key}")
        {
          id
          orderId
          amount
          idempotencyKey
          note
        }
      }
      """
      resp =
        conn
        |> post("/api", %{query: query})
        |> json_response(200)

      # the first payment succeeds
      assert %{"data" => %{"createPayment" => %{
        "amount" => "10",
        "note" => "some note",
        "id" => _,
        "orderId" => ^order_id,
        "idempotencyKey" => ^key}}} = resp

      resp =
        conn
        |> post("/api", %{query: query})
        |> json_response(200)

      # the second payment fails, because the idempotencyKey is the same
      assert %{
        "data" => %{"createPayment" => nil},
        "errors" => [
          %{
            "locations" => [%{"column" => 3, "line" => 2}],
            "message" => "could not create payment",
            "path" => ["createPayment"]
          }
        ]
      } = resp
    end

    test "create new order and payment", %{conn: conn} do
      key = Ecto.UUID.generate()
      order_args = """
      balanceDue: "#{@valid_attrs.balance_due}", description: "#{@valid_attrs.description}", total: "#{@valid_attrs.total}"
      """

      payment_args = """
      amount: "10", note: "some note", idempotencyKey: "#{key}"
      """

      query = """
      mutation {
        createOrderAndPayment(#{order_args} #{payment_args})
        {
          order {
            id
            balanceDue
            description
            total
          }
          payment {
            id
            orderId
            amount
            idempotencyKey
            note
          }
        }
      }
      """
      resp =
        conn
        |> post("/api", %{query: query})
        |> json_response(200)

      assert %{"data" =>
        %{
          "createOrderAndPayment" => %{
            "order" => %{
              "balanceDue" => "120.5",
              "description" => "some description",
              "id" => order_id,
              "total" => "120.5"
            },
            "payment" => %{
              "amount" => "10",
              "id" => _,
              "idempotencyKey" => ^key,
              "note" => "some note",
              "orderId" => payment_order_id
            }
          }
        }
      } = resp

      assert order_id == payment_order_id
    end
  end
end