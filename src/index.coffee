import _description from "./description"

dispatcher = ({ description, handlers }) ->

  # decorate the description with the description resource itself
  description.resources.description = _description
  
  # add the get description handler
  handlers.description =
    get: ->
      description: "ok"
      content: description

  (request) ->
    if ( handler = handlers[ request.resource?.name ]?[ request.method ] )?
      # await here to force this to be an async fn so that AWS Lambda
      # doesn't require a callback for non-promise responses
      try
        await handler request, request.resource.bindings
      catch error
        console.log "sky-dispatcher: handler error", error
        description: "internal server error"
    else
      # this should never happen because the classifier should have
      # caught this before ever calling us...
      description: "internal server error"

export default dispatcher
