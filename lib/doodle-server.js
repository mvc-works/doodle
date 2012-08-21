(function() {
  var app, delay, demo, fs, here, http, make, path, readFile, repeat, script, sendDemo, sendSSE, sendScript, show, stemp, watchDir, watchFile, watchPath;

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
    return new Date().getTime().toString();
  };

  stemp = make();

  sendSSE = function(res) {
    var count, me, record;
    res.writeHead(200, {
      'Content-Type': 'text/event-stream',
      'Cache-Control': 'no-cache',
      'Connection': 'keep-alive'
    });
    record = stemp;
    count = 0;
    return me = repeat(1000, function() {
      count += 1;
      if (stemp !== record) {
        res.write('data:...\n\n');
        clearInterval(me);
        return show('use end');
      }
    });
  };

  script = path.join(__dirname, '../lib/doodle-client.js');

  demo = path.join(__dirname, '../example/demo.html');

  sendScript = function(res) {
    res.writeHead(200, {
      'Content-Type': 'text/javascript'
    });
    return fs.readFile(script, function(err, data) {
      if (err != null) throw err;
      return res.end(data);
    });
  };

  sendDemo = function(res) {
    show('sendDemo');
    res.writeHead(200, {
      'Content-Type': 'text/html'
    });
    return fs.readFile(demo, 'utf8', function(err, data) {
      show(data);
      if (err != null) throw err;
      return res.end(data);
    });
  };

  here = process.env.PWD;

  app = http.createServer(function(req, res) {
    var filepath;
    show(req.url);
    switch (req.url) {
      case '/?events':
        return sendSSE(res);
      case '/?doodle.js':
        return sendScript(res);
      default:
        filepath = path.join(here, req.url);
        show(filepath);
        return fs.readFile(filepath, 'utf8', function(err, data) {
          if (err != null) {
            return res.end('404');
          } else {
            return res.end(data);
          }
        });
    }
  });

  app.listen(7890);

  watchFile = function(name) {
    var op;
    op = {
      interval: 1000
    };
    fs.watchFile(name, op, function() {
      stemp = make();
      return show(stemp);
    });
    return show(name);
  };

  watchDir = function(name) {
    var list;
    list = fs.readdirSync(name);
    return list.forEach(function(item) {
      return watchPath(path.join(name, item));
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

  process.argv.slice(2).forEach(function(name) {
    var filepath;
    filepath = path.join(here, name);
    return watchPath(filepath);
  });

  readFile = function(name, res) {
    return fs.readFile(name, 'utf8', function(err, data) {
      return res.write(data);
    });
  };

}).call(this);
