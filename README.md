# HelloStage

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`

## Snippets

Try these in an iex console. Start one with `iex -S mix`.

### Simple producer & consumer

```
SimpleProducer.notify("hello")
Enum.map(1..10, fn(i)-> SimpleProducer.notify("hello #{i}") end)
```

### Simple producer & consumer with demand limits

Send 10 events

```
events = Enum.map(1..10, fn(i)-> "hello #{i}" end)
SimpleProducer.notify(events)
```

Send 20 events

```
events = Enum.map(1..20, fn(i)-> "hello #{i}" end)
SimpleProducer.notify(events)
```

### Good producer & consumer

```
events = Enum.map(1..10, fn(i)-> "hello #{i}" end)
GoodProducer.notify(events)
```

### HNSearch

```
HNSearch.Producer.notify(["apple", "microsoft", "google"])
```

### BacklinkSearch

```
BacklinkSearch.Producer.notify(["apple", "microsoft", "google"])
```

### BacklinkSearchV2

```
BacklinkSearchV2.Producer.notify(["apple", "microsoft", "google"])
```
