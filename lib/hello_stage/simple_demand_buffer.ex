defmodule SimpleDemandBuffer do
  defstruct events: [], pending_demand: 0

  def add_events(buffer, events) when is_list(events) do
    new_events_list = buffer.events ++ events
    %__MODULE__{buffer | events: new_events_list}
  end


  def register_demand(buffer, new_demand) do
    new_pending_demand = buffer.pending_demand + new_demand
    %__MODULE__{buffer | pending_demand: new_pending_demand}
  end


  def pending_demand?(buffer) do
    buffer.pending_demand != 0
  end


  def get_pending_demand(buffer) do
    {pending_events, new_events_list} = Enum.split(buffer.events, buffer.pending_demand)
    new_pending_demand = buffer.pending_demand - length(pending_events)

    # Create new buffer
    new_buffer = %__MODULE__{pending_demand: new_pending_demand, events: new_events_list}
    {:ok, new_buffer, pending_events}
  end
end
