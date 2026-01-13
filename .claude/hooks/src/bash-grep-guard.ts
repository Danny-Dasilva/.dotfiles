/**
 * Guard against slow grep commands on large directories like node_modules.
 *
 * Intercepts Bash tool calls containing grep on known-large directories
 * and suggests using the Grep tool instead (which respects .rgignore).
 */

import { readFileSync } from 'fs';

interface HookInput {
  tool_name: string;
  tool_input: {
    command?: string;
  };
}

interface HookOutput {
  hookSpecificOutput?: {
    hookEventName: string;
    permissionDecision: 'allow' | 'deny';
    permissionDecisionReason?: string;
  };
}

const BLOCKED_PATTERNS = [
  /grep\s+(-[a-zA-Z]+\s+)*.*node_modules/,
  /grep\s+.*node_modules/,
  /rg\s+.*node_modules/,  // Also catch rg on node_modules without --ignore
];

async function main(): Promise<void> {
  let input: HookInput;
  try {
    input = JSON.parse(readFileSync(0, 'utf-8'));
  } catch {
    console.log('{}');
    return;
  }

  // Only intercept Bash tool
  if (input.tool_name !== 'Bash') {
    console.log('{}');
    return;
  }

  const command = input.tool_input?.command || '';

  // Check if command is grepping node_modules
  const isBlockedGrep = BLOCKED_PATTERNS.some(pattern => pattern.test(command));

  if (isBlockedGrep) {
    const output: HookOutput = {
      hookSpecificOutput: {
        hookEventName: 'PreToolUse',
        permissionDecision: 'deny',
        permissionDecisionReason: `⚠️ **Blocked: grep on node_modules (2.9GB, 67k files)**

This command would freeze Claude Code for 30-60+ seconds.

**Instead, use the Grep tool** which respects .rgignore:
\`\`\`
Grep(pattern="your_pattern", path="src/")
\`\`\`

Or search specific files:
\`\`\`
Grep(pattern="your_pattern", glob="**/*.ts")
\`\`\`

The Grep tool uses ripgrep which auto-excludes node_modules via .rgignore.`,
      },
    };
    console.log(JSON.stringify(output));
    return;
  }

  // Allow all other Bash commands
  console.log('{}');
}

main().catch(console.error);
