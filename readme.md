
### Doodle: reload you html  

Node to watch the files, use `websocket` to notify the html page and the reload.  

### Usage  

You can install `doodle` from npm by:  

    sudo npm install -g doodle

Then if the file(of directory) names `"path-x"`, run this command:  

    doodle path-x

`doodle` will open a `ws://` server at port `8071`,  
and put the `doodle.js` file at `8072`.  

You can add ether of these code to you html file to catch the `reload` signal:  
1) add `doodle.js` into an `<script> tag`:  

    :jade
      script(src='http://localhost:8072/doodle.js')

2) add javascript code by yourself:  

    :coffeescript
      ws = new WebSocket 'ws://localhost:8071'
      ws.onmessage = (message) ->
        if message.data is 'reload'
          do location.reload

check `example/` directory for more details.  

### License  
BSD  
