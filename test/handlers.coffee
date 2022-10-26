handlers =
  foo:
    post: -> 
      description: "ok"
      content: "success!"
    delete: ->
  bar:
    get: ->
      content: greeting: "hello, world!"

export default handlers