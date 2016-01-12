#!/bin/sh

run() {
  echo
  echo "$@"
  "$@"
}

version="$@"
[ -n "$version" ] || {
  echo "Usage: `basename $0` <version>"
  exit 1
}

echo "Build and deploy hadoop release-$version"
run mvn versions:set -DnewVersion=$version
run mvn versions:commit
run git add -v *
run git commit -m "Prepare release-$version"
run git pull
run git push
run git tag release-$version
run git push --tags
run git checkout release-$version
run mvn clean
run mvn install -f hadoop-maven-plugins/pom.xml
run mvn package -Pdist,docs,src -DskipTests -Dtar
run mvn deploy -DskipTests

echo
echo "Deploy hadoop version $version finished"