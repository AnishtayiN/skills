#!/bin/bash

# 🧠 Coding Agent Skill Library Installer
# Usage: ./install.sh [agent] [target-dir]

set -e

SKILLS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

print_banner() {
    echo -e "${CYAN}"
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║      🧠 Coding Agent Skill Library - v3.0.0                ║"
    echo "║      28 Professional Skills for Coding Agents              ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

print_success() { echo -e "${GREEN}✅ $1${NC}"; }
print_error() { echo -e "${RED}❌ $1${NC}"; }
print_info() { echo -e "${BLUE}ℹ️  $1${NC}"; }

count_skills() {
    find "$SKILLS_DIR" -name "SKILL.md" -type f | wc -l
}

install_claude() {
    local target="${1:-.}"
    echo -e "\n${CYAN}📦 Installing for Claude Code...${NC}\n"
    
    mkdir -p "$target/.claude/skills"
    cp -r "$SKILLS_DIR"/core/*/SKILL.md "$target/.claude/skills/" 2>/dev/null || true
    cp -r "$SKILLS_DIR"/coding/*/SKILL.md "$target/.claude/skills/" 2>/dev/null || true
    cp -r "$SKILLS_DIR"/quality/*/SKILL.md "$target/.claude/skills/" 2>/dev/null || true
    cp -r "$SKILLS_DIR"/architecture/*/SKILL.md "$target/.claude/skills/" 2>/dev/null || true
    cp -r "$SKILLS_DIR"/git/*/SKILL.md "$target/.claude/skills/" 2>/dev/null || true
    cp -r "$SKILLS_DIR"/devops/*/SKILL.md "$target/.claude/skills/" 2>/dev/null || true
    cp -r "$SKILLS_DIR"/security/*/SKILL.md "$target/.claude/skills/" 2>/dev/null || true
    cp -r "$SKILLS_DIR"/performance/*/SKILL.md "$target/.claude/skills/" 2>/dev/null || true
    cp -r "$SKILLS_DIR"/ai/*/SKILL.md "$target/.claude/skills/" 2>/dev/null || true
    cp -r "$SKILLS_DIR"/documentation/*/SKILL.md "$target/.claude/skills/" 2>/dev/null || true
    
    # Copy management files
    cp "$SKILLS_DIR/ROUTER.md" "$target/.claude/" 2>/dev/null || true
    cp "$SKILLS_DIR/AGENT.md" "$target/.claude/" 2>/dev/null || true
    
    if [ ! -f "$target/CLAUDE.md" ]; then
        cat > "$target/CLAUDE.md" << 'EOF'
# CLAUDE.md

## 🧠 Skills

This project uses skills from the Coding Agent Skill Library.
When performing tasks, read the relevant skill file from `.claude/skills/` first.

### Quick Reference
- `skills/debugging/SKILL.md` — For debugging
- `skills/code-review/SKILL.md` — For code review
- `skills/testing/SKILL.md` — For testing
- `skills/code-generation/SKILL.md` — For writing code
- `skills/verification/SKILL.md` — For verifying changes
EOF
    fi
    
    print_success "Installed $(count_skills) skills for Claude Code"
}

install_cursor() {
    local target="${1:-.}"
    echo -e "\n${CYAN}📦 Installing for Cursor AI...${NC}\n"
    
    mkdir -p "$target/.cursor/skills"
    cp -r "$SKILLS_DIR"/core/*/SKILL.md "$target/.cursor/skills/" 2>/dev/null || true
    cp -r "$SKILLS_DIR"/coding/*/SKILL.md "$target/.cursor/skills/" 2>/dev/null || true
    cp -r "$SKILLS_DIR"/quality/*/SKILL.md "$target/.cursor/skills/" 2>/dev/null || true
    cp -r "$SKILLS_DIR"/architecture/*/SKILL.md "$target/.cursor/skills/" 2>/dev/null || true
    cp -r "$SKILLS_DIR"/git/*/SKILL.md "$target/.cursor/skills/" 2>/dev/null || true
    cp -r "$SKILLS_DIR"/devops/*/SKILL.md "$target/.cursor/skills/" 2>/dev/null || true
    cp -r "$SKILLS_DIR"/security/*/SKILL.md "$target/.cursor/skills/" 2>/dev/null || true
    cp -r "$SKILLS_DIR"/performance/*/SKILL.md "$target/.cursor/skills/" 2>/dev/null || true
    cp -r "$SKILLS_DIR"/ai/*/SKILL.md "$target/.cursor/skills/" 2>/dev/null || true
    cp -r "$SKILLS_DIR"/documentation/*/SKILL.md "$target/.cursor/skills/" 2>/dev/null || true
    
    if [ ! -f "$target/.cursorrules" ]; then
        cat > "$target/.cursorrules" << 'EOF'
# Cursor Rules

## Skills

Read the relevant skill file from `.cursor/skills/` before performing tasks.
EOF
    fi
    
    print_success "Installed $(count_skills) skills for Cursor AI"
}

install_all() {
    local target="${1:-.}"
    install_claude "$target"
    install_cursor "$target"
    print_success "All agents configured!"
}

show_help() {
    echo "Usage: ./install.sh [agent] [target-dir]"
    echo ""
    echo "Agents:"
    echo "  claude    Install for Claude Code"
    echo "  cursor    Install for Cursor AI"
    echo "  all       Install for all agents"
    echo ""
    echo "Examples:"
    echo "  ./install.sh claude"
    echo "  ./install.sh cursor /path/to/project"
}

main() {
    print_banner
    
    local agent="${1:-}"
    local target="${2:-.}"
    
    case "$agent" in
        claude) install_claude "$target" ;;
        cursor) install_cursor "$target" ;;
        all) install_all "$target" ;;
        -h|--help) show_help ;;
        "")
            print_info "No agent specified. Use: ./install.sh [claude|cursor|all]"
            ;;
        *)
            print_error "Unknown agent: $agent"
            show_help
            exit 1
            ;;
    esac
    
    echo ""
    echo -e "${CYAN}📚 Documentation: https://github.com/AnishtayiN/skills#readme${NC}"
    echo ""
}

main "$@"
