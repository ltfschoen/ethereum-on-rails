FROM ruby:3.0.3-bullseye AS base

ARG APP_PATH=/app
ARG PORT=${PORT}
ARG PORT_WEB=${PORT_WEB}
ARG RAILS_ENV=${RAILS_ENV}

ENV RAILS_ENV=${RAILS_ENV}

# use a global path instead of vendor
ENV GEM_HOME="/usr/local/bundle"
ENV BUNDLE_PATH="$GEM_HOME"
ENV BUNDLE_SILENCE_ROOT_WARNING=1
ENV BUNDLE_APP_CONFIG="$GEM_HOME"
ENV PATH="$GEM_HOME/bin:$BUNDLE_PATH/gems/bin:${PATH}"

# make 'docker logs' work
ENV RAILS_LOG_TO_STDOUT=true

# Prepare working directory.
WORKDIR ${APP_PATH}

# Install packages.
RUN apt-get update -qq && \
    mkdir -p /app/.nvm && export NVM_DIR="${APP_PATH}/.nvm" && \
    wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | bash && \
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" && \
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" && \
    nvm install stable && \
    nvm use stable && \
    node --version && \
    npm install -g yarn && \
    yarn --version && \
    apt-get install -y rubygems sqlite3 libsqlite3-dev vim git
    # gem update --system && \
    # gem install bundler -v 2.3.7 && \
    # gem install rails && \
    # bundle install --jobs 20 && \
    # bin/rails assets:precompile && \
    # bin/rails webpacker:install && \
    # bin/rails db:migrate RAILS_ENV=${RAILS_ENV}
    # bin/rails db:prepare
    # yarn
# RUN rm -f tmp/pids/server.pid && \
#     apt-get clean && \
#     rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY . ${APP_PATH}

EXPOSE ${PORT}
EXPOSE ${PORT_WEB}

# build and start
ENTRYPOINT ["./entrypoint.sh"]
# CMD tail -f /dev/null
