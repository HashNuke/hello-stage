defmodule DemandBuffer do
  defstruct events: :queue.new(), pending_demand: 0


  def add_events(buffer, events) when is_list(events) do
    new_queue = append_to_queue(buffer.events, events)
    %__MODULE__{buffer | events: new_queue}
  end


  def register_demand(buffer, new_demand) do
    new_pending_demand = buffer.pending_demand + new_demand
    %__MODULE__{buffer | pending_demand: new_pending_demand}
  end


  # No pending events to send
  def get_pending_demand(%__MODULE__{pending_demand: 0, events: _} = buffer) do
    {:ok, buffer, []}
  end


  def get_pending_demand(buffer) do
    {pending_events, new_queue} = pop_from_queue(buffer.events, buffer.pending_demand)
    new_pending_demand = buffer.pending_demand - length(pending_events)

    # Create new buffer
    new_buffer = %__MODULE__{pending_demand: new_pending_demand, events: new_queue}
    {:ok, new_buffer, pending_events}
  end


  defp append_to_queue(queue, []) do
    queue
  end


  defp append_to_queue(queue, [item | items]) do
    new_queue = :queue.in(item, queue)
    append_to_queue(new_queue, items)
  end


  defp pop_from_queue(queue, count) do
    pop_from_queue(queue, count, [])
  end


  defp pop_from_queue(queue, 0, items) do
    {items, queue}
  end


  defp pop_from_queue(queue, count, items) do
    case :queue.out(queue) do
      {:empty, _new_queue} ->
        {items, queue}
      {{:value, item}, new_queue} ->
        pop_from_queue(new_queue, count - 1, [item | items])
    end
  end
end
