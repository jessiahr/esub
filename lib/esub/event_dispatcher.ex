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

	def route_event(channel, event) do
	   GenServer.call(__MODULE__, {:route_event, channel, event})
	end

	def handle_call({:route_event, target_channel, event}, _from, state = %Esub.EventDispatcher{bindings: bindings}) do
		channel = bindings[target_channel]
		for {pid, filter} <- channel do
			if filter.(event) do
				send pid, {:new_event, target_channel, event}
			end
		end
    {:reply, state, state}
	end


	def subscribe(channel, filter) do
    GenServer.call(__MODULE__, {:subscribe, channel, filter})
	end

	def kill do
		GenServer.call(__MODULE__, {:kill})
	end

	def handle_call({:kill}, _from, state) do
		Process.exit(self(), :kill)
	end

	def handle_call({:subscribe, channel, filters}, {from, _ref}, state = %Esub.EventDispatcher{bindings: bindings}) do
		new_bindings = if bindings[channel] == nil do
			put_in(bindings, [channel], %{})
		else
			bindings
		end
	
		|> put_in([channel, from], filters)
		new_state = state
		|> Map.put(:bindings, new_bindings)
    {:reply, new_state, new_state}
	end
end
