#!/bin/bash
set -e

echo "#️⃣ === Broadcom Artifactory Credentials ==="

# 1. Handle Username Prompt / Env Fallback
if [ -n "$GEMFIRE_ARTIFACTORY_USERNAME" ]; then
    read -p "Enter Username [Default: $GEMFIRE_ARTIFACTORY_USERNAME]: " INPUT_USER
    GEMFIRE_ARTIFACTORY_USERNAME=${INPUT_USER:-$GEMFIRE_ARTIFACTORY_USERNAME}
else
    read -p "Enter Username: " GEMFIRE_ARTIFACTORY_USERNAME
fi

# 2. Handle Password Prompt / Env Fallback
if [ -n "$GEMFIRE_ARTIFACTORY_PASSWORD" ]; then
    echo -n "Enter Password [Default: existing environment variable]: "
    read -s INPUT_PASS
    echo ""
    GEMFIRE_ARTIFACTORY_PASSWORD=${INPUT_PASS:-$GEMFIRE_ARTIFACTORY_PASSWORD}
else
    echo -n "Enter Password: "
    read -s GEMFIRE_ARTIFACTORY_PASSWORD
    echo ""
fi

if [ -z "$GEMFIRE_ARTIFACTORY_USERNAME" ] || [ -z "$GEMFIRE_ARTIFACTORY_PASSWORD" ]; then
    echo "❌ Error: Credentials cannot be empty."
    exit 1
fi

export GEMFIRE_ARTIFACTORY_USERNAME
export GEMFIRE_ARTIFACTORY_PASSWORD

# 3. Handle GemFire Version Prompt
echo -e "\n🔢 === GemFire Version ==="
read -p "What version of GemFire should I use? [Default: 10.2.4]: " GEMFIRE_VERSION
GEMFIRE_VERSION=${GEMFIRE_VERSION:-10.2.4}

# 4. Immediate Execution
echo -e "\n🧼 Cleaning up past targets..."
./gradlew clean

echo "📥 Running Gradle for GemFire version $GEMFIRE_VERSION..."
./gradlew zipM2Dependencies -PgemfireVersion="$GEMFIRE_VERSION"

# 🔥 UPDATED: Tailored success message reflecting the new name
echo -e "\n🎉 Complete! Your package is ready at: build/dist/gemfire-dependencies-${GEMFIRE_VERSION}.zip"