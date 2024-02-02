import log from "@dashkite/kaiko"
import * as API from "@dashkite/scout"
import _description from "./description"

dispatcher = ({ description, handlers }) ->

  # decorate the description with the description resource itself
  description.resources.description = _description
  api = API.Description.from description
  log.debug { api }
  
  # add the get description handler
  handlers.description =
    get: ->
      description: "ok"
      content: description

  ( request ) ->

    log.debug dispatcher: request

    request.resource ?= api.decode request

    if ( handler = handlers[ request.resource?.name ]?[ request.method ] )?
      # await here to force this to be an async fn so that AWS Lambda
      # doesn't require a callback for non-promise responses
      try
        await handler request, request.resource.bindings
      catch error
        console.error "sky-dispatcher:", error.message
        console.info error
        description: "internal server error"
    else
      log.debug dispatcher: "missing handler"
      description: "not found"

export default dispatcher
