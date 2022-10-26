verify = ({ description, handlers }) ->

  valid = true

  for rname, resource of description.resources
    if !( _handlers = handlers[ rname ] )?
      valid = false
      console.warn "sky-dispatcher: 
        Missing handlers for resource [ #{ rname } ]"
    else
      for mname, method of resource.methods
        if !( handler = _handlers[ mname ] )?
          valid = false
          console.warn "sky-dispatcher: 
            Missing handler for resource [ #{ rname } ], method [ #{ mname } ]"
  
  for rname, _handlers of handlers
    if !( description.resources[ rname ]? )
      valid = false
      console.warn "sky-dispatcher:
          No resource [ #{ rname } ] for handler"
    else
      for mname, handler of _handlers
        if !( description.resources[ rname ]?.methods[ mname ]? )
          valid = false
          console.warn "sky-dispatcher:
            No method [ #{ mname } ] in resource [ #{ rname } ] for handler"
  valid

export {
  verify
}