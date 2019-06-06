#! /bin/bash
echo "================================================================="
echo " Building Docker Image, using Dockerfile:"
echo "================================================================="
cat Dockerfile
echo "================================================================="
echo "Starting build..."
echo "================================================================="
docker login -u $DOCKER_USER -p $DOCKER_PASS
export REPO=qcifengineering/peppermint-portal
export TAG=`if [ "$TRAVIS_BRANCH" == "master" ]; then echo "latest"; else echo $TRAVIS_BRANCH; fi`
docker build -f Dockerfile -t $REPO:$COMMIT .
docker tag $REPO:$COMMIT $REPO:$TAG
docker tag $REPO:$COMMIT $REPO:travis-$TRAVIS_BUILD_NUMBER
docker push $REPO
echo "================================================================="
echo "Docker build complete."
echo "================================================================="
