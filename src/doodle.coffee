
hostname = location.hostname
ws = new WebSocket "ws://#{hostname}:7776"
ws.onmessage = (message) ->
  console.log 'message'
  if message.data is 'reload'
    do location.reload

delay = (t, f) -> setTimeout f, t

ws.onclose = -> delay 1000, location.reload()