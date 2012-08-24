
### Doodle: reload you html

Command-line tool for making static web pages, save and reload.
Use Node to watch files, use `websocket` to notify the html page to reload.
The page gets the message an then reload automatically.
Connecting and reloading from a another computor is ok.

### Usage:

You can install `doodle` from npm by:
  sudo npm install -g doodle
Then if the file(of directory) names `"path-x"`, run this command:
  doodle path-x
`doodle` will open a `ws://` server at port `8071`,
and put the `doodle.js` file at `8072`.

You can add ether of these code to you html file to reload:
1) add `doodle.js` into an `<script> tag`:
  :jade
    script(src='http://localhost:8072/doodle.js')
    // - `localhost` should be the hostname
2) or add javascript code by yourself:
  :coffeescript
    hostname = location.hostname
    ws = new WebSocket "ws://#{hostname}:8071"
    ws.onmessage = (message) ->
      if message.data is 'reload'
        do location.reload
check `example/` directory for more details.

### License:
MIT
