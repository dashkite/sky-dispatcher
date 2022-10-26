import { Description } from "@dashkite/sky-api-description"
import { bind } from "./helpers"

dispatcher = ({ description, handlers }) ->

  description = bind { description, handlers }

  (request) ->

    # in theory we should never hit method not allowed or not found
    # because those would be detected by sky-classifier wrt 
    # the API description, but we do a secondary check here
    # issuing warnings for the logs
    if ( resource = description.resources[ request.resource?.name ] )?
      if ( method = resource.methods?[ request.method ] )?
          method.handler request, request.resource.bindings
      else
        console.warn "sky-dispatcher: 
          'Method Not Allowed' from dispatcher
          for resource [ #{ request.resource?.name } ]
          and method [ #{ request.method } ]"
        description: "method not allowed"
    else
      console.warn "sky-dispatcher: 'Not Found' from dispatcher
          for resource [ #{ request.resource?.name } ]"
      description: "not found"

export default dispatcher
