
require('calabash').do 'dev',
  "coffee -o lib/ -wbc src/"
  "jade -wP example/demo-tag.jade"
  "node-dev bin/doodle example/demo-tag.html"