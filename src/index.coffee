import { Description } from "@dashkite/sky-api-description"
import { verify } from "./helpers"

dispatcher = ({ description, handlers }) ->

  if ! verify { description, handlers }
    console.warn "sky-dispatcher: Handlers failed verification."

  (request) ->

    if ( handler = handlers[ request.resource?.name ]?[ request.method ] )?
      handler request, request.reource?.bindings
    else
      # this should never happen because the classifier should have
      # caught this before ever calling us...
      description: "internal server error"


export default dispatcher
