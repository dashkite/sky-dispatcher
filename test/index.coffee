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
    post: -> "success!"

do ->

  print await test "Sky Classifier", [

    test "create a classifier from a description", ->
      dispatch = $ api, handlers

      assert.equal "success!", 
        await dispatch
          url: "/foo"
          method: "post"
          headers: {}

  ]

  process.exit success