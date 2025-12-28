#!/usr/bin/env sh

npm run ng build
npm run build:ssr
# Lancer le serveur SSR en background
node dist/your-app/server/main.js &
echo \$! > .pidfile
sleep 5   # attendre que le serveur démarre
npm run start &
sleep 1
echo $! > .pidfile

echo 'Now...'
echo 'Visit http://localhost:4200 to see your Node.js/Angular application in action.'