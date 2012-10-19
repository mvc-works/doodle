
cd `dirname $0`

coffee -o lib/ -wc src/*coffee &
jade -wP example/*jade &
node-dev ./bin/doodle example/ &

read

pkill -f coffee
pkill -f jade
pkill -f node-dev