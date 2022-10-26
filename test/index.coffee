import { test, success } from "@dashkite/amen"
import print from "@dashkite/amen-console"

import dispatcher from "../src"
import description from "./api"
import handlers from "./handlers"

import scenarios from "./scenarios"
import runner from "./runner"

run = runner dispatcher { description, handlers }
  

do ->

  print await test "Sky Dispatcher", do ->
    for scenario in scenarios
      test scenario.name, run scenario