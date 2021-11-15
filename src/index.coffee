import classifier from "@dashkite/sky-classifier"

getStatusFromDescription = (description) ->

dispatcher = (description, handlers) ->

  classify = classifier description

  (request) ->

    {resource, method} = classify request

    # TODO handle special case for OPTIONS and HEAD methods

    if ( handler = handlers[ resource ]?[ method] )?
      response = await handler request
      if response.description?
        response.status = getStatusFromDescription response.description

      # TODO deal with content-encoding

      response      

export default dispatcher
