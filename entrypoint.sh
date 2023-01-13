#!/usr/bin/env bash

bundle install --jobs 20
bin/rails webpacker:install
bin/rails db:prepare
./bin/webpack-dev-server &
bin/rails server -b 0.0.0.0