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

^ Some types of apps and architectures are easier to deploy than others. Think about how you will get your app onto the real internet before you build it, if the intention is eventually to run it there. Also may want to think about the cost of your infratructure before you build.

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

## Fundamental Problem

# Stateful apps communicating over a stateless protocol

^ HTTP is a stateless protcol, but people expect a stateful experience. That means that everytime you make an HTTP request, you have to send all the data required to fulfill the request. The server doesn't remember anything about the last time you asked it for something. It's like it's the first time it's ever heard about you every time.

^ We store state in databases and transmit it with cookies to simulate a stateful experience for the user, but this makes providing a consistent experience to many users of a web app at the same time complicated. 

^ Showing the same thing to everyone all the time (putting static content on the web) is easier and easy to scale. The problems I'll talk about are specific to dynamic web apps, so websites you can interact with.

---

# To Deal With It

- Do a lot of things at the same time (**concurrent or async execution**)

^ We can offload state to a DB to solve some of our problems, but that means we're constantly querying the DB for information. These days you might also fetch data in real time from an external service, or query an internal microservice (like fancy data science stuff).

^ If you go down this path (doing many things at the same time) you have to make your code handle asynchronous execution. You will want to do some things things that take longer than others, and if you're running all the requests in the order they come in, you'll end up with something fast stuck behind something slow, which will jam up your app.

- Remember the last thing you did so you don't have to do so many things for each request (**stateful web servers**)

^ To make this approach work, you need a persistent connection to your client. For the web, this means using websockets. Having a connection to each client requires you keep the state of each connection in memory, which can consume a lot of system resources if you have a lot of connected clients at once. Most frameworks can't handle enough simultaneous connections to do anything interesting.

^ At first you might be able to just use a bigger machines, but CPU processors aren't getting much faster anymore so eventually this will mean using a machine with more cores. For that to make any difference your code has to be able to use multiple cores (to run concurrently).

^ Both of these approaches require some concurrency model. Your code has to be able to run asynchronously. Even better if it can handle maintaining tons of open connections, because then you can have a stateful server.

---

# Elixir's Concurrency Model → Actor Model

- Super lightweight VM **processes**
- Each has a mail box
- Interact with each other **only** by sending messages to each others' mail boxes
- Memory is isolated to each process

^ Everything runs in a process

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

## Only takes as long as the slowest process

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

## Compare to Single-Threaded Processing

```elixir
defmodule Slow do
  def sync(delays) do
    Enum.map(delays, fn delay ->
      :timer.sleep(delay)
      IO.puts("Waited #{delay}ms")
    end)
  end
end

iex> Slow.time_this(delays, &Slow.sync/1)
Waited 1000ms
Waited 1300ms
Waited 1500ms
Waited 1700ms
Waited 2000ms
Waited 2500ms
10.006
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

- Can link processes together so they receive exit notifications from each other
- Can monitor a spawned process if you want updates but don't want to crash if the monitored process crashes

---

# Abstractions in the Elixir Library

- **Agents**: maintain a state that is set to the return value of a function that you pass them
- **Tasks**: simplify linking and monitoring processes

---

# Challenges in Web Development

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


































































