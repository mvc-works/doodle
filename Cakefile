
{print} = require "util"
{spawn} = require "child_process"

echo = (child, callback) ->
  child.stderr.on "data", (data) -> process.stderr.write data.toString()
  child.stdout.on "data", (data) -> print data.toString()
  child.on "exit", (code) -> callback?() if code is 0

make = (str) -> str.split " "

d = __dirname

queue = [
  "coffee -o #{d}/lib/ -wc #{d}/src/doodle.coffee"
  "coffee -o #{d}/lib/ -wc #{d}/src/doodle-server.coffee"
  "jade -wP #{d}/example/demo-tag.jade"
  "node-dev #{d}/bin/doodle #{d}/example/demo-tag.html"
]

split = (str) -> str.split " "

task "dev", "watch and convert files", (callback) ->
  queue.map(split).forEach (array) ->
    echo (spawn array[0], array[1..]), callback