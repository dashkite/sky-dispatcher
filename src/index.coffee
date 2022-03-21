import classifier from "@dashkite/sky-classifier"
import * as Text from "@dashkite/joy/text"

dispatcher = (description, handlers) ->

  classify = classifier description

  (request) ->

    console.log "start dispatcher"

    { resource, method, bindings, signatures } = classify request

    # TODO handle special case for OPTIONS and HEAD methods

    if ( handler = handlers[ resource ]?[ method ] )?
      response = await handler request, bindings
      
      if signatures.response.status?[0] != 204
        response.headers ?= {}
        response.headers["content-type"] = [
          signatures.response["content-type"] ? "application/json"
        ]
    
    else
      response = description: "not found"
      response.headers ?= {}
      response.headers["content-type"] = [ "text/plain" ]

    # TODO deal with content-encoding
    console.log { response }
    response      

export default dispatcher
