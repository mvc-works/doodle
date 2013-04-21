
{spawn} = require "child_process"

echo = (child) ->
  child.stderr.pipe process.stderr
  child.stdout.pipe process.stdout

make = (str) -> str.split " "

queue = [
  "coffee -o lib/ -wc src/"
  "jade -wP example/demo-tag.jade"
  "node-dev bin/doodle example/demo-tag.html"
]

split = (str) -> str.split " "

task "dev", "watch and convert files", ->
  queue.map(split).forEach (array) ->
    echo (spawn array[0], array[1..])