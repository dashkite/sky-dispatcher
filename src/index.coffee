dispatcher = ({ description, handlers }) ->

  (request) ->
    if request.resource?.name == "description" && request.method == "get"
      description: "ok"
      content: description
    else if ( handler = handlers[ request.resource?.name ]?[ request.method ] )?
      handler request, request.resource.bindings
    else
      # this should never happen because the classifier should have
      # caught this before ever calling us...
      description: "internal server error"

export default dispatcher
