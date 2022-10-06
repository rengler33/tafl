# tafl

WIP.

Implementation of a game known as Tafl. Eventually the Copenhagen Hnefatafl rules will be implemented. [See rules here](http://tafl.cyningstan.com/page/768/copenhagen-hnefatafl-rules).

Current clients include:

- text client WIP

Future clients include:

- phoenix

## To Play

Start the tafl app in one terminal and give it a shortname of `tafl`:

```sh
cd tafl/
iex --sname tafl -S mix
```

In another terminal run the text client, giving it any shortname like `c1`. Then run `TextClient.start` to play.

```sh
cd text_client/
iex --sname c1 -S mix
TextClient.start
```

## Next Steps
- [x] implement the basic working game (none of the additional "Copenhagen" rules)
- [x] build a text-based client
- [ ] build full test suite of game implementation
- [ ] build a game server registry for running & accessing many games by random name
- [ ] implement the copenhagen rules (shieldwall capture & surrounding the king)
- [ ] build phoenix client

## Application Design

The runtime kicks off the Tafl application. This application is meant to run in its own node. An "application" is an independent entity that starts itself and manages it's own lifecycle.

The application starts with a Supervisor. That supervisor starts a DynamicSupervisor. A DynamicSupervisor waits to start child processes until instructed, and then supervisors them. When a client wants to start a game, the request goes to the DynamicSupervisor.

Starting a game means starting a game GenServer. There can be many games started, each as their own GenServer. Think of this application node as a "service" which can create many game "servers".

Clients can connect to the node. After connecting and requesting to start a game, the client receives the pid from the DynamicSupervisor and interacts with that GenServer via that pid. This keeps the client runtime thin because it does not need to run the game server, (although it needs the code to access the API) - the client does not have the responsibility of starting the GenServer directly (it requests it from the service). This also allows the application's node to isolate information from the client.

