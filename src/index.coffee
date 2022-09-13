import resolveStatus from "statuses"
import * as Text from "@dashkite/joy/text"

dispatcher = (description, handlers) ->

  (request) ->

    _method = request.method
    if request.method == "head"
      request.method = "get"

    { resource, method } = request
    { origin, name, bindings } = resource
    { signatures } = description
      .resources[ name ]
      .methods[ method ]

    # TODO handle special case for OPTIONS and HEAD methods

    if ( handler = handlers[ name ]?[ method ] )?
      response = await handler request, bindings
    else
      response = description: "not found"

    status = resolveStatus response.description
    response.headers ?= {}
    if status == 204
      # no content, no content-type
      delete response.content
      delete response.headers["content-type"]
      delete response.headers["content-length"]
    else if status < 300
      response.headers["content-type"] ?= [
        signatures.response["content-type"]?[0] ? "application/json"
      ]
    else
      response.headers["content-type"] ?= [ "text/plain" ]

    # Empty response for HEAD request.
    if _method == "head"
      delete response.content

    # TODO: deal with content-encoding
    # TODO: deal with content-length
    # TODO: deal with cache-control
    # TODO: deal with content compression
    response      

export default dispatcher
