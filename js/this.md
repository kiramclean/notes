# What the hell is `this`

- allows us to reuse the same function in different contexts
- you don't know what `this` is in a function until that function is invoked
- to figure out what `this` is check the place where the function was invoked from

## Implicit Binding
**`this` is whatever is left of the dot when the function was called**

```js
let me = {
  name: 'Kira',
  age: 25,
  sayName() {
    console.log(this.name)
  },
  brother: {
    name: 'Colin',
    sayName() {
      console.log(this.name)
    }
  }
}

> me.sayName()
< Kira

> me.brother.sayName()
< Colin
```

## Explicit Binding
**`this` is the explicit first argument to `.call`, `.apply`, or `.bind`**

### `.call`
- use on any method and pass it a context to tell it what `this` is
- subsequent arguments are passed on to the function as normal arguments
- invokes the function immediately

```js
let me = {
  name: 'Kira',
  age: 25,
}

let sayName = function(lang1, lang2, lang3) {
  console.log(this.name)
  console.log(lang1, lang2, lang3)
}

> sayName.call(me, 'JavaScript', 'Ruby', 'Elixir')
< Kira
< JavaScript Ruby Elixir
```

### `.apply`
- pass in an array that will be applied as arguments to the function automatically, sort of a splat operator
- also invokes the function immediately

```js
let languages = ['JavaScript', 'Ruby', 'Elixir']

> sayName.apply(me, languages)
< Kira
< JavaScript Ruby Elixir
```

### `.bind`
- returns a new function bound to the given context that can be invoked later, instead of invoking the function when it is called

```js
let newFunction = sayName.bind(me, 'JavaScript', 'Ruby', 'Elixir')

> newFunction()
< Kira
< JavaScript Ruby Elixir
```

## `new` Binding
**`this` is bound to the new object being constructed**

- capital letter indicates a constructor function, to be called with the `new` keyword

```js
let Animal = function(color, name, type) {
  this.color = color
  this.name = name
  this.type = type
}

let zebra = new Animal('black and white', 'Zorro', 'zebra')

> zebra
< Animal {color: "black and white", name: "Zorro", type: "zebra"}
```

## `window` Binding
**`this` defaults to the `window` object if none of the above apply**

```js
let me = {
  age: 25
}

let sayAge = function() {
  console.log(this.age)
}

> sayAge()
< undefined

window.age = 35  // for illustration only, never do this

> sayAge()
< 35
```

- can `'use strict'` to get JavaScript to enforce better practices

```js
let sayAge = function() {
  'use strict'
  console.log(this.age)
}

window.age = 35

> sayAge()
< Uncaught TypeError: Cannot read property 'age' of undefined
```

- JavaScript knows you shouldn't be accessing the `window` object directly so it won't even let you with `'use strict'`
