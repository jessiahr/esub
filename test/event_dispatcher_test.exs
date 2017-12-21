defmodule EsubTest do
  use ExUnit.Case
  doctest Esub

  test "is started with application" do
    {:error, {:already_started, _pid}} = Esub.EventDispatcher.start_link(nil)
  end

  test "sets subscription filter for a module" do
  	filter = fn(_) -> true	end
    this_pid = self()
  	%Esub.EventDispatcher{bindings: %{^this_pid => func}} = Esub.EventDispatcher.subscribe(filter)
  	assert is_function(func)
  end

   test "filter is passed the event" do
    this_pid = self()
  	filter = fn(event) ->
  		send this_pid, {:fillter_called, event}
  		true	
  	end
  	Esub.EventDispatcher.subscribe(filter)
  	Esub.EventDispatcher.route_event(%{test: 1})
  	assert_receive {:fillter_called, %{test: 1}}
  end

  test "pid is sent events once subscription is added" do 
    filter = fn(event) ->
      true  
    end
    Esub.EventDispatcher.subscribe(filter)
    Esub.EventDispatcher.route_event(%{test: 1})
    assert_receive {:new_event, %{test: 1}}
  end


  test "fails gracefully when pid dies before message is recieved" do 
    filter = fn(event) ->
      true  
    end
    listener = spawn fn -> 
      Esub.EventDispatcher.subscribe(filter)
      receive do
        event -> IO.inspect(event)
      end
      assert_receive {:new_event, %{test: 1}}
    end
    Process.exit(listener, :kill)
    assert !Process.alive?(listener)
    Esub.EventDispatcher.route_event(%{test: 1})
  end
end
