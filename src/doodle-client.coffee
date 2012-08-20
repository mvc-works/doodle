
source = new EventSource '/?events'
source.onmessage = (e) ->
  console.log 'e:', e
  if window.doodle? then do window.doodle
  else do window.location.reload

console.log 'js loaded'