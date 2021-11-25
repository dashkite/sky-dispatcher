import classifier from "@dashkite/sky-classifier"
import * as Text from "@dashkite/joy/text"
import resolveStatus from "statuses"

getStatusFromDescription = (description) ->
  resolveStatus description

getDescriptionFromStatus = (status) ->
  resolveStatus status

dispatcher = (description, handlers) ->

  classify = classifier description

  (request) ->

    {resource, method} = classify request

    # TODO handle special case for OPTIONS and HEAD methods

    if ( handler = handlers[ resource ]?[ method] )?
      response = await handler request
    else
      response = description: "not found"

    if response.description? && !response.status?
      response.status = getStatusFromDescription response.description
      # normalize description, now that we have the status
      response.description = getDescriptionFromStatus response.status
    else if response.status? && !response.description?
      response.description = getDescriptionFromStatus response.status

    # TODO deal with content-encoding
    console.log { response }
    response      

export default dispatcher
