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

![inline](pitonneux.jpg)

---

Elixir → language

![inline, 40%, right](elixir.png) 

^ Elixir is a functional programming language that runs on the Erlang VM. It first appeared in 2011 and v1 was released in 2014. It was developed by Jose Valim, a rails core contributor, alledgedly out of his frustrations trying to make ruby apps concurrent.

Erlang → also language, has own VM

![inline, right](phoenix.png)

^ Elixir compiles to Erlang byte code and runs on the Erlang VM (the BEAM). Erlang is a functional language developed in the 80s by Ericsson for use in the telecom industry.

^ It's gaining popularity and used by some big companies for parts of their apps, including Pinterest, Moz, Bleacher Report, Brightcove. Also lots of companies use Erlang for parts of their apps, like Heroku, WhatsApp, RabbitMQ, and it's huge in the telecom industry (the domain the language was built for). Ericsson developed Erlang originally and now it's popular throughout the industry, used by Motorola, Nokia, T-Mobile, etc.

Phoenix → web framework

^ Phoenix is a web framework written in Elixir. It's a full stack framework (comes with great front-end tooling and a database abstraction layer). It's similar to other MVC frameworks, although it doesn't really have "models" because Elixir is functional. You think of your content and content types as just data that flows through a pipeline, as opposed to models that correspond to DB tables. So it's like Rails (Ruby), sort of like express (NodeJS), Django (Python), Play (Java/Scala). 

^ So, Phoenix and Elixir are new, but Erlang is relatively old and proven to be reliable for highly concurrent apps at scale. Elixir is just Erlang byte code, so you don't need to take much of a leap of faith to trust it.

^ It's also supported on many platform-as-a-service providers, like Heroku, Engine Yard, Digital Ocean, you can also deploy a container to AWS or or Google Container Engine, so there are apps running this in production.


---

> Scaling web apps is hard.

^ I'm a web developer. I do mostly Ruby on Rails, also front-end stuff with different JavaScript frameworks. I haven't been doing it for that long, but I noticed that you quickly start to run to the same problems over and over again. 

^ There are some fundamental challenges in web development because of the nature of the internet and user expectations. There are some problems that are common to most web development frameworks out there, and Phoenix was built in some ways to address some of these problems. It's able to offer some unique solutions to these problems because of the Elixir language and the underlying Erlang VM. 

---

# The Hard Part

- Many people asking for many things at the same time
- One machine trying to handle it all
- Or, many machines trying to keep in sync so the same thing doesn't get handled multiple times (or not at all)

---

## Fundamental Problem


# Stateful apps communicating over a stateless protocol

^ HTTP is a stateless protcol, but people expect a stateful experience. That means that everytime you make an HTTP request, you have to send all the data required to fulfill the request. The server doesn't remember anything about the last time you asked it for something. It's like it's the first time it's ever heard about you every time.

^ We store state in databases and cookies to simulate a stateful experience for the user, but this makes providing a consistent experience to many users of a web app at the same time complicated. Showing the same thing to everyone all the time (putting static content on the web) is easy and easy to scale. The problems I'll talk about are specific to dynamic web apps, like websites you can interact with.

---

# Different Options

^ There are a lot of frameworks out there that address this problem in different ways, and which one is best depends on your domain and your specific problems.

- How much traffic?

^ How many requests will your web app be serving?

- How much data?

^ Tons of throughput or mostly just reading from a database? If your users need to wait on the database all the time then optimizing your app might not be worth it and maybe you should just focus on the db.

- What kind of data?
  
^ Are you storing/fetching user inputted data? Does the data change a lot or will it be mostly static once it's there? Maybe you don't even need a database.

- Which clients/platforms?

^ Can you force your users to use a specific platform that you guarantee is supported? Are you supporting multiple different types of clients (like web, mobile, API)? Will you support certain combinations of OS/Browsers? Or is it running wild on the web and you want it to just work everywhere as best as possible?

- What dependencies?

^ persistence (db), scheduling (cron), long-running requests (web sockets), caching (memcached), background jobs (separate processes?)

- How good are you at dev ops?

^ production engineering/systems engineering/site reliability/whatever else it's called
^ Can you take your app offline for maintenance? Or does it have to be up 100% of the time.
^ Some types of apps and architectures are easier to deploy than others. Think about how you will get your app onto the real internet before you build it, if the intention is eventually to run it there. Also think about the cost of your infratructure before you deploy.

^ Regardless of what solution you choose, there are things you will eventually have to deal with in your web app, so we'll look at few solutions and see how they're implemented with Elixir vs. with other languages.

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

# With Phoenix



---

- Don't want to block the response waiting for something slow
    + fetching data from an external API
    + doing an expensive calculation
    + 

^ It's common in your web app to have some requests that are slow or unpredicatable 

---


---

# Problems to deal with



---

One Problem, Many Solutions

- Stateful server
- Asynchronous requests
- 

Plan : PROBLEM -> SOLUTION -> EXAMPLE

--- 

> **Concurrency**

---

There are a few problems in web development that keep coming up, regardless of the framework you use. There are a few fundamental problems in web development that we have to work around to create any sort of app that anyone would actually want to use.

To see what the problems are, think about a typical web app and the experience you expect vs. the architecture of the internet.

Look at the common solutions to these problems, then how Phoenix handles them.

