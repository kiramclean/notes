text-strong: #0f98af
header-emphasis: #0f98af
header-strong: #0f98af
text-emphasis: #0f98af

# Software For The Internet
## **With Phoenix**
<br>
### Kira McLean

_twitter.com/kiraemclean_
_github.com/kiramclean_

---

# About Me

^ A community group of people teaching themselves how to code through online courses and meetups.. how I learned to code and I love helping other poeple see how much fun it can be. And how accessible it is.

![inline, 15%](pitonneux.jpg) ![inline, 100%](sama.png) ![inline](mtlnewtech.png) 
![inline, 15%](ruby.png) ![inline, 8%](js.png)

---

# About Me

^ A community group of people teaching themselves how to code through online courses and meetups.. how I learned to code and I love helping other poeple see how much fun it can be. And how accessible it is.

![inline, 15%](pitonneux.jpg) ![inline, 100%](sama.png) ![inline](mtlnewtech.png) 
![inline, 15%](ruby.png) ![inline, 8%](js.png) ![inline, 50%](elixir.png)

---

Elixir → language

^ Elixir is a functional programming language that runs on the Erlang VM. It first appeared in 2011 and v1 was released in 2014. It was developed by Jose Valim, a rails core contributor, alledgedly out of his frustrations trying to make ruby apps handle concurrency. It's gaining popularity and used by some big companies for parts of their apps, including Pinterest, Moz, Bleacher Report, Brightcove. 

Erlang → also language, has own VM ("The BEAM")

^ Elixir compiles to Erlang byte code and runs on the Erlang VM (the BEAM). Erlang is a functional language developed in the 80s by Ericsson for use in the telecom industry.

^ Also lots of companies use Erlang for parts of their apps, like Heroku, WhatsApp, RabbitMQ, and it's huge in the telecom industry (the domain the language was built for). Ericsson developed Erlang originally and now it's popular throughout the industry, used by Motorola, Nokia, T-Mobile, etc.

Phoenix → web framework

^ Phoenix is a web framework written in Elixir. It's a full stack framework (comes with great front-end tooling and a database abstraction layer). It's similar to other MVC frameworks, although it doesn't really have "models" because Elixir is functional. So it's like Rails (Ruby), sort of like express (NodeJS), Django (Python), Play (Java/Scala). 

^ So, Phoenix and Elixir are new, but Erlang is relatively old and proven to be reliable for highly concurrent apps at scale. Elixir is just Erlang byte code, so you don't need to take much of a leap of faith to trust it.

^ It's also supported on many platform-as-a-service providers, like Heroku, Engine Yard, Digital Ocean, you can also deploy a container to AWS or or Google Container Engine, so there are apps running this in production.

![inline, 60%](elixir.png) ![inline, 90%](erlang.png) ![inline](phoenix.png) 

---

> Scaling web apps is hard.

^ I'm a web developer. I do mostly Ruby on Rails, also front-end stuff with different JavaScript frameworks. I haven't been doing it for that long, but I noticed that you quickly start to run to the same problems with web apps over and over again, especially when you try to scale them.

^ Building CRUD apps is really easy now, but most of our time is not spend in the CRUD-y parts of a web app, it's spent developing all the stuff behind the web interface, where all the business rules live.

^ There are some fundamental challenges in web development because of the nature of the internet and user expectations and Phoenix was built in some ways to address some of these problems. It's able to offer some unique solutions to these problems because of the Elixir language and the underlying Erlang VM. This is a talk about how Phoenix can help with some common challenges in web development.

---

# Web Apps

- Distributed

^ One hard thing about web development is that you have many people asking for many things from different places at the same time.

^ Some of your code runs on your server, some of your code runs on your users' browsers, some of it might live in a CDN. Even if you only have one web server, web apps are distributed by their nature. The code you write is running across tons of different machines.

---

# Web Apps

- Distributed
- Stateful

---

# Web Apps

- Distributed
- Stateful

#  ☹️

---

## Stateful App:

# [fit] One that changes 
# [fit] as you interact with it

---



---


---

^ Existing frameworks are really good at building usable, friendly UIs quickly, but these days most of our time as web developers is spent building the non-CRUD-y parts of web apps. Real businesses are being run on the internet and web apps are doing some real heavy lifting. Frameworks originally designed to make it easy to build web interfaces to a database sometimes struggle to meet more intense business requirements.

---

### Problem:

## Stateful apps communicating over a stateless protocol

^ HTTP is a stateless protcol, but people expect a stateful experience. That means that everytime you make an HTTP request, you have to send all the data required to fulfill the request. The server doesn't remember anything about the last time you asked it for something. It's like it's the first time it's ever heard about you every time.

^ We store state in databases and transmit it with cookies to simulate a stateful experience for the user, but this adds complexity. 

---

# To Deal With It

- Do a lot of things at the same time (**concurrent or async execution**)

^ We can offload state to a DB to solve some of our problems, but that means we're constantly querying the DB for information. You might also fetch data in real time from an external service, or query an internal microservice (like fancy data science stuff).

^ If you go down this path (doing many things at the same time) you have to make your code handle asynchronous execution. You will want to do some things things that take longer than others, and if you're running all the requests in the order they come in, you'll end up with something fast stuck behind something slow, which will jam up your app.

- Remember the last thing you did so you don't have to do so many things for each request (**stateful web servers**)

^ To make this approach work, you need a persistent connection to your client. For the web, this means using websockets. Having a connection to each client requires you keep the state of each connection in memory, which can consume a lot of system resources if you have a lot of connected clients at once. In most languages/frameworks these connections are expensive.

^ At first you might be able to just use a bigger machines, but CPU processors aren't getting much faster anymore so eventually this will mean using a machine with more cores. For that to make any difference your code has to be able to use multiple cores (to run concurrently).

^ Both of these approaches require some concurrency model. Your code has to be able to run asynchronously. Even better if it can handle maintaining tons of open connections, because then you can have a stateful server.

---



---

# Elixir's Concurrency Model 
## → Actor Model

- Super lightweight VM **processes**
- Each has a mail box
- Interact with each other **only** by sending messages to each others' mail boxes
- Memory is isolated to each process

^ Anything can run sin a process

^ There are many higher-level concurrency abstractions that rely on these processes for concurrent programming.

^ An elixir process can make decisions about itself and change its own state, can spawn more processes, and can send messages to other processes, that's pretty much it.

---

### Concurrent Programming in Elixir

# Most Basic Process

```elixir
iex> spawn(fn -> IO.puts("Hello from process") end)
Hello from process
#PID<0.82.0>
```

---

## Processes Run Concurrently

```elixir
defmodule Slow do
  def async(delays) do
    from_caller = self()
    delays
    |> Enum.map(&(spawn(fn -> send_message(&1, from_caller) end)))
    |> Enum.map(fn pid -> receive_message(pid) end)
  end

  defp send_message(delay, back_to_caller) do
    :timer.sleep(delay)
    send(back_to_caller, {self(), "Waited #{delay}ms"})
  end

  defp receive_message(pid) do
    receive do
      {^pid, message} -> {pid, message}
    end
  end
end
```

---

### Only takes as long as the slowest process

```elixir
delays = [1000, 1300, 1500, 1700, 2000, 2500] # milliseconds

defmodule Slow do
  def time_this(delays, fun) do
    before = System.monotonic_time(:millisecond)
    fun.(delays)
    later = System.monotonic_time(:millisecond)
    (later - before) / 1000
  end
end

iex> Slow.async(delays)
[{#PID<0.687.0>, "Waited 1000ms"}, {#PID<0.688.0>, "Waited 1300ms"},
 {#PID<0.689.0>, "Waited 1500ms"}, {#PID<0.690.0>, "Waited 1700ms"},
 {#PID<0.691.0>, "Waited 2000ms"}, {#PID<0.692.0>, "Waited 2500ms"}]

iex> Slow.time_this(delays, &Slow.async/1)
2.501
```

---

## Processes Are Cheap

```elixir
delays = for _ <- 1..1000 do [] ++ Enum.random(500..2500) end

iex> Slow.time_this(delays, &Slow.async/1)
2.502


delays = for _ <- 1..10_000 do [] ++ Enum.random(500..2500) end

iex> Slow.time_this(delays, &Slow.async/1)
2.745
```

---

# Cheap Processes Make Concurrent Programming Easy

^ This is as basic as it gets, but even with these primitive processes you can do a lot of interesting things.

- Can link processes together so they receive exit notifications from each other (`spawn_link`)
- Can monitor a spawned process if you want updates but don't want to crash if the monitored process crashes (`spawn_monitor`)

---

# Concurrency Abstractions in Elixir

- **`Agent`**: maintains a state in memory that is set to the return value of a function that you pass it
- **`Task`**: simplifies linking and monitoring processes
- **`GenServer`**: maintains state and manages linking/monitoring

^ Agents are just processes with state

^ Tasks are also just processes but some of the stuff required to monitor and link them is abstracted away

^ GenServers maintain state and manage linking and monitoring

---

# Common Challenges in Web Development

^ These are 5 key requirements of modern web apps

1. Handle slow requests in a way that doesn't block the app for everyone else and makes sense for the current user

2. Access the same data at the same time from different places

3. Store the result of expensive or rate-limited requests

4. Run regularly scheduled background tasks

5. Handle errors in a minimally invasive way

^ If someone has to do a big import or export, or render a complicated dashboard, or something else that's slow, the app should not be affected for other users. Also even for that user the UI should make sense, showing them some indication of the progress or status

^ The app has to be able to handle multiple users trying to access the same resource at a time, or even a single user sending multiple updates for the same resource at a time

^ In a way that minimizes the effect for the user and is helpful for developers

^ Some caching is a result of bad performance and is used to reduce the resources required to fulfill a request, but other types of caching are useful and required even in super-performant web apps. Say you're fetching data from an external API, you don't want all your users hitting the external API everytime someone asks for it. You cache the result of the external request.

^ Every web app I've seen has some task it runs on a regular basis. Things that need to happen but it doesn't matter at precisely what time, like sending out reminder emails, updating something or deleting certain records that are in a particular state (like a 30-day soft-delete, building big reports/metrics, archiving inactive records) etc.

---

## Problem 1: 
#  Slow Requests

---

# Fix depends on what's causing them

1. Doing too much work
2. Waiting on too many things
3. Rendering a lot of stuff

---

### 1. Slow Requests
# Doing Too Much Work

```ruby
# in a batch import controller

def create
  params = parse_some_incoming_params
  upload_the_file_somewhere(params[:file])
  content = read_the_file(params[:file])
  data = parse_the_file(content)
  valid_data = validate_the_data(data)
  create_a_bunch_of_records(valid_data)

  redirect_to import_finished_path 
end

```
---

# [fit] Too slow!

![left](turtle.jpg)

^ This is not a reasonable amount of time to wait for web request. It will timeout most of the time.

---

### 1. Slow Requests
# Separate Worker Process

```ruby
def create
  import_options = parse_some_incoming_params
  # send to a separate worker process to deal with
  SlowImportJob.perform(import_options)
  send_the_user_somewhere
end
```

---

### 1. Slow Requests
# Separate Worker Process

```[.highlight: 4] ruby
def create
  import_options = parse_some_incoming_params
  # send to a separate worker process to deal with
  SlowImportJob.perform(import_options)
  send_user_somewhere
end
```

---

### 1. Slow Requests
# Separate Worker Process

- Requires external job queue (Sidekiq/Resque, in Ruby)
- Requires polling the job to check its status
- All jobs still run sequentially in your worker(s)
- All steps in that job still run sequentially (unless you send _those_ to other workers)
  
^ You still need many workers to handle a lot of these jobs if you have 100 people trying to do this at once.

^ You might not be waiting for a response in the UI anymore, but you will still need multiple queues to make sure a slow job doesn't back up all the other faster jobs you're trying to do async.

---

### 1. Slow Requests
# Elixir Processes

```elixir
# in batch import controller

def create(conn, %{"import" => import_params}) do
  # send to a supervised process to deal with
  Task.Supervisor.async_nolink(MyApp.TaskSupervisor, fn ->
    BulkImport.create(import_params)
  )
  send_user_somewhere
end
```

---

### 1. Slow Requests
# Elixir Processes 

- As many processes as you want  
- Streaming results to the client is as option
- Keeping your connection with a web socket is an option

^ Every job (and every sub-task of every job) gets its own process

---

### 1. Slow Requests
# Waiting on Too Many Things

```ruby
# in a checkouts controller

def new
  fetch_tax_rate
  fetch_fedex_shipping_rate
  fetch_local_carrier_shipping_rate
  run_through_fraud_detection
  reserve_items_in_cart
  show_this_all_to_user
end
```

---

### 1. Slow Requests
# Waiting on Too Many Things

- Those will run sequentially
- Each one blocks the request from continuing
- If one fails the whole request fails
- Some don't matter for the UI

---

### 1. Slow Requests
# Async Requests

^ Typically done client-side

```[.highlight: 1, 4, 14, 19-20] js
let xmlRequest = new XMLHttpRequest()
let result = null

xmlRequest.onreadystatechange = function() {
  if (xmlRequest.readyState === XMLHttpRequest.DONE) {
    if (xmlRequest.status === 200) {
      result = xmlRequest.responseText
    } 
    else if (xmlRequest.status === 400) { alert("Something went wrong") } 
    else if (...) { alert("Something bad happened") }
  }
}

xmlRequest.onloadend = function() {
  document.querySelector(".my-dom-element").innerHTML = xmlRequest.responseText
}

xmlRequest.setRequestHeader(...)
xmlRequest.open("GET", "http://someapi.com/endpoint", true) // true means async
xmlRequest.send()
```

^ Client-side authentication is hard (when you want just clients talking to clients wtihout going through your server). A lot of solutions go through your server, where the API secret is safely stored, but then you're just back where you started with all the pitfalls of your slow server.

^ Can do something similar like this server-side, but (at least with Ruby) you will have the same problems. The concurrency model is the Reactor pattern, where everything runs in a single-threaded event loop, so although you can leverage the concurrent nature of external systems like the internet or your DB, now you have to write your code in a convoluted callback style. Also you have to deal with errors in each request so if one fails with an unhandled error it doesn't blow up your whole request.

---

### 1. Slow Requests
# Async Requests

- Client-side authentication is worse than server-side authentication
- Writing code in this kind of callback style is hard to debug and annoying to maintain
- How do you make sure the session ends up in a valid state?

^ When you have a bunch of ajax requests getting fired off on a page you can't use the session reliably anymore because you can't know in what order the requests are going to come back in. 

--- 

### 1. Slow Requests
# Elixir Processes 

```elixir
def new(conn, %{"some_param" => some_param}) do
  tax_rate = Task.async(fn -> TaxService.find(some_param) end)
  shipping_rate = Task.async(fn -> ShippingService.get_rate(some_param) end)
  other_rate = Task.async(fn -> OtherService.get_rate(some_param) end)

  # things the UI doesn't care about:
  Task.Supervisor.async_nolink MyApp.TaskSupervisor, fn ->
    FraudDetection.log_this_cart(some_param) end)

  Task.Supervisor.async_nolink MyApp.TaskSupervisor, fn ->
    InventoryManagement.reserve_these_things(some_param) end)

  render(conn, "show.html", tax_rate: Task.await(tax_rate),
                            shipping_rate: Task.await(shipping_rate),
                            other_rate: Task.await(other_rate))
end
```

---

### 1. Slow Requests
# Rendering a Lot of Stuff

```html
<section class="products">
  <!-- for every product in a collection -->
    <product-description-partial>
    <product-images-carousel>
    <product-special-info-banner-partial>
    <product-pricing-partial>
<section>
```

---

### 1. Slow Requests
# Many Levels of Caching

- Concatenating partials can be slow
- Use different caching strategies at different levels to reduce the demand on your server

---

### 1. Slow Requests
# Performance is Not an Issue in Phoenix

- Templates just get compiled to functions
- Erlang is super fast at string IO

---

## Problem 2:
# Sharing Data Safely

---

### 2. Sharing Data Safely
# Shared Mutable State

```ruby
class ShippingRates
  def initialize(items, destination)
    @items = items
    @destination = destination
  end

  def fetch_rates
    CarrierAPIWrapper.find_rates(@items, @destination) 
  end
end
```

^ There are also a lot of more obvious violations -- global variables, class variables, constants are all shared between threads, but even if you eliminate those it is still really easy to write code with race conditions when you're dealing with mutable data. Whenever you hand off one class' instance variable to another class, you have to manually keep track of the state of that variable now, and remember how to keep it valid.

^ It's easy to be undisciplined and reach through objects to find out things you shouldn't know about

^ It's easy to pass things around without thinking of consequences 

^ Can piggy-back on database's transactional memory for persisted data

---

### 2. Sharing Data Safely
# Shared Mutable State

```ruby
class ShippingRates
  def initialize(items, destination)
    @items = items # an array of things, arrays are mutable
    @destination = destination
  end

  def fetch_rates
    # you don't own this library code
    CarrierAPIWrapper.find_rates(@items, @destination) 
  end
end
```

---

### 2. Sharing Data Safely
# Accessing Data You Shouldn't

```ruby
class ShoppingCart
  def initialize(products)
    @products = products
  end

  def checkout
    # ... do checkout
  
    stock_items = @products.map(&:stock_item)
    stock_items.update_all(sold: true)
  end
end
```

---

### 2. Sharing Data Safely
# Accessing Data You Shouldn't

```ruby
class ShoppingCart
  def initialize(products)
    @products = products
  end

  def checkout
    # ... do checkout
  
    # Wrong place -- you own the array of products, not the products
    # themselves, and definitely not the children of the products
    stock_items = @products.map(&:stock_item)
    stock_items.update_all(sold: true)
  end
end
```

---
### Typical Web App
# Manual Locks for Un-threadsafe Ops

```ruby
@variable ||= initialize_variable
```

 ↓

```ruby
lock = Mutex.new

lock.synchronize do
  @variable ||= initialize_variable
end
```

---

### Typical Web App
# Manual Locks for Un-threadsafe Ops

```ruby
@counter += 1
```

 ↓

```ruby
lock = Mutex.new

lock.synchronize do
  @counter += 1
end
```


---

### Phoenix App
# You Have to Send a Message

- In Elixir everything runs in its own (VM) process
- The only way to communicate between process is to send a message (**no shared state**)
- Data structures are **immutable**
- Mailbox messages are processed serially 

---

### Phoenix App
# You Have to Send a Message

```elixir
defmodule ShippingRates
  def find_rates(items, destination) # immutable data
    CarrierAPIWrapper.find_rates(items, destination)
  end
end

# in my checkout controller
def create

end
```

---

### Problem 3: Caching
# Dependencies

^ low-level caching, like for rate limited requests or expensive calculations

- Shared, high-performace storage (**memcached**, requires own server)
- Framework-specific (not included in most languages)

---

### 3: Caching

# Erlang Term Storage

- Constant-time in-memory tuple store
- Comes with Erlang
- **DETS** is similar but disk-based

^ A super efficient, built-in in-memory store. Lives in a process, so when that process dies you lose the table, which you can prevent by supervising the process and backing up the data

---

### Phoenix App

# Erlang Term Storage

```elixir
iex(1)> :ets.new(:fancy_erlang_cache, [:set, :private, :named_table])
:fancy_erlang_cache

iex(2)> :ets.insert(:fancy_erlang_cache, {"cache key", "some value"})
true

iex(3)> :ets.lookup(:fancy_erlang_cache, "cache key")
[{"cache key", "some value"}]
```

---

# Scheduling

_Without Phoenix:_ Cron hooked up to your background job queue
_With Phoenix_: `GenServer` + `Process.send_after/3`, or erlang cron-like library

TODO: Releasing inventory in carts

** The Mailbox for a process acts as a transaction


---

```[.highlight: 1, 11, 16-17, 21-23, 26, 28] elixir
# inside a GenServer module

defmodule MyApp.DelayedWork do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    schedule_work()
    {:ok, state}
  end

  def handle_info(:work, state) do
    # Do the delayed work here
    schedule_work() # Reset the timer
    {:noreply, state}
  end

  defp schedule_work() do
    Process.send_after(self(), :work, 1 * 60 * 60 * 1000) # In 1 hour
  end
end

# in your supervision tree

worker(MyApp.DelayedWork, [])

```

^ Won't work if your app is being restarted a lot (like on a free heroku plan), then you need heroku scheduler or something else

---

## Problem 5:
# Error Handling

---

### 5: Error Handling
# Requirements

- Need to know when something fails
- Don't crash the whole app
- Restore it to a known state

---

```ruby
def perform
  read_the_file
  parse_the_file
  validate_the_data
  upload_the_file_somewhere
  create_a_bunch_of_records
end
```

---

```ruby
def perform
  read_the_file  # bad encoding?
  parse_the_file  # improperly formatted?
  validate_the_data  # invalid data?
  upload_the_file_somewhere  # network issues?
  create_a_bunch_of_records  # data integrity issues?
end
```

---

### 5: Error Handling
# Error Handling Code Everywhere

```ruby
def upload_the_file_somewhere
  # upload...
  rescue # timeout
  rescue # HTTP error from S3
  rescue # other "unexpected" exception
end
```

---

### 5: Error Handling
# Error Handling Code Everywhere

- If you knew all the exceptions your program is going to raise, wouldn't you just handle those cases?
- An unhandled exception will still crash your app

^ If you knew what all the exceptions were going to be, then wouldn't those exceptions be expected, not unexpected? And you could just write your code in a way that handles those cases?

^ The whole point of safe error handling is that errors you _don't_ expect are handled well.

---

### 3: Error Handling
# Supervised Processes

```ruby
  def upload_the_file_somewhere(op, config) do
    with {:ok, op} <- Upload.initialize(op, config) do
      op.src
      |> Stream.with_index(1)
      |> Task.async_stream(&Upload.upload_chunk!(&1, op, config),
        max_concurrency: Keyword.get(op.opts, :max_concurrency, 4),
        timeout: Keyword.get(op.opts, :timeout, 30_000),
      )
      |> Enum.to_list
      |> Enum.map(fn {:ok, val} -> val end)
      |> Upload.complete(op, config)
    end
  end
```

---

# Up to 5 Processes Already

- sidekiq/resque
- redis
- memcached
- cron
- app server itself

^ use unicorn for multiple processes, puma for multiple threads in a single process

---

# Before and After

^ Compare the stack you needed to get your full-scale web app up and running before and after phoenix

Requirement | Ruby | Elixir
---|---|---
Background jobs | Sidekiq/Resque | BEAM
Server-wide state | Redis | BEAM
Low-level caching | Memcached | ETS (BEAM)
Scheduled jobs | Cron | BEAM
App server | Puma/Unicorn | BEAM
HTTP Server | Nginx | BEAM
Crash recovery | Monit/God/Foreman | BEAM
Long-running requests | ActionCable (Ruby) | Phoenix Channels (BEAM)

^ Some frameworks can only handle one request at a time and spinning up new processes is not trivial, so you need tools to spin up multiple app servers (Unicorn) or a multi-threaded app server (Puma)

^ If you have multiple app servers running you need a web server in front of them to hand off requests (Nginx)

^ Slow background jobs block web requests, so they need to be sent to a background worker

^ Current implementations of web sockets are not performant enough to be relevant

^ Can't keep app servers up consistently to run scheudled jobs, so we add cron

^ No built-in tools to monitor all these moving parts, so we add more dependencies to monitor them (Monit, God, Foreman)

---

# Bonuses with Phoenix

- Very fast

^ Server-side rendering is so much faster because Erlang is really fast at string IO. It doesn't render a separate copy of each web page in memory for each client, it contructs pointers to the same pieces of immutable memory across requests.

^ It's not just better for your users, it makes for a much more pleasant development environment. Booting the app takes no time, so normal things that require booting the app (like running tests, migrating the db, booting a local server) are way faster, too. This is important.. I don't know about other languages but on the rails apps I've worked on nobody ever runs the whole test suite locally because it takes forever (just runs on CI).

- Great dev tools

^ You get live reloading built-in, proper front-end tooling (can also swap for anything that can compile your front-end code into a `static/` folder)

- Encourages lots of small pieces of code (**umbrella apps**)

^ With umbrella app structure keeping application concerns separate form interface concerns is easy and encouraged

^ Model programs around your data, as opposed to forcing data to fit into your program

- Scalable (**true concurrency**)

^ Elixir can truly take advantage of the multiple cores of your machine. Also OTP makes running your app(s) across multiple machines easy. So you can scale horizontally and vertically.

---

# Downsides

- Fewer external services like error monitoring, but Erlang has a lot of stuff built in

- Less library support (can use erlang libraries)

- Deployments

^ What happens to running processes? Have to think about finishing running processes

^ Erlang 20 supports responding to sigterm, so you can have a clean shutdown of the VM

^ Have to think about deployments more

---

# Consider Phoenix For:
- high throughput
- fast and consistent response times
- minimal (ms/year) downtime
- realtime updates
- bi-directional realtime communication

---

# For More

ETS: [https://elixirschool.com/lessons/specifics/ets/](https://elixirschool.com/lessons/specifics/ets/)

Cron-like Erlang apps: [Erlcron](https://github.com/erlware/erlcron), [Ecron](https://github.com/fra/ecron)

---

......


---



```

# Any time you pass one class's instance variable to another class, you can't be sure you'll get the same thing you expect.
# Anytime you lock more than one resource at the same time, you make it possible for a deadlock to happen (can prioritize your resources)
# Protect every shared memory access with a synchronizing lock (reading and writing)
# Check for extended computations that need to be atomic
# Have a strategy to avoid deadlock when you have multiple locks

# items in a cart
# pass those items to a bunch of services to do stuff to
# items can change out from under you!
# This cannot happen in elixir. Data structures are immutable.

- no loops with variables that change
- no variables (data structures are immutable), everything is a frozen constant
- no assignment, just pattern matching
- inifite recursion with tail recursion, without stack overflow

- every thread needs its own stack
- classes are shared between all threads
- setting a method or a variable on a class is also shared between all threads

---

### Typical Web App
# Manual Locking

```ruby
DISABLE CONTEXT SWITCHING
  shopping_cart_instance.add(item)
RE-ENABLE CONTEXT SWITCHING
```





---

# Bonuses

- Code that is fun and easy to write (**programmer happiness**)
- Long term maintainability (when following best-practices)
- Scalable if our idea works
- High availability without high devops overhead  

^ Good development tooling (modern front-end build tools, live reload, fast tests)
















































