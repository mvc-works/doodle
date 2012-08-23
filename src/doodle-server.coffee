
fs = require 'fs'
http = require 'http'
path = require 'path'
show = console.log

repeat = (t, f) -> setInterval f, t
delay = (t, f) -> setTimeout f, t

make = ->
  ret = new Date().getTime().toString()
  show 'make time:', ret
  ret
time = do make

WebSocketServer = require('ws').Server
wss = new WebSocketServer port: 8071, host: '0.0.0.0'
wss.on 'connection', (ws) ->
  # show 'connection'
  record = time
  me = repeat 1000, ->
    if time isnt record
     delay 100, -> ws.send 'reload'
  ws.on 'close', ->
    clearInterval me
    # show 'close'

watchFile = (name) ->
  show 'watch: ', name
  op = interval: 300
  fs.watchFile name, op, -> time = do make

watchDir = (name) ->
  list = fs.readdirSync name
  list.forEach (item) ->
    if item[0] isnt '.'
      watchPath (path.join name, item)

watchPath = (name) ->
  stat = fs.statSync name
  if stat.isDirectory() then watchDir name
  else if stat.isFile() then watchFile name
  else show  'unkown file:', name

here = process.env.PWD
process.argv[2..].forEach (name) ->
  filepath = path.join here, name
  watchPath filepath

app = http.createServer (req, res) ->
  if req.url is '/doodle.js'
    res.writeHead 200, 'Content-Type': 'text/javascript'
    res.end """
      var ws = new WebSocket('ws://localhost:8071');
      ws.onmessage = function(message){
        console.log(message);
        if (message.data === 'reload') location.reload();
      };
      """
app.listen 8072