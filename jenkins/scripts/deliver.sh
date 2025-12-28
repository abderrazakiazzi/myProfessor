#!/usr/bin/env sh

npm run ng build
npm run start &
sleep 1
echo $! > .pidfile

echo 'Now...'
echo 'Visit http://localhost:4200 to see your Node.js/Angular application in action.'