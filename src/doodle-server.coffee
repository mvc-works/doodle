
fs = require 'fs'
http = require 'http'
path = require 'path'
show = console.log

repeat = (t, f) -> setInterval f, t
delay = (t, f) -> setTimeout f, t

make = -> new Date().getTime().toString()
stemp = do make

sendSSE = (res) ->
  res.writeHead 200,
    'Content-Type': 'text/event-stream'
    'Cache-Control': 'no-cache'
    'Connection': 'keep-alive'
  record = stemp
  count = 0
  me = repeat 1000, ->
    count += 1
    if stemp isnt record
      res.write 'data:...\n\n'
      clearInterval me
      show 'use end'

script = path.join __dirname, '../lib/doodle-client.js'
demo = path.join __dirname, '../example/demo.html'

sendScript = (res) ->
  res.writeHead 200, 'Content-Type': 'text/javascript'
  fs.readFile script, (err, data) ->
    throw err if err?
    res.end data

sendDemo = (res) ->
  show 'sendDemo'
  res.writeHead 200, 'Content-Type': 'text/html'
  fs.readFile demo, 'utf8', (err, data) ->
    show data
    throw err if err?
    res.end data

here = process.env.PWD
app = http.createServer (req, res) ->
  show req.url

  switch req.url
    when '/?events' then sendSSE res
    when '/?doodle.js' then sendScript res
    else
      filepath = path.join here, req.url
      show filepath
      fs.readFile filepath, 'utf8', (err, data) ->
        if err? then res.end '404'
        else res.end data

app.listen 7890

watchFile = (name) ->
  op = interval: 1000
  fs.watchFile name, op, ->
    stemp = do make
    show stemp
  show name

watchDir = (name) ->
  list = fs.readdirSync name
  list.forEach (item) ->
    watchPath (path.join name, item)

watchPath = (name) ->
  stat = fs.statSync name
  if stat.isDirectory() then watchDir name
  else if stat.isFile() then watchFile name
  else show  'unkown file:', name
process.argv[2..].forEach (name) ->
  filepath = path.join here, name
  watchPath filepath

readFile = (name, res) ->
  fs.readFile name, 'utf8', (err, data) ->
    res.write data