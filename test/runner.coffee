import assert from "@dashkite/assert"

runner = ( dispatch ) ->
  ( scenario ) -> ->
    response = await dispatch scenario.request
    { description, content } = scenario.response
    assert.equal description, response.description
    if content?
      assert.deepEqual content, response.content

export default runner