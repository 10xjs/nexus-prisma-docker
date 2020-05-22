#!/bin/sh
cd "$(dirname "$0")/.."
yarn install --frozen-lockfile --non-interactive
rm -rf node_modules/@types/mocha node_modules/@types/jest
yarn build
docker build --rm .