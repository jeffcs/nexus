#!/bin/bash
# NEXUS Project Bootstrapper

PROJECT_NAME="${1:-my-nexus-project}"
echo "🌟 Bootstrapping new NEXUS project: $PROJECT_NAME"

mkdir -p "../$PROJECT_NAME"
cd "../$PROJECT_NAME"

echo "📁 Creating project structure..."
mkdir -p {src,tests,docs,.nexus}

echo "🧬 Linking to NEXUS core..."
ln -s ../nexus/.nexus-link .nexus/core

echo "📄 Generating initial configuration..."
cat > .nexus/config.yaml << EOC
project: $PROJECT_NAME
created: $(date -u +"%Y-%m-%dT%H:%M:%SZ")
nexus_version: 0.1.0
agents:
  - genesis
  - architect
  - forge
EOC

echo "✨ Project $PROJECT_NAME initialized!"
echo "📍 Location: $(pwd)"
