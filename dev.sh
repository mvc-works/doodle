
cd `dirname $0`
subl -a .

coffee -o lib/ -wc src/*coffee &
jade -wP example/*jade &
node-dev ./bin/doodle example/*html &

read

pkill -f coffee
pkill -f jade
pkill -f node-dev