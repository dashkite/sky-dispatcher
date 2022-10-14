import * as Fn from "@dashkite/joy/function"
import * as Type from "@dashkite/joy/type"
import * as Text from "@dashkite/joy/text"
import status from "statuses"
import { getSignatures } from "@dashkite/sky-api-description"

decorate = ( description, handlers ) ->
  { description, handlers }

resolveStatus = Fn.tee ( response ) ->
  if response.status?
    response.description = status response.status
  else if response.description?
    response.status = status response.description
  else if response.content?
    Object.assign response,
      status: 200
      description: "ok"
  else
    Object.assign response,
      status: 204
      description: "no content"

removeContent = Fn.tee ( response ) ->
  delete response.content
  for key, value of response.headers
    if key.startsWith "content-"
      delete response.headers[ key ]
  response.description = "no content"
  response.status = 204

# TODO is this is the wrong place?
#      we would need to serialize it to know the JSON length
#      and we've been avoiding that b/c lambda already
#      does that, so we don't want to do it twice when
#      calling from another lambda...
setContentLength = Fn.tee ( response ) ->
  if Type.isString response.content
    Object.assign response.headers,
      "content-length": response.content.length

negotiateContent = Fn.rtee ( signatures, response ) ->
  if response.status == 204
    removeContent response
  else if response.content? 
    setContentLength response
    if 200 <= response.status <= 300
      # TODO actually do content negotiation here
      # TODO: should probably do initial check before making request
      #       we can check request against description
      # TODO: deal with content-encoding
      # TODO: deal with cache-control
      # TODO: deal with content compression
      response.headers["content-type"] ?= [
          signatures.response["content-type"]?[0] ? "application/json"
        ]
    else
      response.headers["content-type"] ?= [ "text/plain" ]
  # else possibly 2xx response without content but we assume
  # in that case you know what you're doing

setNoContent = Fn.tee ( response ) ->
  response.description = "no content"
  response.status = 204
  removeContent response

setAllow = Fn.rtee ( methods, response ) ->
  Object.assign response.headers,
    allow: [ methods.join " " ]

normalizeResponse = ( response = {} ) ->
  resolveStatus response
  response.headers ?= {}
  response

invoke = ( handler, request, bindings ) ->
  normalizeResponse await handler request, bindings

respond = ( description ) ->
  normalizeResponse { description }


export {
  getSignatures
  resolveStatus
  removeContent
  setContentLength
  negotiateContent
  setNoContent
  setAllow
  invoke
  normalizeResponse
  respond
}