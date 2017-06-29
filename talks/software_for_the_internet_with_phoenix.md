# Software For The Internet
## **With Phoenix**
<br>
### Kira McLean

#### _twitter.com/kiraemclean_
#### _github.com/kiramclean_

---

# About Me

- Software developer for Samasource

- Mentor for Les Pitonneux

^ A community group of people teaching themselves how to code through online courses and meetups.. how I learned to code and I love helping other poeple see how much fun it can be. And how accessible it is. A lot of people think programming is for an elite group of genuises only or something. But anybody can learn how to code and make a really great career out of it.

- Former researcher, painter, translator

- Programmer for the web (Ruby, JS)
<br>

![inline](sama.png) ![inline](pitonneux.jpg) ![inline](ruby.png) ![inline](js.png)

---

Elixir → language

^ Elixir is a functional programming language that runs on the Erlang VM. It first appeared in 2011 and v1 was released in 2014. It was developed by Jose Valim, a rails core contributor, alledgedly out of his frustrations trying to make ruby apps concurrent.

Erlang → also language, has own VM ("The BEAM")

^ Elixir compiles to Erlang byte code and runs on the Erlang VM (the BEAM). Erlang is a functional language developed in the 80s by Ericsson for use in the telecom industry.

^ It's gaining popularity and used by some big companies for parts of their apps, including Pinterest, Moz, Bleacher Report, Brightcove. Also lots of companies use Erlang for parts of their apps, like Heroku, WhatsApp, RabbitMQ, and it's huge in the telecom industry (the domain the language was built for). Ericsson developed Erlang originally and now it's popular throughout the industry, used by Motorola, Nokia, T-Mobile, etc.

Phoenix → web framework

^ Phoenix is a web framework written in Elixir. It's a full stack framework (comes with great front-end tooling and a database abstraction layer). It's similar to other MVC frameworks, although it doesn't really have "models" because Elixir is functional. You think of your content and content types as just data that flows through a pipeline, as opposed to models that correspond to DB tables. So it's like Rails (Ruby), sort of like express (NodeJS), Django (Python), Play (Java/Scala). 

^ So, Phoenix and Elixir are new, but Erlang is relatively old and proven to be reliable for highly concurrent apps at scale. Elixir is just Erlang byte code, so you don't need to take much of a leap of faith to trust it.

^ It's also supported on many platform-as-a-service providers, like Heroku, Engine Yard, Digital Ocean, you can also deploy a container to AWS or or Google Container Engine, so there are apps running this in production.

![inline, 60%](elixir.png) ![inline, 90%](erlang.png) ![inline](phoenix.png) 

---

> Scaling web apps is hard.

^ I'm a web developer. I do mostly Ruby on Rails, also front-end stuff with different JavaScript frameworks. I haven't been doing it for that long, but I noticed that you quickly start to run to the same problems with web apps over and over again, especially when you try to scale them.

^ Usually you don't run into problems until a lot of people start using your app at the same time. It's pretty easy to build something that will work for one person at a time, or for many people who always see the same thing, but that's not really useful.

^ Problems also start to pop up when your apps starts to get interesting. Building CRUD apps is really easy now, but most of our time is not spend in the CRUD-y parts of a web app, it's spent developing all the stuff around the web interface, where all the business rules live.

^ There are some fundamental challenges in web development because of the nature of the internet and user expectations. There are some problems that are common to most web development frameworks out there, and Phoenix was built in some ways to address some of these problems. It's able to offer some unique solutions to these problems because of the Elixir language and the underlying Erlang VM. 

---

# Lots of Choices

^ There are a lot of frameworks out there that address these problems in different ways, and which one is best depends on your domain and your specific problems.

- How much traffic?

^ How many requests will your web app be serving?

- How much data?

^ Tons of throughput or mostly just reading from a database? If your users need to wait on the database all the time then optimizing your app might not be worth it and maybe you should just focus on the db.

- What kind of data?
  
^ Are you storing/fetching user inputted data? Does the data change a lot or will it be mostly static once it's there?

- Which clients/platforms?

^ Can you force your users to use a specific platform that you guarantee is supported? Are you supporting multiple different types of clients (like web, mobile, API)? Will you support certain combinations of OS/Browsers? Or is it running wild on the web and you want it to just work everywhere as best as possible?

- What dependencies?

^ persistence (db), scheduling (cron), long-running requests (web sockets), caching (memcached), background jobs (separate processes?)

- How good are you at dev ops?

^ production engineering/systems engineering/site reliability/whatever else it's called

^ Can you take your app offline for maintenance? Or does it have to be up 100% of the time?

^ Some types of apps and architectures are easier to deploy than others. Think about how you will get your app onto the real internet before you build it, if the intention is eventually to run it there. Also think about the cost of your infratructure before you deploy.

^ Regardless of what solution you choose, there are things you will eventually have to deal with in your web app, so we'll look at few solutions and see how they're implemented with Elixir vs. with other languages.

---

# The Hard Part

- Many people asking for many things from different places at the same time

^ Building a web app for a few users is pretty easy. It's common to run into problems when you try to scale your web app. When a lot of people are asking for the same thing, you have to make sure to show them an accurate version of the thing and the one they're expecting.

- One machine trying to handle it all
    _(Or, many machines trying to keep in sync so the same thing doesn't get handled multiple times -- or not at all)_

- Everyone expects their request to work

^ For most use cases you want your requests to all go through. This means you have to build in mechanisms to handle failures and errors in your app. Ideally you want your users to see the thing they asked for, every time.

^ Existing frameworks are really good at building usable, friendly UIs quickly, but these days most of our time as web developers is spent building the non-CRUD-y parts of web apps. Real businesses are being run on the internet and web apps are doing some real heavy lifting. Frameworks originally designed to make it easy to build web interfaces to a database sometimes struggle to meet more intense business requirements.

---

# Common Challenges

^ These are 5 key requirements of modern web apps

1. Slow requests are handled in a way that doesn't block the app for everyone else and makes sense for the current user

2. Multiple users can access the same data at the same time in a safe way

3. Errors are handled in a minimally invasive way

4. Can store the result of expensive or rate-limited requests

5. Can run regularly scheduled background tasks


^ If someone has to do a big import or export, or render a complicated dashboard, or something else that's slow, the app should not be affected for other users. Also even for that user the UI should make sense, showing them some indication of the progress or status

^ The app has to be able to handle multiple users trying to access the same resource at a time, or even a single user sending multiple updates for the same resource at a time

^ In a way that minimizes the effect for the user and is helpful for developers

^ Some caching is a result of bad performance and is used to reduce the resources required to fulfill a request, but other types of caching are useful and required even in super-performant web apps. Say you're fetching data from an external API, you don't want all your users hitting the external API everytime someone asks for it. You cache the result of the external request.

^ Every web app I've seen has some task it runs on a regular basis. Things that need to happen but it doesn't matter at precisely what time, like sending out reminder emails, updating something or deleting certain records that are in a particular state (like a 30-day soft-delete, building big reports/metrics, archiving inactive records) etc.

--- 

# Bonuses

- Maintable code that is fun and easy to write (**programmer happiness**)

^ Good development tooling (modern front-end build tools, live reload, fast tests)

- Long term maintainability when following best-practices
- Easy deployments (**hot code swapping**)
- Scalable if our idea works
- Automatic 

---


---

### Slow Requests Because of:

# Doing Too Much Work

_Without Phoenix:_ Background jobs
_With Phoenix:_ Elixir processes (GenServer, GenStage)

---

# Doing Too Much Work

- TODO: slow import of big product list
- populating product catalog

```ruby
# in an exports controller

def create
  parse_some_incoming_params
  fetch_the_data_to_export_from_db
  update_some_flag_on_those_models_in_our_db
  convert_the_data_to_a_readable_format # CSV, JSON etc.
  write_that_data_to_a_file
  put_the_file_somewhere_a_user_can_download_it
end
```

^ I add the last thing as a step because you might not have access to a realiable filesystem on your server, so you might have to upload it to S3 or something

---

![inline](turtle.jpg)

# [fit] Too slow!

^ This is not a reasonable amount of time to wait for web request. It will timeout most of the time.

---

### Typical Web App
# Run in a Worker Process

```ruby
def create
  export_job_params = parse_some_incoming_params

  # send to a separate worker process to handle all this
  SlowExportJob.perform(export_job_params)
end
```

---

- Requires an external job queue and something like Redis to keep track of that queue
- Requires polling to check whether the job errored or finished
- Requires executing JS to update the page or force page reload

---

### Phoenix App

- Background job 
- Streaming is an option with websockets
- Can open a socket and update the client when processing is done

^ Phoenix can realistically handle an open websocket connection to every user on your app, so building quick-responding or progress-updating UIs is easy

---

### Phoenix App

# `GenStage`

^ TODO: Update example for exports

```elixir
list_images_for_compression
  |> Flow.from_enumerable(stages: 32, max_demand: 2)
  |> Flow.reject(&S3.object_exists?/1)
  |> Flow.map(&download_image/1)
  |> Flow.map(&resize_image/1)
  |> Flow.map(&upload_image/1)
  |> Flow.each(&cleanup_temp_file/1)
  |> Flow.run
```

^ GenStage is demand-driven, so you can control how much work to give to the parent processor (important for servers that will die if too much memory is used)

^ Can use `Agent`s to store state in a process, `GenServer` to combine concurrent code execution and storing state

---

- Also have other options for job processing if you need more
  - Queuing and job prioritization
  - If your nodes don't have network access to each other

---

### Slow Requests Because of:

# Waiting on External APIs

- TODO: shipping rates, payment gateways

_Without Phoenix:_ Each slow call blocks the request from finishing 
_With Phoenix_: Can launch many requests at a time

---

# Waiting on External APIs

```ruby
# in a dashboard controller

def show
  lookup_a_record_in_our_db
  do_a_calcuation_on_those_records
  fetch_some_information_from_third_party_api
  fetch_some_data_from_third_party_api
  log_some_things
end
```

^ It's common now to poll external APIs, or internal ones (like microservices), or do some calculations on records before rendering them in a UI. You might also be doing other slow things, like logging or notifying.

^ Each one is pretty lightweight in terms of demand on our app -- none are memory intensive tasks on our end)

---

# No
- Those will run serially
- Each one blocks the request from continuing
- **Too slow**
- If one fails the request is ruined

---

### Typical Web App

# Async Requests

-  run in an event loop

```[.highlight: 1, 4, 16, 23-24] js
let xmlRequest = new XMLHttpRequest()
let result = null

xmlRequest.onreadystatechange = function() {
  if (xmlRequest.readyState === XMLHttpRequest.DONE) {
    if (xmlRequest.status === 200) {
      // Handle success, usually means changing something in the DOM
      result = xmlRequest.responseText
    } 
    else if (xmlRequest.status === 400) { alert("Something went wrong") } 
    // Handle the different response codes you want to
    else if (...) { alert("Something bad happened") }
  }
}

xmlRequest.onloadend = function() {
  // do something with the result from above
  document.querySelector(".my-dom-element").innerHTML = xmlRequest.responseText
}

// Set headers for authentication, content type, or other things
xmlRequest.setRequestHeader(...)
xmlRequest.open("GET", "http://someapi.com/endpoint", true) // true means async
xmlRequest.send()
```

^ Client-side authorization is harder than server-side

^ Can do something similar like this in Ruby, but you have the same problems. The requests are running in a single-threaded event loop, so although you can leverage the concurrent behaviour of external systems like the internet or your DB, now you have to write your code in a convoluted callback style. Also you have to deal with errors in each request so if one fails with an unhandled error it doesn't blow up your whole request.


---

## Not Ideal

- Client side authorization can be tricky
- Lose all your threads if the main process dies
- Writing code in this type of callback style is hard to debug and annoying to maintain

^ Can do this in Ruby with EventMachine, but you're interfering with the server threading at the Rack level (before the request makes it to your middleware stack), so you lose out on session management (probably using that for authentication) or other things your middleware is handling.

---

### Phoenix App

# Parallel Processing with `Task`

```[.highlight: 1, 4-15, 19-24] elixir
# in a controller

def show(conn, %{"some_param" => some_param}) do
  compute = Task.async(fn -> MyMicroservice.crunch(some_param) end)
  slow = Task.async(fn -> APIWrapper.get_something(some_param) end)
  also_slow = Task.async(fn -> OtherAPIWrapper.get_something(some_param) end)

  # slow thing the UI doesn't care about:
  Task.Supervisor.async_nolink(MyApp.TaskSupervisor, fn ->
    MyLogger.track_something_happened(some_param) end)
  )

  render(conn, "show.html", compute: Task.await(compute),
                            slow: Task.await(slow),
                            also_slow: Task.await(also_slow))
end


# in your supervision tree

children = [
  ...,
  supervisor(Task.Supervisor, [[name: MyApp.TaskSupervisor]])
]
```

^ No single thing will block the execution of your app. The request will only take as long as the slowest thing you're waiting for.

^ User isn't waiting for things to finish that don't affect the UI. Phoenix controller actions are their own processes, so use a supervised process to not be tied to the caller for something the caller doesn't care about anymore.

^ Request won't fail if one of the requests fails unexpectedly. Only that process will die.

---

### Slow Requests Because of:

# Rendering a Big Payload

- rendering a page with a lot of content (catalog page indexes, caching product images)

_Without Phoenix:_ Many different levels of caching

^ Page caching for requests that don't need even need to go through your app stack (means you probably don't get authentication or other things that are handled before your app actually processes the request), action caching (need to go through your app stack but are the same for many users), fragment caching (parts of a web page that are customized per user), Russian doll caching (caching fragments inside of fragments)

_With Phoenix_: App performance is not a concern

^ Phoenix beats most web app performance out there and scales well because of Erlang and OTP. Stop squeezing rocks, trying to shave milliseconds off of requests that are taking hundreds and hundreds of milliseconds. Maybe some endpoints need a different solution.

^ Erlang is really good at string IO, so rendering big templates or rendering a small template for a ton of people is not an issue

---

### Race Conditions and Invalid Data Because of:

# Shared Data Access

EXAMPLE: inventory management -- make sure you're not overselling 

_Without Phoenix:_ Manual locking at the app level
_With Phoenix_: Erlang processes do not share memory

^ In Ruby and other language concurrency abstractions still share memory (because of the GIL) so you have to be careful that you're not trying to access the same thing from multiple places

^ In elixir data is always copied between processes (cheap on the BEAM), so you are not sharing memory between Erlang processes

^ It's best practice in OO languages to communicate between objects only by sending messages between them and not editing other objects' data directly, but there's nothing actually stopping you from doing it and it inevitably happens. In Elixir the ONLY way to communicate bewteen processes is by sending messages between them, and those messages can be async.

^ Elixir makes serial processing of messages trivially easy with its process model

---

### Typical Web App

# Accessing Data You Shouldn't

- In an OO language it's easy to be undisciplined and reach through objects to access data you shouldn't know about

^ TODO: example

---

### Phoenix App

# You Have to Send a Message

- In elixir everything is run in its own (VM) process
- The only way to communicate between processes is to send messages
- Data is immutable anyway

^ TODO: example

---

# Error Handling

_Without Phoenix:_ Handle known exceptions, unexpected exceptions crash the app
_With Phoenix_: Only the (BEAM)-process that errored fails, and it can be restarted by a supervisor

**Requirements:**
1. know when something fails
2. restore to a known (valid) state

---

### Typical Web App

# Error handling code everywhere

- Unhandled exceptions crash the app

^ TODO: example

---

### Phoenix App

# Supervised Elixir Processes

- Only the process that errors dies, not the supervising process
- Can be restarted with a known (valid) state

^ TODO: supervision tree example

^ What happens with unhandled exceptions?

^ Can a failed process crash the whole VM?

---

### Supervised Elixir Processes:

# Supervisor

```[.highlight: 2-14] elixir
defmodule MyApp.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, [])
  end

  def init([]) do
    children = [
      worker(MyWorker, [[:hello]]) # second argument is the initial stack
    ]

    supervise(children, strategy: :one_for_one)
  end
end
```


---

### Supervised Elixir Processes:

# Supervised Worker

```[.highlight: 2-14] elixir
defmodule MyWorker do
  use GenServer

  def start_link(state, opts \\ []) do
    GenServer.start_link(__MODULE__, state, opts)
  end

  def handle_call(:pop, _from, [h | t]) do # this is a bug
    {:reply, h, t}
  end

  def handle_cast({:push, h}, t) do
    {:noreply, [h | t]}
  end
end
```

---

### Supervised Elixir Processes:

# Automatic Recovery

```elixir
iex(1)> GenServer.call(MyWorker, :pop)
:hello

iex(2)> GenServer.cast(MyWorker, {:push, :world})
:ok

iex(3)> GenServer.call(MyWorker, :pop)
:world
 
iex(4)> GenServer.call(MyWorker, :pop) # error, because stack is empty
** (exit) exited in: GenServer.call(MyStack, :pop, 5000)

iex(5)> GenServer.call(MyWorker, :pop) # restarted with initial stack
:hello
```

---

# Caching

^ Talking about low-level caching

_Without Phoenix:_ Storage dependency and framework dependency
_With Phoenix_: Built-in to Erlang

---

### Typical Web App

# Caching: Storage Dependency

- **In memory**: Can't share cached data between server processes
- **File System**: Only server processes on the same host can share data
- **Memcached**: Single, shared, high-performace cache, requires own server

---

### Typical Web App

# Caching: Framework Requirements

- Framework code has to handle caching, not part of most standard libs

---

### Phoenix App

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

```[.highlight: 1, 11, 17, 21-23, 26, 28] elixir
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

Don't know if you're keeping track, but we're up to 5 processes to keep this web app running

- sidekiq/resque
- redis
- memcached
- cron
- app server itself

---

# Before and After

^ Compare the stack you needed to get your full-scale web app up and running before and after phoenix

Requirement | Ruby | Elixir
---|---|---
App server | Puma/Unicorn | BEAM
HTTP Server | Nginx | BEAM
Long-running requests | ActionCable (Ruby) | Phoenix Channels (BEAM)
Server-wide state | Redis | BEAM
Background jobs | Sidekiq/Resque | BEAM
Scheduled jobs | Cron | BEAM
Low-level caching | Memcached | ETS (BEAM)
Crash recovery | Monit/God/Foreman | BEAM

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

# Maintaining a Connection

- Instead of using javascript or requiring a page reload to update your UI, you can keep a websocket open to the client
- Most frameworks can't handle many open sockets at the same time without really impacting performance (dozens vs. hundreds of thousands of users on the same hardware)

^ Other web sockets implementations reply on redis or some other storage for PubSub tracking, so this will always be a bottleneck (have to worry about redis locking)

---

# Phoenix Channels

```elixir

```



























