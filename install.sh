#!/bin/bash

# 🧠 Coding Agent Skill Library Installer
# Usage: ./install.sh [agent] [target-dir]

set -e

SKILLS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
NEW_SKILLS_DIR="$SKILLS_DIR/new-skills"

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
    echo "║      25 Professional Skills for Coding Agents              ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

print_success() { echo -e "${GREEN}✅ $1${NC}"; }
print_error() { echo -e "${RED}❌ $1${NC}"; }
print_info() { echo -e "${BLUE}ℹ️  $1${NC}"; }

count_skills() {
    find "$NEW_SKILLS_DIR" -name "SKILL.md" -type f 2>/dev/null | wc -l
}

copy_skills() {
    local target="$1"
    
    # Create skills directory
    mkdir -p "$target/skills"
    
    # Copy all skill directories
    for category in core coding quality architecture git devops security performance ai documentation; do
        if [ -d "$NEW_SKILLS_DIR/$category" ]; then
            cp -r "$NEW_SKILLS_DIR/$category" "$target/skills/" 2>/dev/null || true
        fi
    done
    
    # Copy management files
    cp "$NEW_SKILLS_DIR/ROUTER.md" "$target/skills/" 2>/dev/null || true
    cp "$NEW_SKILLS_DIR/AGENT.md" "$target/skills/" 2>/dev/null || true
    cp "$NEW_SKILLS_DIR/SKILL-MATRIX.md" "$target/skills/" 2>/dev/null || true
}

install_claude() {
    local target="${1:-.}"
    echo -e "\n${CYAN}📦 Installing for Claude Code...${NC}\n"
    
    # Create .claude directory
    mkdir -p "$target/.claude"
    
    # Copy skills
    copy_skills "$target/.claude"
    
    # Create or update CLAUDE.md
    if [ -f "$target/CLAUDE.md" ]; then
        print_info "CLAUDE.md already exists. Adding skills section..."
        cat >> "$target/CLAUDE.md" << 'EOF'

---

## 🧠 Skills

This project uses skills from the Coding Agent Skill Library.
When performing tasks, read the relevant skill file from `.claude/skills/` first.

### Quick Reference
- `skills/core/project-analysis/SKILL.md` — Analyze project
- `skills/coding/debugging/SKILL.md` — Debug issues
- `skills/quality/code-review/SKILL.md` — Review code
- `skills/quality/testing/SKILL.md` — Write tests
- `skills/quality/verification/SKILL.md` — Verify changes
EOF
    else
        cat > "$target/CLAUDE.md" << 'EOF'
# CLAUDE.md

## 🧠 Skills

This project uses skills from the Coding Agent Skill Library.
When performing tasks, read the relevant skill file from `.claude/skills/` first.

### Quick Reference
- `skills/core/project-analysis/SKILL.md` — Analyze project
- `skills/coding/debugging/SKILL.md` — Debug issues
- `skills/quality/code-review/SKILL.md` — Review code
- `skills/quality/testing/SKILL.md` — Write tests
- `skills/quality/verification/SKILL.md` — Verify changes

### Core Principles
1. **Evidence First** — Never guess. Always verify.
2. **Minimal Fix** — Smallest change that fixes root cause.
3. **Verification Required** — Never claim success without proof.
EOF
    fi
    
    print_success "Installed $(count_skills) skills for Claude Code"
    print_info "Location: $target/.claude/skills/"
}

install_cursor() {
    local target="${1:-.}"
    echo -e "\n${CYAN}📦 Installing for Cursor AI...${NC}\n"
    
    # Create .cursor directory
    mkdir -p "$target/.cursor"
    
    # Copy skills
    copy_skills "$target/.cursor"
    
    # Create or update .cursorrules
    if [ -f "$target/.cursorrules" ]; then
        print_info ".cursorrules already exists. Adding skills section..."
        cat >> "$target/.cursorrules" << 'EOF'

---

## Skills

Read the relevant skill file from `.cursor/skills/` before performing tasks.
Follow the verification-first principle.
EOF
    else
        cat > "$target/.cursorrules" << 'EOF'
# Cursor Rules

## Skills

Read the relevant skill file from `.cursor/skills/` before performing tasks.

### Core Principles
1. **Evidence First** — Never guess. Always verify.
2. **Minimal Fix** — Smallest change that fixes root cause.
3. **Verification Required** — Never claim success without proof.

### Quick Reference
- `skills/core/project-analysis/SKILL.md` — Analyze project
- `skills/coding/debugging/SKILL.md` — Debug issues
- `skills/quality/code-review/SKILL.md` — Review code
- `skills/quality/testing/SKILL.md` — Write tests
- `skills/quality/verification/SKILL.md` — Verify changes
EOF
    fi
    
    print_success "Installed $(count_skills) skills for Cursor AI"
    print_info "Location: $target/.cursor/skills/"
}

install_all() {
    local target="${1:-.}"
    install_claude "$target"
    install_cursor "$target"
    echo ""
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
    echo "  ./install.sh all"
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
            echo ""
            show_help
            ;;
        *)
            print_error "Unknown agent: $agent"
            show_help
            exit 1
            ;;
    esac
    
    echo ""
    echo -e "${CYAN}📚 Skills: $NEW_SKILLS_DIR${NC}"
    echo -e "${CYAN}📖 Documentation: https://github.com/AnishtayiN/skills#readme${NC}"
    echo ""
}

main "$@"
