
Doodle: watch JS files and reload pages via websocket
------

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

* `delay`, the time between hear file change and trigger a callback,  
by default, it's `100`

```
doodle dir delay:200
```

type `doodle help:` or `doodle -h` or `doodle --help` for the list.

* `http`, enable HTTP server for client-side listening script
by default, it's `false`

#### Client script

* doodle-crx

`doodle` will open a `ws://` server at port `options.ws`,  

[doodle-crx](https://github.com/jiyinyiyong/doodle-crx) is recommanded if you are using chrome.

* add script by hand

You can add a `<script>` tag to you html file to reload,  
using a command option `http:yes` to put `doodle.js` file at `options.port`.  
the port corresponds to `options.port`:

```jade
script(src='http://localhost:7777/doodle.js')
```

* copy the code

`coffee/doodle.coffee` shows a demo for listening the ws events and reload,
put it in you HTML and it would work.

### License:  

MIT  