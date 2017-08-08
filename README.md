# HelloStage

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](http://www.phoenixframework.org/docs/deployment).

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: http://phoenixframework.org/docs/overview
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix

## Snippets

### Simple producer & consumer

```
SimpleProducer.notify("hello")
Enum.map(1..10, fn(i)-> SimpleProducer.notify("hello #{i}") end)
```

### Simple producer & consumer with demand limits

```
events = Enum.map(1..10, fn(i)-> "hello #{i}" end)
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
