defmodule Tafl.Runtime.Application do
  @supervisor_name GameStarter

  use Application

  # The runtime kicks off this application (an "application" is an
  # independent entity that starts itself and manages it's own
  # lifecycle. The application starts with a Supervisor.
  # That supervisor starts a DynamicSupervisor. A DynamicSupervisor
  # waits to start child processes until instructed. When a client
  # wants to start a game, the request goes to the DynamicSupervisor.
  # Starting a game means starting a game GenServer. There can be
  # many games started, each as their own GenServer. Think of this
  # node as a "service" which can create many game "servers".

  # By design, all of the above can run in it's own node, and clients
  # can connect to the node. After connecting and requesting to start
  # a game, the client receives the pid from the DynamicSupervisor
  # and interacts with that GenServer via that pid. This keeps the
  # client runtime thin because it does not need to run the game
  # server, (although it needs the code to access the API) - the
  # client does not have the responsibility of starting the GenServer
  # directly (it requests it from the service). This also allows the
  # application's node to isolate information from the client.

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
