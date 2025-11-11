#!/bin/bash

set -e  # Exit on error

echo "=== Cloning repositories and comparing code ==="
echo ""

# Define commit hashes
SERVERLESSLLM_COMMIT="097f4591ed3b12dc07dd198602cb20eacc2e58b6"
FLASHTENSORS_COMMIT="168d77568c89e302b077ab3357d7dd13d44fac92"

# Define clone directories
SERVERLESSLLM_DIR="ServerlessLLM"
FLASHTENSORS_DIR="flashtensors"

# Clone ServerlessLLM if not exists
if [ ! -d "$SERVERLESSLLM_DIR" ]; then
    echo "Cloning ServerlessLLM..."
    git clone https://github.com/ServerlessLLM/ServerlessLLM.git "$SERVERLESSLLM_DIR"
else
    echo "ServerlessLLM directory already exists, skipping clone"
fi

# Clone flashtensors if not exists
if [ ! -d "$FLASHTENSORS_DIR" ]; then
    echo "Cloning flashtensors..."
    git clone https://github.com/leoheuler/flashtensors.git "$FLASHTENSORS_DIR"
else
    echo "flashtensors directory already exists, skipping clone"
fi

echo ""

# Checkout specific commits
echo "Checking out ServerlessLLM commit: $SERVERLESSLLM_COMMIT"
cd "$SERVERLESSLLM_DIR"
git checkout "$SERVERLESSLLM_COMMIT"
cd ..

echo "Checking out flashtensors commit: $FLASHTENSORS_COMMIT"
cd "$FLASHTENSORS_DIR"
git checkout "$FLASHTENSORS_COMMIT"
cd ..

echo ""
echo "=== Running comparisons ==="
echo ""

# Comparison 1: checkpoint directories
echo "1. Comparing checkpoint directories..."
./compare_dirs.sh "$SERVERLESSLLM_DIR/sllm_store/csrc/checkpoint" "$FLASHTENSORS_DIR/csrc/checkpoint"

echo ""

# Comparison 2: store directories
echo "2. Comparing store directories (sllm_store vs store)..."
./compare_dirs.sh "$SERVERLESSLLM_DIR/sllm_store/csrc/sllm_store" "$FLASHTENSORS_DIR/csrc/store"

echo ""

# Comparison 3: proto directories
echo "3. Comparing proto directories..."
./compare_dirs.sh "$SERVERLESSLLM_DIR/sllm_store/proto" "$FLASHTENSORS_DIR/flashtensors/proto"

echo ""
echo "=== All comparisons complete ==="
echo "Check the generated diff files for results."
