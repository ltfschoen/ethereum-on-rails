#!/usr/bin/env bash

trap "echo; exit" INT
trap "echo; exit" HUP

# try to fetch public IP address if value not set in .env
PUBLIC_IP_ADDRESS_FALLBACK=$(curl https://ipecho.net/plain; echo)
PORT_FALLBACK=3000
PORT_WEB_FALLBACK=3035

# assign fallback values for environment variables from .env.example incase
# not declared in .env file. alternative approach is `echo ${X:=$X_FALLBACK}`
source $(dirname "$0")/.env.example
source $(dirname "$0")/.env
echo ${PUBLIC_IP_ADDRESS:=$PUBLIC_IP_ADDRESS_FALLBACK}
echo ${PORT:=$PORT_FALLBACK}
echo ${PORT_WEB:=$PORT_WEB_FALLBACK}
export RUBY_VERSION=$(awk '{split($0, array, "-"); print array[2]}' .ruby-version)
if [ "$RAILS_ENV" != "development" ]; then
    printf "\nError: RAILS_ENV should be set to development in .env\n";
    kill "$PPID"; exit 1;
fi
export PORT PORT_WEB RAILS_ENV

printf "\n*** Building Docker container. Please wait... \n***"
DOCKER_BUILDKIT=0 docker compose -f docker-compose.yml up --build -d
if [ $? -ne 0 ]; then
    kill "$PPID"; exit 1;
fi

# printf "\n*** Finished building. Please open:\n***"
# printf "\n*** - http://localhost:${PORT} (local server)"
# if [ "$PUBLIC_IP_ADDRESS" != "" ]; then
#     printf "\n*** - http://${PUBLIC_IP_ADDRESS}:${PORT} (remote server)\n***\n";
# fi
