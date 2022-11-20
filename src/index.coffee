isDiscoveryRequest = ( request ) ->
  ( request.resource?.name == "description" ) && ( request.method == "get" )

dispatcher = ({ description, handlers }) ->

  (request) ->
    if isDiscoveryRequest request
      description: "ok"
      content: description
    else if ( handler = handlers[ request.resource?.name ]?[ request.method ] )?
      # await here to force this to be an async fn so that AWS Lambda
      # doesn't require a callback for non-promise responses
      await handler request, request.resource.bindings
    else
      # this should never happen because the classifier should have
      # caught this before ever calling us...
      description: "internal server error"

export default dispatcher
