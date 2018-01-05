defmodule Esub do
  @moduledoc false
  use Application
  defdelegate broadcast(channel, event), to: Esub.Dsl
  defdelegate subscribe(channel, filter), to: Esub.Dsl

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      {Esub.EventDispatcher, nil}

    ]
    opts = [strategy: :one_for_one, name: Esub.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
