platform=linux/arm64
prefix=/opt/circleci
sudo mkdir -p "$prefix/workdir"
base_url="https://circleci-binary-releases.s3.amazonaws.com/circleci-launch-agent"
echo "Determining latest version of CircleCI Launch Agent"
agent_version=$(curl "$base_url/release.txt")
echo "Using CircleCI Launch Agent version $agent_version"
echo "Downloading and verifying CircleCI Launch Agent Binary"
curl -sSL "$base_url/$agent_version/checksums.txt" -o checksums.txt
file="$(grep -F "$platform" checksums.txt | cut -d ' ' -f 2 | sed 's/^.//')"
mkdir -p "$platform"
echo "Downloading CircleCI Launch Agent: $file"
curl --compressed -L "$base_url/$agent_version/$file" -o "$file"
echo "Verifying CircleCI Launch Agent download"
grep "$file" checksums.txt | sha256sum --check && chmod +x "$file" || echo "Invalid checksum for CircleCI Launch Agent, please try download again"
