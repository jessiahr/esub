# Esub
A simple event subscription system using OTP.

## Installation

```elixir
def deps do
  [
    {:esub, "~> 0.1.1"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/esub](https://hexdocs.pm/esub).

## Usage

```
# Process A
Esub.subscribe(:thermal_data, fn(event) ->
	# Sets a condition for which events in this channel you want to recieve.
	event.temp > 60
end)

# Process B
Esub.broadcast(:thermal_data, temp_event)

# Process A recieves a message:
{:new_event, :thermal_data, %{temp: 101}}

```