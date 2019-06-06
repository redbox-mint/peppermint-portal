#!/bin/sh
NVM_VERSION=v0.34.0
NODE_VERSION=10.16.0
NG_VERSION=8.0.1
YARN_VERSION=1.5.1

setup_git() {
  git config --global user.email "travis@travis-ci.org"
  git config --global user.name "Travis CI"
}

build() {
  echo "----------------------------------------------------------------------"
  echo "Building app"
  echo "----------------------------------------------------------------------"
  apt-get update; apt-get install wget git -y
  wget -qO- https://raw.githubusercontent.com/creationix/nvm/$NVM_VERSION/install.sh | bash
  export NG_CLI_ANALYTICS=ci; npm install -g @angular/cli@$NG_VERSION yarn@$YARN_VERSION; yarn install; ng build --prod --build-optimizer --output-path build/peppermint
  echo "----------------------------------------------------------------------"
  echo "Build complete..."
  echo "----------------------------------------------------------------------"
}

commit_files() {
  git checkout -b dev_build
  git rm -r --cached .
  rm -f .gitignore
  rm -f .travis.yml
  rm -Rf node_modules
  git add .
  git commit --message "Travis build: $TRAVIS_BUILD_NUMBER"
}

upload_files() {
  git remote add build-origin "https://shilob:$GH_TOKEN@github.com/redbox-mint/peppermint-portal"
  git push build-origin dev_build --force
}
echo "================================================================="
echo "Building dev_build branch..."
echo "================================================================="
setup_git
build
commit_files
upload_files
echo "================================================================="
echo "Build dev_build branch done."
echo "================================================================="
