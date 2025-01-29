defmodule GoBillManagerWeb.Router do
  use GoBillManagerWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api/v1", GoBillManagerWeb do
    pipe_through :api

    scope "/employees", as: :employees do
      resources "/employee", EmployeeController,
        only: [:create, :index, :show],
        as: :employee,
        name: :employee
    end

    scope "/bills", as: :bills do
      resources "/bill", BillController,
        only: [:create, :index, :show],
        as: :bill,
        name: :bill
    end

    scope "/customer_tables", as: :customer_tables do
      resources "/customer_table", CustomerTableController,
        only: [:create, :show, :index],
        as: :customer_table,
        name: :customer_table
    end

    scope "/customers", as: :customers do
      resources "/customer", CustomerController,
        only: [:create, :show, :index],
        as: :customer,
        name: :customer
    end

    scope "/products", as: :products do
      resources "/product", ProductController,
        only: [:create, :show, :index],
        as: :product,
        name: :product

      post "/product_bill", ProductController, :product_bill, as: :product_bill
    end
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: GoBillManagerWeb.Telemetry
    end
  end
end
