#!/bin/bash
# ask-roulette-pro.sh - 智能轮盘：基于状态的分布式模型切换

REDIS_URL="${A2A_REDIS_URL:-redis://:fsc-mesh-2026@100.80.87.180:6379}"
MODE="${ROULETTE_MODE:-alternating}" # 默认轮流模式: alternating | random

# 定义算力池
MODELS=("claude" "gemini" "openai")
NUM_MODELS=${#MODELS[@]}

# 接收 Stdin
INPUT_FILE=$(mktemp)
cat > "$INPUT_FILE"

SELECTED_MODEL=""

if [ "$MODE" == "random" ]; then
    # 随机逻辑
    SELECTED_MODEL=${MODELS[$((RANDOM % NUM_MODELS))]}
else
    # 轮流逻辑 (从 Redis 获取上一次的 index)
    LAST_INDEX=$(redis-cli -u "$REDIS_URL" GET omc:roulette:index 2>/dev/null)
    if [ -z "$LAST_INDEX" ]; then LAST_INDEX=-1; fi
    
    CURRENT_INDEX=$(((LAST_INDEX + 1) % NUM_MODELS))
    SELECTED_MODEL=${MODELS[$CURRENT_INDEX]}
    
    # 更新 Redis 索引
    redis-cli -u "$REDIS_URL" SET omc:roulette:index $CURRENT_INDEX > /dev/null
fi

# 注入到 Agent 的 Stdin 中，告诉它现在的身份 (可选，为了让它更有代入感)
# echo "System: You are currently acting as $SELECTED_MODEL backbone." >&2

# 执行调用
case $SELECTED_MODEL in
  claude)
    cat "$INPUT_FILE" | bash "$(dirname "$0")/ask-claude.sh"
    ;;
  gemini)
    cat "$INPUT_FILE" | bash "$(dirname "$0")/ask-gemini.sh"
    ;;
  openai)
    cat "$INPUT_FILE" | bash "$(dirname "$0")/ask-openai.sh"
    ;;
esac

rm "$INPUT_FILE"
