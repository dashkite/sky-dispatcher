import { test, success } from "@dashkite/amen"
import print from "@dashkite/amen-console"
import assert from "@dashkite/assert"

import $ from "../src"

api = 
  resources:
    foo:
      template: "/foo"
      methods:
        post:
          signatures:
            request: {}
            response:
              status: [ 200 ]

handlers =
  foo:
    post: -> 
      description: "ok"
      content: "success!"

do ->

  print await test "Sky Dispatcher", [

    test "create a classifier from a description", ->
      dispatch = $ api, handlers

      response = await dispatch
        target: "/foo"
        method: "post"
        resource:
          name: "foo"
        headers: {}


      assert.equal "success!", response.content
        
  ]

  process.exit success