defmodule Esub.Dsl do
	def broadcast(channel, event) do
    Esub.EventDispatcher.route_event(channel, event)
	end

	def subscribe(channel, filter) do
		Esub.EventDispatcher.subscribe(channel, filter)
	end
end