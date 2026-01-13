#!/bin/bash

# Read the JSON input from stdin
input=$(cat)

# Extract API key from Claude Code config
API_KEY=$(grep -h "apiKey" ~/.claude/config.json 2>/dev/null | sed 's/.*"apiKey": *"\([^"]*\)".*/\1/')

if [ -z "$API_KEY" ]; then
    echo "Usage data unavailable"
    exit 0
fi

# Fetch usage data from Claude API
response=$(curl -s --max-time 2 \
    -H "x-api-key: $API_KEY" \
    -H "anthropic-version: 2023-06-01" \
    https://api.anthropic.com/v1/organization/usage 2>/dev/null)

if [ $? -ne 0 ] || [ -z "$response" ]; then
    echo "Usage data unavailable"
    exit 0
fi

# Parse usage data
input_tokens=$(echo "$response" | jq -r '.usage[0].input_tokens // 0' 2>/dev/null)
output_tokens=$(echo "$response" | jq -r '.usage[0].output_tokens // 0' 2>/dev/null)
limit_tokens=$(echo "$response" | jq -r '.usage[0].limit_tokens // 0' 2>/dev/null)
reset_date=$(echo "$response" | jq -r '.usage[0].reset_date // ""' 2>/dev/null)

# Calculate total usage and percentage
if [ "$limit_tokens" -gt 0 ]; then
    total_usage=$((input_tokens + output_tokens))
    usage_percent=$(awk "BEGIN {printf \"%.1f\", ($total_usage / $limit_tokens) * 100}")
    
    # Format reset date (from YYYY-MM-DD to more readable format)
    if [ -n "$reset_date" ] && [ "$reset_date" != "null" ]; then
        formatted_date=$(date -d "$reset_date" "+%b %d" 2>/dev/null || echo "$reset_date")
        echo "Usage: ${usage_percent}% | Resets: ${formatted_date}"
    else
        echo "Usage: ${usage_percent}%"
    fi
else
    echo "Usage data unavailable"
fi