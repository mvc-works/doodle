
hostname = location.hostname
ws = new WebSocket "ws://#{hostname}:7776"
ws.onmessage = (message) ->
  # console.log 'message'
  if message.data is 'reload'
    console.log 'reload event'
    do location.reload

delay = (t, f) -> setTimeout f, t

ws.onclose = ->
  console.log 'closed'
  delay 1000, -> location.reload()