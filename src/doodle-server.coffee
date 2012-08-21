
fs = require 'fs'
http = require 'http'
path = require 'path'
show = console.log

repeat = (t, f) -> setInterval f, t
delay = (t, f) -> setTimeout f, t

make = ->
  ret = new Date().getTime().toString()
  show 'reloaded', ret
  ret
time = do make

WebSocketServer = require('ws').Server
wss = new WebSocketServer port: 8071
wss.on 'connection', (ws) ->
  show 'connection'
  record = time
  me = repeat 000, ->
    if time isnt record then ws.send 'reload'
  ws.on 'close', ->
    clearInterval me
    show 'close'

watchFile = (name) ->
  op = interval: 1000
  fs.watchFile name, op, -> time = do make

watchDir = (name) ->
  list = fs.readdirSync name
  list.forEach (item) ->
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