defmodule GoBillManagerWeb do
  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, views, channels and so on.

  This can be used in your application as:

      use GoBillManagerWeb, :controller
      use GoBillManagerWeb, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define any helper function in modules
  and import those modules here.
  """

  # credo:disable-for-this-file Credo.Check.Readability.Specs
  def controller do
    quote do
      use Phoenix.Controller, namespace: GoBillManagerWeb

      import Plug.Conn
      import GoBillManagerWeb.Gettext
      alias GoBillManagerWeb.Router.Helpers, as: Routes
      alias GoBillManagerWeb.ErrorResponses
    end
  end

  def view do
    quote do
      use Phoenix.View,
        root: "lib/go_bill_manager_web/templates",
        namespace: GoBillManagerWeb

      # Import convenience functions from controllers
      import Phoenix.Controller,
        only: [get_flash: 1, get_flash: 2, view_module: 1, view_template: 1]

      # Include shared imports and aliases for views
      unquote(view_helpers())
    end
  end

  def router do
    quote do
      use Phoenix.Router

      import Plug.Conn
      import Phoenix.Controller
      unquote(verified_routes())
    end
  end

  def verified_routes do
    quote do
      use Phoenix.VerifiedRoutes,
        endpoint: GoBillManagerWeb.Endpoint,
        router: GoBillManagerWeb.Router,
        statics: []
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
      import GoBillManagerWeb.Gettext
    end
  end

  defp view_helpers do
    quote do
      # Import basic rendering functionality (render, render_layout, etc)
      import Phoenix.View

      import GoBillManagerWeb.ErrorHelpers
      import GoBillManagerWeb.Gettext
      alias GoBillManagerWeb.Router.Helpers, as: Routes
      unquote(verified_routes())
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
