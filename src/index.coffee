import classifier from "@dashkite/sky-classifier"
import * as Text from "@dashkite/joy/text"

dispatcher = (description, handlers) ->

  classify = classifier description

  (request) ->

    console.log "start dispatcher"

    { resource, method, bindings } = classify request

    # TODO handle special case for OPTIONS and HEAD methods

    if ( handler = handlers[ resource ]?[ method] )?
      response = await handler request, bindings
    else
      response = description: "not found"

    # TODO deal with content-encoding
    console.log { response }
    response      

export default dispatcher
