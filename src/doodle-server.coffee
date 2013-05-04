
# global requires and defines

fs = require 'fs'
http = require 'http'
path = require 'path'
chokidar = require "chokidar"
events = require "events"

log = ->
delay = (t, f) -> setTimeout f, t

center = new events.EventEmitter

# print help here

print_help = ->
  console.log """

  Doodle: watch JS files and reload pages via websocket

  doodle dir path dir-2 path-2
  # watchs directories and files

  doodle log:yes dir
  # open log

  doodle port:7777 dir
  # set the port serving doodle.js

  doodle ws:7776 dir
  # set the port websocket listens

  doodle -h
  doodle --help
  doodle help:
  # print help

  """
  process.exit()

# parse options

watch_files = []
options = {}

print_help() if "-h" in process.argv
print_help() if "--help" in process.argv
print_help() if "help:" in process.argv

process.argv[2..].forEach (string) ->
  if string.match /\S:\S/
    [key, value] = string.split ":"
    options[key] = value
  else
    watch_files.push string

print_help() if watch_files.length is 0

if options.log in ["true", "yes", "on"]
  log = console.log

options.ws = Number options.ws if options.ws?
options.port = Number options.port if options.port?
if options.port? and not options.ws?
  options.ws = options.port - 1

if options.delay?
  options.delay = Number options.delay
else
  options.delay = 100

log "options:", options
log "watching:", watch_files

# starts the websocket server

WebSocketServer = require('ws').Server
wss = new WebSocketServer
  port: options.ws or 7776
  host: '0.0.0.0'
wss.on 'connection', (ws) ->
  notify = -> try ws.send "reload"
  center.on "update", notify
  ws.on 'close', -> center.removeListener "update", notify

# load client script

filename = path.join __dirname, "doodle.js"
client = fs.readFileSync filename, "utf8"
client = client.replace /7776/, options.ws if options.ws?

# server the client javascript code

app = http.createServer (req, res) ->
  res.writeHead 200, 'Content-Type': 'text/javascript'
  res.end client
app.listen (options.port or 7777)

# start listening

watch_files.forEach (file) ->
  watcher = chokidar.watch file
  watcher.on "change", (path) ->
    delay options.delay, ->
      center.emit "update"
      log "Update from:", path