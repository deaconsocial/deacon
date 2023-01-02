#!/bin/bash

# Install rbenv.
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
cd ~/.rbenv && src/configure && make -C src
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile
echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
exec bash
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
