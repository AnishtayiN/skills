#!/bin/bash

# 🧠 Coding Agent Skill Library Installer
# Interactive installer with agent detection

set -e

SKILLS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
NEW_SKILLS_DIR="$SKILLS_DIR/new-skills"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m'
BOLD='\033[1m'

print_banner() {
    clear
    echo -e "${CYAN}"
    echo "╔══════════════════════════════════════════════════════════════════╗"
    echo "║                                                                ║"
    echo "║           🧠 Coding Agent Skill Library - v3.0.0              ║"
    echo "║                                                                ║"
    echo "║           25 Professional Skills for Coding Agents             ║"
    echo "║           Evidence First • Minimal Fix • Verification          ║"
    echo "║                                                                ║"
    echo "╚══════════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

print_success() { echo -e "${GREEN}  ✅ $1${NC}"; }
print_info() { echo -e "${BLUE}  ℹ️  $1${NC}"; }
print_warning() { echo -e "${YELLOW}  ⚠️  $1${NC}"; }

# Check if agent is installed in current directory
check_agent() {
    local agent="$1"
    case "$agent" in
        claude)
            if [ -f "CLAUDE.md" ] && [ -d ".claude/skills" ]; then
                echo "installed"
            else
                echo "not_installed"
            fi
            ;;
        cursor)
            if [ -f ".cursorrules" ] && [ -d ".cursor/skills" ]; then
                echo "installed"
            else
                echo "not_installed"
            fi
            ;;
        windsurf)
            if [ -f ".windsurfrules" ] && [ -d ".windsurf/skills" ]; then
                echo "installed"
            else
                echo "not_installed"
            fi
            ;;
        aider)
            if [ -f ".aider.conf.yml" ] && [ -d ".aider/skills" ]; then
                echo "installed"
            else
                echo "not_installed"
            fi
            ;;
        continue)
            if [ -d ".continue/skills" ]; then
                echo "installed"
            else
                echo "not_installed"
            fi
            ;;
        hermes)
            if [ -d ".hermes/skills" ]; then
                echo "installed"
            else
                echo "not_installed"
            fi
            ;;
        *)
            echo "unknown"
            ;;
    esac
}

# Count installed skills for an agent
count_installed_skills() {
    local agent="$1"
    local skills_dir=""
    
    case "$agent" in
        claude) skills_dir=".claude/skills" ;;
        cursor) skills_dir=".cursor/skills" ;;
        windsurf) skills_dir=".windsurf/skills" ;;
        aider) skills_dir=".aider/skills" ;;
        continue) skills_dir=".continue/skills" ;;
        hermes) skills_dir=".hermes/skills" ;;
    esac
    
    if [ -d "$skills_dir" ]; then
        find "$skills_dir" -name "SKILL.md" -type f 2>/dev/null | wc -l | tr -d ' '
    else
        echo "0"
    fi
}

# Count total available skills
count_available_skills() {
    find "$NEW_SKILLS_DIR" -name "SKILL.md" -type f 2>/dev/null | wc -l | tr -d ' '
}

# Show menu
show_menu() {
    local total_skills
    total_skills=$(count_available_skills)
    
    echo -e "${BOLD}${CYAN}  📦 Available Agents:${NC}"
    echo -e "${CYAN}  ─────────────────────────────────────────────────────────────${NC}"
    echo ""
    
    # Claude Code
    local claude_status=$(check_agent "claude")
    local claude_count=$(count_installed_skills "claude")
    if [ "$claude_status" = "installed" ]; then
        echo -e "    ${GREEN}1)${NC} Claude Code          ${GREEN}(Installed)${NC} ${YELLOW}[$claude_count/$total_skills skills]${NC}"
    else
        echo -e "    ${BLUE}1)${NC} Claude Code          ${RED}(Not Installed)${NC}"
    fi
    
    # Cursor AI
    local cursor_status=$(check_agent "cursor")
    local cursor_count=$(count_installed_skills "cursor")
    if [ "$cursor_status" = "installed" ]; then
        echo -e "    ${GREEN}2)${NC} Cursor AI            ${GREEN}(Installed)${NC} ${YELLOW}[$cursor_count/$total_skills skills]${NC}"
    else
        echo -e "    ${BLUE}2)${NC} Cursor AI            ${RED}(Not Installed)${NC}"
    fi
    
    # Windsurf
    local windsurf_status=$(check_agent "windsurf")
    local windsurf_count=$(count_installed_skills "windsurf")
    if [ "$windsurf_status" = "installed" ]; then
        echo -e "    ${GREEN}3)${NC} Windsurf             ${GREEN}(Installed)${NC} ${YELLOW}[$windsurf_count/$total_skills skills]${NC}"
    else
        echo -e "    ${BLUE}3)${NC} Windsurf             ${RED}(Not Installed)${NC}"
    fi
    
    # Aider
    local aider_status=$(check_agent "aider")
    local aider_count=$(count_installed_skills "aider")
    if [ "$aider_status" = "installed" ]; then
        echo -e "    ${GREEN}4)${NC} Aider                ${GREEN}(Installed)${NC} ${YELLOW}[$aider_count/$total_skills skills]${NC}"
    else
        echo -e "    ${BLUE}4)${NC} Aider                ${RED}(Not Installed)${NC}"
    fi
    
    # Continue.dev
    local continue_status=$(check_agent "continue")
    local continue_count=$(count_installed_skills "continue")
    if [ "$continue_status" = "installed" ]; then
        echo -e "    ${GREEN}5)${NC} Continue.dev         ${GREEN}(Installed)${NC} ${YELLOW}[$continue_count/$total_skills skills]${NC}"
    else
        echo -e "    ${BLUE}5)${NC} Continue.dev         ${RED}(Not Installed)${NC}"
    fi
    
    # Hermes Agent
    local hermes_status=$(check_agent "hermes")
    local hermes_count=$(count_installed_skills "hermes")
    if [ "$hermes_status" = "installed" ]; then
        echo -e "    ${GREEN}6)${NC} Hermes Agent         ${GREEN}(Installed)${NC} ${YELLOW}[$hermes_count/$total_skills skills]${NC}"
    else
        echo -e "    ${BLUE}6)${NC} Hermes Agent         ${RED}(Not Installed)${NC}"
    fi
    
    # Install All
    echo ""
    echo -e "${CYAN}  ─────────────────────────────────────────────────────────────${NC}"
    echo -e "    ${MAGENTA}7)${NC} ${BOLD}Install ALL Agents${NC}"
    echo -e "    ${MAGENTA}8)${NC} ${BOLD}Update/Reinstall ALL${NC}"
    echo -e "    ${RED}0)${NC} Exit"
    echo ""
    echo -e "${CYAN}  ─────────────────────────────────────────────────────────────${NC}"
    echo -e "    ${BLUE}Total Skills: ${BOLD}$total_skills${NC}"
    echo ""
}

# Copy all skills to target
copy_all_skills() {
    local target="$1"
    
    # Create directory structure
    mkdir -p "$target"
    
    # Copy all categories
    for category in core coding quality architecture git devops security performance ai documentation; do
        if [ -d "$NEW_SKILLS_DIR/$category" ]; then
            cp -r "$NEW_SKILLS_DIR/$category" "$target/" 2>/dev/null || true
        fi
    done
    
    # Copy management files
    cp "$NEW_SKILLS_DIR/ROUTER.md" "$target/" 2>/dev/null || true
    cp "$NEW_SKILLS_DIR/AGENT.md" "$target/" 2>/dev/null || true
    cp "$NEW_SKILLS_DIR/SKILL-MATRIX.md" "$target/" 2>/dev/null || true
}

# Install for Claude Code
install_claude() {
    local target="${1:-.}"
    echo ""
    echo -e "${CYAN}  📦 Installing for Claude Code...${NC}"
    echo ""
    
    # Create .claude directory
    mkdir -p "$target/.claude"
    
    # Copy all skills
    copy_all_skills "$target/.claude/skills"
    
    # Create CLAUDE.md
    cat > "$target/CLAUDE.md" << 'EOF'
# CLAUDE.md

## 🧠 Skills

This project uses skills from the Coding Agent Skill Library.
When performing tasks, read the relevant skill file from `.claude/skills/` first.

### Core Principles
1. **Evidence First** — Never guess. Always verify.
2. **Minimal Fix** — Smallest change that fixes root cause.
3. **Verification Required** — Never claim success without proof.

### Quick Reference
| Task | Skill |
|------|-------|
| Analyze project | `skills/core/project-analysis/SKILL.md` |
| Plan work | `skills/core/task-planning/SKILL.md` |
| Write code | `skills/coding/code-generation/SKILL.md` |
| Fix bugs | `skills/coding/debugging/SKILL.md` |
| Review code | `skills/quality/code-review/SKILL.md` |
| Write tests | `skills/quality/testing/SKILL.md` |
| Verify changes | `skills/quality/verification/SKILL.md` |

### Routing
See `skills/ROUTER.md` for skill routing logic.
See `skills/AGENT.md` for agent rules.
EOF
    
    local count=$(find "$target/.claude/skills" -name "SKILL.md" -type f | wc -l | tr -d ' ')
    print_success "Installed $count skills for Claude Code"
    print_info "Location: $target/.claude/skills/"
    print_info "Config: $target/CLAUDE.md"
}

# Install for Cursor
install_cursor() {
    local target="${1:-.}"
    echo ""
    echo -e "${CYAN}  📦 Installing for Cursor AI...${NC}"
    echo ""
    
    # Create .cursor directory
    mkdir -p "$target/.cursor"
    
    # Copy all skills
    copy_all_skills "$target/.cursor/skills"
    
    # Create .cursorrules
    cat > "$target/.cursorrules" << 'EOF'
# Cursor Rules

## 🧠 Skills

Read the relevant skill file from `.cursor/skills/` before performing tasks.

### Core Principles
1. **Evidence First** — Never guess. Always verify.
2. **Minimal Fix** — Smallest change that fixes root cause.
3. **Verification Required** — Never claim success without proof.

### Quick Reference
| Task | Skill |
|------|-------|
| Analyze project | `skills/core/project-analysis/SKILL.md` |
| Plan work | `skills/core/task-planning/SKILL.md` |
| Write code | `skills/coding/code-generation/SKILL.md` |
| Fix bugs | `skills/coding/debugging/SKILL.md` |
| Review code | `skills/quality/code-review/SKILL.md` |
| Write tests | `skills/quality/testing/SKILL.md` |
| Verify changes | `skills/quality/verification/SKILL.md` |

### Routing
See `skills/ROUTER.md` for skill routing logic.
EOF
    
    local count=$(find "$target/.cursor/skills" -name "SKILL.md" -type f | wc -l | tr -d ' ')
    print_success "Installed $count skills for Cursor AI"
    print_info "Location: $target/.cursor/skills/"
    print_info "Config: $target/.cursorrules"
}

# Install for Windsurf
install_windsurf() {
    local target="${1:-.}"
    echo ""
    echo -e "${CYAN}  📦 Installing for Windsurf...${NC}"
    echo ""
    
    mkdir -p "$target/.windsurf"
    copy_all_skills "$target/.windsurf/skills"
    
    cat > "$target/.windsurfrules" << 'EOF'
# Windsurf Rules

## 🧠 Skills

Read the relevant skill file from `.windsurf/skills/` before performing tasks.

### Core Principles
1. **Evidence First** — Never guess. Always verify.
2. **Minimal Fix** — Smallest change that fixes root cause.
3. **Verification Required** — Never claim success without proof.
EOF
    
    local count=$(find "$target/.windsurf/skills" -name "SKILL.md" -type f | wc -l | tr -d ' ')
    print_success "Installed $count skills for Windsurf"
    print_info "Location: $target/.windsurf/skills/"
}

# Install for Aider
install_aider() {
    local target="${1:-.}"
    echo ""
    echo -e "${CYAN}  📦 Installing for Aider...${NC}"
    echo ""
    
    mkdir -p "$target/.aider"
    copy_all_skills "$target/.aider/skills"
    
    cat > "$target/.aider.conf.yml" << 'EOF'
# Aider Configuration

## Skills
# Skills are in .aider/skills/ directory
# Read the relevant SKILL.md before performing tasks
EOF
    
    local count=$(find "$target/.aider/skills" -name "SKILL.md" -type f | wc -l | tr -d ' ')
    print_success "Installed $count skills for Aider"
    print_info "Location: $target/.aider/skills/"
}

# Install for Continue.dev
install_continue() {
    local target="${1:-.}"
    echo ""
    echo -e "${CYAN}  📦 Installing for Continue.dev...${NC}"
    echo ""
    
    mkdir -p "$target/.continue"
    copy_all_skills "$target/.continue/skills"
    
    local count=$(find "$target/.continue/skills" -name "SKILL.md" -type f | wc -l | tr -d ' ')
    print_success "Installed $count skills for Continue.dev"
    print_info "Location: $target/.continue/skills/"
}

# Install for Hermes
install_hermes() {
    local target="${1:-.}"
    echo ""
    echo -e "${CYAN}  📦 Installing for Hermes Agent...${NC}"
    echo ""
    
    mkdir -p "$target/.hermes"
    copy_all_skills "$target/.hermes/skills"
    
    cat > "$target/.hermes/config.yaml" << 'EOF'
# Hermes Skills Configuration

skills:
  path: .hermes/skills
  auto_load: true
  triggers: true
EOF
    
    local count=$(find "$target/.hermes/skills" -name "SKILL.md" -type f | wc -l | tr -d ' ')
    print_success "Installed $count skills for Hermes Agent"
    print_info "Location: $target/.hermes/skills/"
}

# Install all agents
install_all() {
    local target="${1:-.}"
    install_claude "$target"
    install_cursor "$target"
    install_windsurf "$target"
    install_aider "$target"
    install_continue "$target"
    install_hermes "$target"
}

# Main
main() {
    local total_skills
    total_skills=$(count_available_skills)
    
    while true; do
        print_banner
        show_menu
        
        read -p "  🔢 Select option (0-8): " choice
        echo ""
        
        case "$choice" in
            1)
                install_claude "."
                ;;
            2)
                install_cursor "."
                ;;
            3)
                install_windsurf "."
                ;;
            4)
                install_aider "."
                ;;
            5)
                install_continue "."
                ;;
            6)
                install_hermes "."
                ;;
            7)
                echo -e "${CYAN}  📦 Installing for ALL agents...${NC}"
                install_all "."
                ;;
            8)
                echo -e "${YELLOW}  🔄 Reinstalling ALL agents...${NC}"
                install_all "."
                ;;
            0)
                echo ""
                echo -e "${GREEN}  👋 Goodbye!${NC}"
                echo ""
                exit 0
                ;;
            *)
                echo -e "${RED}  ❌ Invalid option. Please try again.${NC}"
                ;;
        esac
        
        echo ""
        read -p "  ⏎ Press Enter to continue..."
    done
}

main "$@"
