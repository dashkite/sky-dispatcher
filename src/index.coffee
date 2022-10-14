import { decodeURLTarget } from "@dashkite/sky-api-description"
import {
  resolveStatus
  removeContent
  getSignatures
  negotiateContent
  setContentLength
  setNoContent
  setAllow
  invoke
  respond
} from "./helpers"

# TODO do we need the description any longer?
dispatcher = (description, handlers) ->

  (request) ->

    # this may have already been decoded for us,
    # but just in case...
    request.resource ?= decodeURLTarget description, request.target

    if ( methods = handlers[ request.resource?.name ] )?

      { resource, method } = request
      { name, bindings } = resource

      switch method

        when "head"
          if ( handler = handlers[ name ]?.get )?
            setNoContent await invoke handler, request, bindings
          else
            respond "not found"

        # TODO should we assume that the distribution will handle this?
        # there are a lot more possible responses
        # than we're accounting for here
        when "options"
          setAllow ( respond "ok" ), [ "options", ( Object.keys methods )... ]

        else
          # TODO detect mismatch between description and handlers
          # for the case where there's a missing or superfluous handler
          if ( handler = methods?[ method ] )?
            signatures = getSignatures { description, name, method }
            negotiateContent signatures,
              await invoke handler, request, bindings
          else
            respond "method not allowed"
    else
      respond "not found"

export default dispatcher
