
### Doodle: watch JS files and reload pages via websocket

Command-line tool for making static web pages, reload page on save.  
The page gets the message and then reload automatically.  
Connecting and reloading from a another computor is ok.  

### Usage:  

You can install `doodle` from npm by:  

```
sudo npm install -g doodle
```

Then run this command in your terminal to start waching,  
both files and directories are fine:

```
doodle path1 path2 path3 dir1 dir2 dir3
```

There are some options you may config,  
options are in the syntax of `key:value`, order is not required:

* `log`, print log or not:

```
doodle dir log:true
doodle dir log:yes
doodle dir log:on
doodle log:on dir
```

* `port`, the port serves `doodle.js` on http,  
by default, it's `7777`:  

```
doodle dir port:7777
```

* `ws`, the port websocket listens at,  
by default, it is `options.http - 1`:

```
doodle dir port:7776
```

### Client script

`doodle` will open a `ws://` server at port `options.ws`,  
and put the `doodle.js` file at `options.port`.  

You can add a `<script>` tag to you html file to reload,  
the port corresponds to `options.port`:

```jade
script(src='http://localhost:7777/doodle.js')
```

### License:  

MIT  