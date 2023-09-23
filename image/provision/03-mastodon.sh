#!/bin/bash

# Ensure we are in the mastodon user's home directory.
cd ~
source ~/.bash_profile

git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build

# Install ruby.
RUBY_CONFIGURE_OPTS=--with-jemalloc rbenv install "$RUBY_VERSION"
rbenv global "$RUBY_VERSION"

# Install bundler.
gem install bundler --no-document

# Clone the deacon.social fork of Mastodon.
git clone https://github.com/deaconsocial/mastodon.git live
cd live
git checkout "$MASTODON_VERSION"
bundle config deployment 'true'
bundle config without 'development test'
bundle install -j$(getconf _NPROCESSORS_ONLN)
yarn install --pure-lockfile

echo '#################################' > .env.production
echo '## THIS IS A SAMPLE FILE.' >> .env.production
echo '## PLEASE REPLACE FOR PRODUCTION.' >> .env.production
cat .env.production.sample >> .env.production

RAILS_ENV=production bundle exec rails assets:precompile
