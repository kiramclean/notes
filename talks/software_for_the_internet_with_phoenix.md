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

Erlang → also language, has own VM

^ Elixir compiles to Erlang byte code and runs on the Erlang VM (the BEAM). Erlang is a functional language developed in the 80s by Ericsson for use in the telecom industry.

^ It's gaining popularity and used by some big companies for parts of their apps, including Pinterest, Moz, Bleacher Report, Brightcove. Also lots of companies use Erlang for parts of their apps, like Heroku, WhatsApp, RabbitMQ, and it's huge in the telecom industry (the domain the language was built for). Ericsson developed Erlang originally and now it's popular throughout the industry, used by Motorola, Nokia, T-Mobile, etc.

Phoenix → web framework

^ Phoenix is a web framework written in Elixir. It's a full stack framework (comes with great front-end tooling and a database abstraction layer). It's similar to other MVC frameworks, although it doesn't really have "models" because Elixir is functional. You think of your content and content types as just data that flows through a pipeline, as opposed to models that correspond to DB tables. So it's like Rails (Ruby), sort of like express (NodeJS), Django (Python), Play (Java/Scala). 

^ So, Phoenix and Elixir are new, but Erlang is relatively old and proven to be reliable for highly concurrent apps at scale. Elixir is just Erlang byte code, so you don't need to take much of a leap of faith to trust it.

^ It's also supported on many platform-as-a-service providers, like Heroku, Engine Yard, Digital Ocean, you can also deploy a container to AWS or or Google Container Engine, so there are apps running this in production.

![inline, 60%](elixir.png) ![inline, 90%](erlang.png) ![inline](phoenix.png) 

---

> Scaling web apps is hard.

^ I'm a web developer. I do mostly Ruby on Rails, also front-end stuff with different JavaScript frameworks. I haven't been doing it for that long, but I noticed that you quickly start to run to the same problems over and over again. 

^ Usually you don't run into problems until a lot of people start using your app at the same time. It's pretty easy to build something that will work for one person at a time, or for many people who always see the same thing, but that's not really useful.

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
    _(Or, many machines trying to keep in sync so the same thing doesn't get handled multiple times -- or not at all_

- Everyone expecting their request to work

^ For most use cases you want your requests to all go through. This means you have to build in mechanisms to handle failures and errors in your app. Ideally you want your users to see the thing they asked for, every time.

^ Existing frameworks are really good at building usable, friendly UIs quickly, but these days most of our time as web developers is spent building the non-CRUD-y parts of web apps. Real businesses are being run on the internet and web apps are doing some real heavy lifting. Frameworks originally designed to make it easy to build web interfaces to a database sometimes struggle to meet more intense business requirements.

---

# Fundamental Problem

Stateful apps communicating over a stateless protocol

^ HTTP is a stateless protcol, but people expect a stateful experience. That means that everytime you make an HTTP request, you have to send all the data required to fulfill the request. The server doesn't remember anything about the last time you asked it for something. It's like it's the first time it's ever heard about you every time.

^ We store state in databases and transmit it with cookies to simulate a stateful experience for the user, but this makes providing a consistent experience to many users of a web app at the same time complicated. 

^ Showing the same thing to everyone all the time (putting static content on the web) is easy and easy to scale. The problems I'll talk about are specific to dynamic web apps, like websites you can interact with.

---

# To Deal With It

- Do a lot of things at the same time (**async or concurrent execution**)

^ We can offload state to a DB to solve some of our problems, but that means you're constantly querying the DB for information. These days you might also fetch data in real time from an external service, or query an internal microservice (like fancy data science stuff).

^ If you go down this path (doing many things at the same time) you have to make your code handle asynchronous execution. You will want to do some things things that take longer than others, and if you're running all the requests in the order they come in, you'll end up with something fast stuck behind something slow, which will jam up your app

- Remember the last thing you did so you don't have to do so many things for each request (**stateful web servers**)

^ To make this approach work, you need a persistent connection to your client. For the web, this means using websockets. Having a connection to each client requires you keep the state of each connection in memory, which can consume a lot of system resources if you have a lot of connected clients at once. Most frameworks can't handle enough connections to do anything interesting.

^ At first you might be able to just use a bigger machines, but CPU processors aren't getting much faster anymore so eventually this will mean using a machine with more cores. For that to make any difference your code has to be able to use multiple cores.

---

# Handling Many Things at Once

- Send jobs to background workers and poll them for the result (**separate processes**)

^ Sometimes this is overkill for something that is slow enough to be a pain but not quite slow enough to be worth running in a background job

- Send tasks to an event loop with functions that run on completion/failure (**separate threads**)

^ This forces you to write your code in a convoluted callback style

---

# Doing a Lot of Work

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

---

![inline](turtle.jpg)

# [fit] Too slow!

^ This is not a reasonable amount of time to wait for web request

---

## Typical Web App
### Run in a separate process

```ruby
def create
  export_job_params = parse_some_incoming_params
  # send to a separate worker process to handle all this
  SlowExportJob.perform(export_job_params)
end
```

- Now you have to poll that job to see what it's doing
_either use fancy javascript or require a page reload_
- Requires separate queue

---

# With Phoenix

^ GenStage to manage how much work your process can handle?
^ Do these things in a supervised task?

---

# Calling Multiple Slow APIs

```ruby
# in a dashboard controller

def show
  lookup_a_record_in_our_db
  fetch_some_things_from_github
  fetch_some_things_from_twitter
  fetch_some_things_from_youtube
end
```

---

No need to wait!
But each of those requests is blocking the controller from continuing.
- Can wrap them in threads, or if this was JS they would be running async
- But then you have to wait for each to finish and handle callbacks coming in in an unpredictable order
- This leads to code that is annoying to maintain and hard to debug

---

# Elixr Handles Async Messages

- Spawn processes freely and let Erlang worry about it 

`spawn/3`
`Task.async`

- Phoenix controller actions are already processes

^ Think about coupling between controller actions and the processes spawned from them.

---

# Maintaining a Connection

- Instead of using javascript or requiring a page reload to update your UI, you can keep a websocket open to the client
- Most frameworks can't handle many open sockets at the same time without really impacting performance (dozens vs. hundreds of thousands of users on the same hardware)

^ Other web sockets implementations reply on redis or some other storage for PubSub tracking, so this will always be a bottleneck (have to worry about redis locking, can't reliably have multiple redis servers running at the same time)

---

# Phoenix Channels

```elixir

```

---

# In Phoenix

def export

end

---

# Slow Requests

- Don't want to block your app by running a network request to an outside API
- Move pieces of your UI to separate endpoints that are fetched with AJAX, then use JS to put them into the DOM once the request comes back

- Run slow things in a background job, poll it to check status
- Can use a multi-threaded server to handle concurrent requests, but those can require a lot of system resources (e.g. in Ruby a thread requires a separate OS process)
- Also, you're doing this high in the middleware stack, interfacing directly with your web server's async rack layer, so you lose any middleware included by your framework! (like session management)
- You're handling the async stuff before the request gets into your framework code, let alone your app code
- All your threads die when restarting the main process

---



---

> Asynchronous requests

- async execution
    + compared to Rails: backgrounding jobs in workers and polling them
    + compared to Node: single-threaded event loop leading forcing you to write code in a convulted callback style
    + integrating with external APIs blocks a whole worker thread, so you have multiple workers running jobs on different threads, this is very expensive
    + you still have to be careful that you don't put a slow job on a worker that needs to process fast jobs, because the slow job 

---

## Typical web app

``` [.highlight: 1,4,7,10]
Request --> Router --> Your App --> Response
                        |  |  |
                        V  |  |
                        fetch stuff from DB
                           |  |
                           V  |
                           external API request                           
                              |
                              V
                              slow computation 

```

^ You often get a request that requires you do something slow, like call an external API or run some slow computation (like importing/exporting data)
^ Doing these things inline blocks other requests
^ Ruby can only run one thing at a time. You can background the job, but then you have to poll it 
^ Also, because data is immutable in Elixir you don't have to worry about multiple things trying to update the same thing at the same time
^ Elixir processes don't share memory -- in Ruby and other language concurrency abstractions still share memory (because of the GIL) so you have to be careful that you're not trying to access the same thing from multiple places
^ Data is always copied between processes (cheap on the BEAM), so you are not sharing memory between Erlang processes
^ It's best practice in OO languages to communicate between objects only by sending messages between them and not editing other objects' data directly, but there's nothing actually stopping you from doing it and it inevitably happens. In Elixir the ONLY wya to communicate bewteen processes is by sending messages between them, and those messages can be async.



---

- Don't want to block the response waiting for something slow
    + fetching data from an external API
    + doing an expensive calculation
    + even loading a ton of stuff from a db

^ It's common in your web app to have some requests that are slow or unpredicatable 

---

# Caching

- Don't need to cache your own things, phoenix is fast enough

^ You can get rid of fragment caching or the other types of caching where you cache things generated by your own server. Phoenix serves them fast enough that those strategies are unecessary. 

- If you do want to cache data (to avoid a DB or an external API or something), OTP has you covered

---

# Erlang Term Storage

- Constant-time in-memory tuple store
- Comes with Erlang

^ A super efficient, built-in in-memory store. Lives in a process, so when that process dies you lose the table, which you can prevent by supervising the process and backing up the data

<br>

```elixir
iex(1)> :ets.new(:fancy_erlang_cache, [:set, :private, :named_table])
:fancy_erlang_cache
iex(2)> :ets.insert(:fancy_erlang_cache, {"cache key", "some value"})
true
iex(3)> :ets.lookup(:fancy_erlang_cache, "cache key")
[{"cache key", "some value"}]
```

^ Might want to cache external API responses

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

---

# Downsides

- Less library support
- Fewer external services like error monitoring, but Erlang has a lot of stuff built in

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



























