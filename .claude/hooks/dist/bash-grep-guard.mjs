// src/bash-grep-guard.ts
import { readFileSync } from "fs";
var BLOCKED_PATTERNS = [
  /grep\s+(-[a-zA-Z]+\s+)*.*node_modules/,
  /grep\s+.*node_modules/,
  /rg\s+.*node_modules/
  // Also catch rg on node_modules without --ignore
];
async function main() {
  let input;
  try {
    input = JSON.parse(readFileSync(0, "utf-8"));
  } catch {
    console.log("{}");
    return;
  }
  if (input.tool_name !== "Bash") {
    console.log("{}");
    return;
  }
  const command = input.tool_input?.command || "";
  const isBlockedGrep = BLOCKED_PATTERNS.some((pattern) => pattern.test(command));
  if (isBlockedGrep) {
    const output = {
      hookSpecificOutput: {
        hookEventName: "PreToolUse",
        permissionDecision: "deny",
        permissionDecisionReason: `\u26A0\uFE0F **Blocked: grep on node_modules (2.9GB, 67k files)**

This command would freeze Claude Code for 30-60+ seconds.

**Instead, use the Grep tool** which respects .rgignore:
\`\`\`
Grep(pattern="your_pattern", path="src/")
\`\`\`

Or search specific files:
\`\`\`
Grep(pattern="your_pattern", glob="**/*.ts")
\`\`\`

The Grep tool uses ripgrep which auto-excludes node_modules via .rgignore.`
      }
    };
    console.log(JSON.stringify(output));
    return;
  }
  console.log("{}");
}
main().catch(console.error);
