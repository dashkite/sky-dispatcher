import merge from "deepmerge"

import builtInAPI from "./built-in/api"
import { makeBuiltInHandlers } from "./built-in/handlers"

bind = ({ description, handlers }) ->

  # add built-ins
  description = merge description, builtInAPI
  handlers = merge handlers, makeBuiltInHandlers description

  # add handlers into description, 
  # verifying as we go
  for rname, resource of description.resources
    for mname, method of resource.methods
      if ( handler = handlers[ rname ]?[ mname ] )?
        method.handler = handler
      else
        console.warn "sky-dispatcher: 
          Missing handler for resource [ #{ rname } ], method [ #{ mname } ]"
  
  # verify the other way, just in case we have
  # stray handlers
  for rname, _handlers of handlers
    if !( description.resources[ rname ]? )
      console.warn "sky-dispatcher:
          No resource [ #{ rname } ] for handler"
    else
      for mname, handler of _handlers
        if !( description.resources[ rname ]?.methods[ mname ]? )
          console.warn "sky-dispatcher:
            No method [ #{ mname } ] in resource [ #{ rname } ] for handler"

  # we're good to go
  description

export {
  bind
}