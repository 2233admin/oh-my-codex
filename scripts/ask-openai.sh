#!/bin/bash
# ask-openai.sh - 通用 OpenAI 兼容模型调用脚本 (指向 NewAPI)

# 配置区 (建议通过环境变量注入)
API_KEY="${OPENAI_API_KEY}"
API_URL="${OPENAI_API_BASE:-http://localhost:3000/v1}"
MODEL="${OPENAI_MODEL:-deepseek-chat}"

# 接收来自 OMC 的 Stdin
INPUT=$(cat)

# 调用 API
curl -s -X POST "$API_URL/chat/completions" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $API_KEY" \
  -d "{
    \"model\": \"$MODEL\",
    \"messages\": [{\"role\": \"user\", \"content\": $(echo "$INPUT" | jq -R -s .)}],
    \"stream\": false
  }" | jq -r '.choices[0].message.content'
