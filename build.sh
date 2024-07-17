#!/bin/sh

# Update package
apk update

# Install dependecys
apk add --no-cache \
    git \
    curl \
    openssl-dev \
    readline-dev \
    zlib-dev \
    build-base \
    bash \
    ruby \
    ruby-dev \

# Install ruby versioner and set PATH 
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
echo 'export PATH="$PATH:$HOME/.rbenv/bin"' >> /etc/profile
. /etc/profile
git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build

# Install and set ruby version
rbenv install 3.1.6
rbenv global 3.1.6

# Compile .c file
export PKG_CONFIG_PATH=$HOME/.rbenv/versions/3.1.6/lib/pkgconfig
gcc -fPIC -shared -o libcsv.so libcsv.c $(pkg-config --cflags --libs ruby-3.1)

# Install bundler
gem install bundler
# install dependecy and run unitary tests
bundle install
bundle exec rspec --init
bundle exec rspec spec/script_csv_spec.rb