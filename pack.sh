# CI Build script needed to nuget package this project within a docker container.
# This build runs tests, and outputs a release NuGet package. If feed and feed key are 
# defined then also publishes the package.
#
# Example inside docker, emulating how it is run on Google Cloud Container Builder:
#     docker run -v $(pwd):/workspace --entrypoint bash mono:latest /workspace/pack.sh 0.1.2-foo

# Exit on any error
set -e

VER=$1
FEED=$2
FEED_KEY=$3

if [ -d "/workspace" ]; then
    echo "Switching to /workspace"
    cd /workspace
fi

msbuild ReliableNetcode.NET.sln /p:Configuration=Release
nuget pack ./ReliableNetcode/ReliableNetcode.NET.nuspec -Verbosity detailed -Version $VER -Properties Configuration=Release

echo "OK"