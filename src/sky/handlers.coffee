buildHandlers = ({ description }) ->

  description:
    get: ( request ) ->
      # TODO should formatting be handled here?
      description: "ok"
      content: description

export { buildHandlers }