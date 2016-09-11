# React Basics

## Components:

- class component can have state
- stateless function component has no state
- `render` can only return one node
  - can have other elements nested inside this main node
  *example:*
  ```js
    // valid render() function for a react component:

    render() {
      return (
        <div>
          <h1>Hello World</h1>
          <p>Lots of tags inside</p>
        </div>
      )
    }

    // invalid render(), will give you the error:
    // "Adjacent JSX elements must be wrapped in an enclosing tag"

    render() {
      return (
        <h1>Hello World</h1>
        <p>Tag is sibling of other one, not nested</p>
      )
    }
  ```

- pass default properties with `Component.defaultProps`
- define (and optionally enforce) property types with `Component.propTypes`
  ```js
  Component.propTypes = {
    key: React.PropTypes.type
    otherKey: React.PropTypes.type.isRequired
  }
  ```

- props are passed in to a component, state is managed by the component itself

## Refs
**a  way to access an instance of a component from within the app**
- don't work with stateless function components

- to access inner html or nested components of another component use `this.props.children`
  - like `yield` from Ember

## Component Lifecycle Methods

### Mounting/Unmounting
**adding or removing a component from the DOM**

`componentWillMount`
  - component is fully prepped and guaranteed to make it into the DOM
  - only called once
  - no access to DOM, but do have access to `state` and `props`

`componentDidMount`
  - after component has been placed into the DOM
  - only called once
  - have access to component in the actual DOM

`componentWillUnmount`
  - before component is removed from the DOM

### Updating

`componentWillReceiveProps(nextProps)`
  - first lifecycle updating method
  - takes in the next properties that are going to be passed to the component

`shouldComponentUpdate(nextProps, nextState)`
  - decide if we want the component to update at all
  - perfect place to optimize the component and not re-render if we don't need to
  - state can still be updated even if component is not being re-rendered

`componentDidUpdate(prevProps, prevState)`
  - checks whether component changed

## Higher order components/functions
  - higher order components/functions have replaced mixins
  - use them to share behaviour that gives the same result but is implemented differently
