#!/bin/bash

# Set up nginx site.
ln -s /etc/nginx/sites-available/mastodon /etc/nginx/sites-enabled/mastodon

# Create and enable Mastodon system services.
cp /home/mastodon/live/dist/mastodon-*.service /etc/systemd/system/
systemctl daemon-reload
systemctl enable mastodon-web mastodon-sidekiq mastodon-streaming

# Clean up the system.

apt-get autoremove -y
apt-get clean -y
rm -r /var/lib/apt/lists/*
