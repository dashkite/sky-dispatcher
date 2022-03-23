import classifier from "@dashkite/sky-classifier"
import resolveStatus from "statuses"
import * as Text from "@dashkite/joy/text"

dispatcher = (description, handlers) ->

  classify = classifier description

  (request) ->

    console.log "start dispatcher"

    { resource, method, bindings, signatures, json } = classify request

    # TODO handle special case for OPTIONS and HEAD methods

    if ( handler = handlers[ resource ]?[ method ] )?
      response = await handler request, { bindings, json }
    else
      response = description: "not found"

    status = resolveStatus response.description
    response.headers ?= {}
    if status == 204
      # no content, no content-type
    else if status < 300
      response.headers["content-type"] ?= [
        signatures.response["content-type"]?[0] ? "application/json"
      ]
    else
      response.headers["content-type"] ?= [ "text/plain" ]

    # TODO deal with content-encoding
    console.log { response }
    response      

export default dispatcher
