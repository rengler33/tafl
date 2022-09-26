defmodule Tafl.Runtime.Application do
  @supervisor_name GameStarter

  use Application

  def start(_type, _args) do
    supervisor_spec = [
      {DynamicSupervisor, strategy: :one_for_one, name: @supervisor_name}
    ]

    Supervisor.start_link(supervisor_spec, strategy: :one_for_one)
  end

  def start_game do
    DynamicSupervisor.start_child(@supervisor_name, {Tafl.Runtime.Server, nil})
  end
end
