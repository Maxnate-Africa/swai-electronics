#!/usr/bin/env bash
set -euo pipefail

echo "[Netlify] Installing Ruby gems with Bundler"
bundle install --path vendor/bundle

echo "[Netlify] Building Jekyll site"
JEKYLL_ENV=production bundle exec jekyll build

echo "[Netlify] Preparing cms-admin publish directory"
rm -rf netlify-deploy
mkdir -p netlify-deploy

if [ -d "_site/cms-admin" ]; then
  cp -R _site/cms-admin/* netlify-deploy/
else
  echo "[Netlify] ERROR: _site/cms-admin not found. Is cms-admin present in the repo?"
  exit 1
fi

echo "[Netlify] Copying minimal assets required by CMS"
mkdir -p netlify-deploy/assets
[ -d "_site/assets/css" ] && cp -R _site/assets/css netlify-deploy/assets/ || true
[ -d "_site/assets/images" ] && cp -R _site/assets/images netlify-deploy/assets/ || true

echo "[Netlify] Done. Publish dir contents:"
ls -la netlify-deploy || true
