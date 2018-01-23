# CI Build script needed to run the whole build with one script on a docker container.
# This build runs tests, and outputs a release NuGet package. If feed and feed key are 
# defined then also publishes the package.
#
# Example to run on dev environment without docker, without publish
#   ./publish.sh 0.1.0-something
# 
# Example inside docker with publish, emulating how it is run on Google Cloud Container Builder:
#     docker run -v $(pwd):/workspace --entrypoint bash \
#        microsoft/dotnet:2.0.5-sdk-2.1.4-stretch \
#        /workspace/Assets/Plugins/GameModel/publish.sh 0.1.2-foo https://www.myget.org/F/games/api/v2/package [my-feed-key]


# Exit on any error
set -e

VER=$1
FEED=$2
FEED_KEY=$3

echo "Starting test, package and publish"

if [ -d "/workspace" ]; then
    echo "Switching to /workspace"
    cd /workspace
fi

# Add other test projects to this list when needed
dotnet test UnitTestProject1
dotnet pack ReliableNetcode /p:PackageVersion=$VER --include-symbols --configuration Release

if [ -z "$FEED" ]; then
    echo "Package feed not defined, skipping package publish"
else
    echo "Publishing package $VER to $FEED"
	dotnet nuget push -s $FEED -k $FEED_KEY ReliableNetcode/bin/Release/ReliableNetcode.NET.$VER.nupkg
	dotnet nuget push -s $FEED -k $FEED_KEY ReliableNetcode/bin/Release/ReliableNetcode.NET.$VER.symbols.nupkg
fi

echo "OK"