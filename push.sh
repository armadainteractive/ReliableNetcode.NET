# CI Build script to push the nuget package to nuget feed.
# 
# Example inside docker with publish, emulating how it is run on Google Cloud Container Builder:
#     docker run -v $(pwd):/workspace --entrypoint bash microsoft/dotnet:2.0.5-sdk-2.1.4-stretch /workspace/push.sh 0.1.2-foo https://www.myget.org/F/games/api/v2/package [my-feed-key]
#
# Exit on any error
set -e

VER=$1
FEED=$2
FEED_KEY=$3

if [ -d "/workspace" ]; then
    echo "Switching to /workspace"
    cd /workspace
fi

echo "Publishing package $VER to $FEED"

dotnet nuget push -s $FEED -k $FEED_KEY ./ReliableNetcode.NET.$VER.nupkg

echo "OK"