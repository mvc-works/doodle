
### Doodle: reload you html  

Command-line tool for making static web pages, save and reload.  
Uses Node to watch files and dirs, opens a `websocket` connection to notify the html page.  
The page gets the message and then reload automatically.  
Connecting and reloading from a another computor is ok.  

### Usage:  

You can install `doodle` from npm by:  

    sudo npm install -g doodle

Then run this command in your terminal to start waching:  

    doodle path1 path2 path3 dir1 dir2 dir3

`doodle` will open a `ws://` server at port `7776`,  
and put the `doodle.js` file at `7777`.  

You can add a `<script>` tag to you html file to reload:  

    :jade
      script(src='http://localhost:7777/doodle.js')
      // - `localhost` should be the hostname

check `example/` directory for more details.  

### License:  

MIT  