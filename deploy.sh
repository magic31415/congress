#!/bin/bash

# Influenced by the nu_mart deploy script and deployment lecture notes

echo "Beginning Deploy"

git pull
mix deps.get
mix ecto.migrate

(cd assets && npm install)
(cd assets && ./node_modules/brunch/bin/brunch b -p)

mix release.init
mix phx.digest
mix release --env=prod

rm -rf ../release_congress
mkdir ../release_congress
cp _build/prod/rel/congress/releases/0.0.1/congress.tar.gz ../release_congress

cd ../release_congress
tar xzvf congress.tar.gz

./bin/congress stop || true
PORT=8002 ./bin/congress start
