defmodule Esub.EventDispatcher do
	require Logger
	use GenServer
	
	defstruct [:bindings]
	
	def start_link(_opts) do
		Logger.info("Starting EventDispatcher")
		GenServer.start_link(__MODULE__, nil, [name: __MODULE__])
	end

	def init(state) do
		{:ok, %Esub.EventDispatcher{bindings: %{}}}
	end

	def route_event(event) do
	    GenServer.call(__MODULE__, {:route_event, event})
	end

	def handle_call({:route_event, event}, _from, state) do
		for {pid, filter} <- state.bindings do
			if filter.(event) do
				send pid, {:new_event, event}
			end
		end
    {:reply, state, state}
	end


	def subscribe(filter) do
    GenServer.call(__MODULE__, {:subscribe, filter})
	end

	def kill do
		GenServer.call(__MODULE__, {:kill})
	end

	def handle_call({:kill}, _from, state) do
		Process.exit(self(), :kill)
	end

	def handle_call({:subscribe, filters}, {from, _ref}, state = %Esub.EventDispatcher{bindings: bindings}) do
		new_bindings = Map.put(bindings, from, filters)
		new_state = state
		|> Map.put(:bindings, new_bindings)
    {:reply, new_state, new_state}
	end
end