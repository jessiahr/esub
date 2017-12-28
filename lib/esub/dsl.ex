defmodule Esub.Dsl do
	def broadcast(event) do
    Esub.EventDispatcher.route_event(event)
	end

	def subscribe(filter) do
		Esub.EventDispatcher.route_event(filter)
	end
end