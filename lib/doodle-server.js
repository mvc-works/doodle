(function() {
  var WebSocketServer, app, delay, fs, here, http, make, path, repeat, show, time, watchDir, watchFile, watchPath, wss;

  fs = require('fs');

  http = require('http');

  path = require('path');

  show = console.log;

  repeat = function(t, f) {
    return setInterval(f, t);
  };

  delay = function(t, f) {
    return setTimeout(f, t);
  };

  make = function() {
    var ret;
    ret = new Date().getTime().toString();
    show('reload time:', ret);
    return ret;
  };

  time = make();

  WebSocketServer = require('ws').Server;

  wss = new WebSocketServer({
    port: 8071
  });

  wss.on('connection', function(ws) {
    var me, record;
    show('connection');
    record = time;
    me = repeat(1000, function() {
      if (time !== record) return ws.send('reload');
    });
    return ws.on('close', function() {
      clearInterval(me);
      return show('close');
    });
  });

  watchFile = function(name) {
    var op;
    show('watch: ', name);
    op = {
      interval: 500
    };
    return fs.watchFile(name, op, function() {
      return time = make();
    });
  };

  watchDir = function(name) {
    var list;
    list = fs.readdirSync(name);
    return list.forEach(function(item) {
      if (item[0] !== '.') return watchPath(path.join(name, item));
    });
  };

  watchPath = function(name) {
    var stat;
    stat = fs.statSync(name);
    if (stat.isDirectory()) {
      return watchDir(name);
    } else if (stat.isFile()) {
      return watchFile(name);
    } else {
      return show('unkown file:', name);
    }
  };

  here = process.env.PWD;

  process.argv.slice(2).forEach(function(name) {
    var filepath;
    filepath = path.join(here, name);
    return watchPath(filepath);
  });

  app = http.createServer(function(req, res) {
    if (req.url === '/doodle.js') {
      res.writeHead(200, {
        'Content-Type': 'text/javascript'
      });
      return res.end("var ws = new WebSocket('ws://localhost:8071');\nws.onmessage = function(message){\n  console.log(message);\n  if (message.data === 'reload') location.reload();\n};");
    }
  });

  app.listen(8072);

}).call(this);
