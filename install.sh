#!/bin/bash

# 🧠 Coding Agent Skill Library Installer
# Interactive installer with install/uninstall/update

set -e

SKILLS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# Skills live in categorized dirs at the repo root: ai/ coding/ quality/ ...
NEW_SKILLS_DIR="$SKILLS_DIR"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m'
BOLD='\033[1m'

# Selected agents
declare -A SELECTED

print_banner() {
    clear
    echo -e "${CYAN}"
    echo "╔══════════════════════════════════════════════════════════════════╗"
    echo "║                                                                ║"
    echo "║           🧠 Coding Agent Skill Library - v5.0.0              ║"
    echo "║                                                                ║"
    echo "║           57 Professional Skills for Coding Agents             ║"
    echo "║           Evidence First • Minimal Fix • Verification          ║"
    echo "║                                                                ║"
    echo "╚══════════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

print_success() { echo -e "${GREEN}  ✅ $1${NC}"; }
print_info() { echo -e "${BLUE}  ℹ️  $1${NC}"; }
print_warning() { echo -e "${YELLOW}  ⚠️  $1${NC}"; }
print_error() { echo -e "${RED}  ❌ $1${NC}"; }

# Check if agent is installed
check_agent() {
    local agent="$1"
    case "$agent" in
        claude)
            [ -f "CLAUDE.md" ] && [ -d ".claude/skills" ] && echo "installed" || echo "not_installed"
            ;;
        cursor)
            [ -f ".cursorrules" ] && [ -d ".cursor/skills" ] && echo "installed" || echo "not_installed"
            ;;
        windsurf)
            [ -f ".windsurfrules" ] && [ -d ".windsurf/skills" ] && echo "installed" || echo "not_installed"
            ;;
        aider)
            [ -f ".aider.conf.yml" ] && [ -d ".aider/skills" ] && echo "installed" || echo "not_installed"
            ;;
        continue)
            [ -d ".continue/skills" ] && echo "installed" || echo "not_installed"
            ;;
        hermes)
            [ -d ".hermes/skills" ] && echo "installed" || echo "not_installed"
            ;;
        *) echo "unknown" ;;
    esac
}

# Count installed skills
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
    [ -d "$skills_dir" ] && find "$skills_dir" -name "SKILL.md" -type f 2>/dev/null | wc -l | tr -d ' ' || echo "0"
}

# Count available skills (exclude v2/ reference pack and hidden dirs)
count_available_skills() {
    find "$NEW_SKILLS_DIR" -path "$NEW_SKILLS_DIR/v2" -prune -o -name "SKILL.md" -type f -print 2>/dev/null | wc -l | tr -d ' '
}

# Show menu with selection status
show_menu() {
    local total_skills
    total_skills=$(count_available_skills)
    
    echo -e "${BOLD}${CYAN}  📦 Available Agents:${NC}"
    echo -e "${CYAN}  ─────────────────────────────────────────────────────────────${NC}"
    echo ""
    
    local agents=("claude:Claude Code" "cursor:Cursor AI" "windsurf:Windsurf" "aider:Aider" "continue:Continue.dev" "hermes:Hermes Agent")
    local i=1
    
    for agent_info in "${agents[@]}"; do
        local agent="${agent_info%%:*}"
        local name="${agent_info##*:}"
        local status=$(check_agent "$agent")
        local count=$(count_installed_skills "$agent")
        local selected="${SELECTED[$agent]:-0}"
        
        # Selection indicator
        local sel_mark=""
        if [ "$selected" = "1" ]; then
            sel_mark="${GREEN}[✓]${NC} "
        else
            sel_mark="${RED}[ ]${NC} "
        fi
        
        # Installation status
        local inst_mark=""
        if [ "$status" = "installed" ]; then
            inst_mark="${GREEN}(Installed)${NC} ${YELLOW}[$count/$total_skills skills]${NC}"
        else
            inst_mark="${RED}(Not Installed)${NC}"
        fi
        
        echo -e "    ${sel_mark}${BLUE}$i)${NC} $name          $inst_mark"
        ((i++))
    done
    
    echo ""
    echo -e "${CYAN}  ─────────────────────────────────────────────────────────────${NC}"
    echo -e "    ${MAGENTA}7)${NC} ${BOLD}Select All${NC}"
    echo -e "    ${MAGENTA}8)${NC} ${BOLD}Deselect All${NC}"
    echo ""
    echo -e "${CYAN}  ─────────────────────────────────────────────────────────────${NC}"
    echo -e "    ${GREEN}9)${NC} ${BOLD}Install Selected${NC}"
    echo -e "    ${YELLOW}10)${NC} ${BOLD}Update Selected${NC} ${CYAN}(reinstall with latest)${NC}"
    echo -e "    ${RED}11)${NC} ${BOLD}Uninstall Selected${NC}"
    echo -e "    ${RED}0)${NC} Exit"
    echo ""
    echo -e "${CYAN}  ─────────────────────────────────────────────────────────────${NC}"
    
    # Show selected count
    local selected_count=0
    for agent_info in "${agents[@]}"; do
        local agent="${agent_info%%:*}"
        [ "${SELECTED[$agent]:-0}" = "1" ] && ((selected_count++))
    done
    
    if [ $selected_count -gt 0 ]; then
        echo -e "    ${GREEN}Selected: $selected_count agent(s)${NC}"
    else
        echo -e "    ${YELLOW}No agents selected${NC}"
    fi
    
    echo -e "    ${BLUE}Total Skills: ${BOLD}$total_skills${NC}"
    echo ""
}

# Toggle selection
toggle_selection() {
    local agent="$1"
    if [ "${SELECTED[$agent]:-0}" = "1" ]; then
        SELECTED[$agent]=0
    else
        SELECTED[$agent]=1
    fi
}

# Select all
select_all() {
    SELECTED[claude]=1
    SELECTED[cursor]=1
    SELECTED[windsurf]=1
    SELECTED[aider]=1
    SELECTED[continue]=1
    SELECTED[hermes]=1
}

# Deselect all
deselect_all() {
    SELECTED[claude]=0
    SELECTED[cursor]=0
    SELECTED[windsurf]=0
    SELECTED[aider]=0
    SELECTED[continue]=0
    SELECTED[hermes]=0
}

# Copy all skills to target
copy_all_skills() {
    local target="$1"
    mkdir -p "$target"
    for category in core coding quality architecture git devops security performance ai documentation; do
        [ -d "$NEW_SKILLS_DIR/$category" ] && cp -r "$NEW_SKILLS_DIR/$category" "$target/" 2>/dev/null || true
    done
    cp "$NEW_SKILLS_DIR/ROUTER.md" "$target/" 2>/dev/null || true
    cp "$NEW_SKILLS_DIR/AGENT.md" "$target/" 2>/dev/null || true
    cp "$NEW_SKILLS_DIR/SKILL-MATRIX.md" "$target/" 2>/dev/null || true
}

# ===== INSTALL FUNCTIONS =====

install_claude() {
    local target="${1:-.}"
    echo ""
    echo -e "${CYAN}  📦 Installing for Claude Code...${NC}"
    mkdir -p "$target/.claude"
    copy_all_skills "$target/.claude/skills"
    
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
EOF
    
    local count=$(find "$target/.claude/skills" -name "SKILL.md" -type f | wc -l | tr -d ' ')
    print_success "Installed $count skills for Claude Code"
}

install_cursor() {
    local target="${1:-.}"
    echo ""
    echo -e "${CYAN}  📦 Installing for Cursor AI...${NC}"
    mkdir -p "$target/.cursor"
    copy_all_skills "$target/.cursor/skills"
    
    cat > "$target/.cursorrules" << 'EOF'
# Cursor Rules

## 🧠 Skills

Read the relevant skill file from `.cursor/skills/` before performing tasks.

### Core Principles
1. **Evidence First** — Never guess. Always verify.
2. **Minimal Fix** — Smallest change that fixes root cause.
3. **Verification Required** — Never claim success without proof.
EOF
    
    local count=$(find "$target/.cursor/skills" -name "SKILL.md" -type f | wc -l | tr -d ' ')
    print_success "Installed $count skills for Cursor AI"
}

install_windsurf() {
    local target="${1:-.}"
    echo ""
    echo -e "${CYAN}  📦 Installing for Windsurf...${NC}"
    mkdir -p "$target/.windsurf"
    copy_all_skills "$target/.windsurf/skills"
    
    cat > "$target/.windsurfrules" << 'EOF'
# Windsurf Rules

## 🧠 Skills

Read the relevant skill file from `.windsurf/skills/` before performing tasks.
EOF
    
    local count=$(find "$target/.windsurf/skills" -name "SKILL.md" -type f | wc -l | tr -d ' ')
    print_success "Installed $count skills for Windsurf"
}

install_aider() {
    local target="${1:-.}"
    echo ""
    echo -e "${CYAN}  📦 Installing for Aider...${NC}"
    mkdir -p "$target/.aider"
    copy_all_skills "$target/.aider/skills"
    
    cat > "$target/.aider.conf.yml" << 'EOF'
# Aider Configuration
# Skills are in .aider/skills/ directory
EOF
    
    local count=$(find "$target/.aider/skills" -name "SKILL.md" -type f | wc -l | tr -d ' ')
    print_success "Installed $count skills for Aider"
}

install_continue() {
    local target="${1:-.}"
    echo ""
    echo -e "${CYAN}  📦 Installing for Continue.dev...${NC}"
    mkdir -p "$target/.continue"
    copy_all_skills "$target/.continue/skills"
    
    local count=$(find "$target/.continue/skills" -name "SKILL.md" -type f | wc -l | tr -d ' ')
    print_success "Installed $count skills for Continue.dev"
}

install_hermes() {
    local target="${1:-.}"
    echo ""
    echo -e "${CYAN}  📦 Installing for Hermes Agent...${NC}"
    mkdir -p "$target/.hermes"
    copy_all_skills "$target/.hermes/skills"
    
    cat > "$target/.hermes/config.yaml" << 'EOF'
skills:
  path: .hermes/skills
  auto_load: true
  triggers: true
EOF
    
    local count=$(find "$target/.hermes/skills" -name "SKILL.md" -type f | wc -l | tr -d ' ')
    print_success "Installed $count skills for Hermes Agent"
}

# ===== UNINSTALL FUNCTIONS =====

uninstall_claude() {
    local target="${1:-.}"
    echo ""
    echo -e "${RED}  🗑️  Uninstalling Claude Code...${NC}"
    
    if [ -d "$target/.claude" ]; then
        rm -rf "$target/.claude"
        print_success "Removed .claude directory"
    fi
    
    if [ -f "$target/CLAUDE.md" ]; then
        rm -f "$target/CLAUDE.md"
        print_success "Removed CLAUDE.md"
    fi
    
    print_success "Claude Code uninstalled"
}

uninstall_cursor() {
    local target="${1:-.}"
    echo ""
    echo -e "${RED}  🗑️  Uninstalling Cursor AI...${NC}"
    
    if [ -d "$target/.cursor" ]; then
        rm -rf "$target/.cursor"
        print_success "Removed .cursor directory"
    fi
    
    if [ -f "$target/.cursorrules" ]; then
        rm -f "$target/.cursorrules"
        print_success "Removed .cursorrules"
    fi
    
    print_success "Cursor AI uninstalled"
}

uninstall_windsurf() {
    local target="${1:-.}"
    echo ""
    echo -e "${RED}  🗑️  Uninstalling Windsurf...${NC}"
    
    if [ -d "$target/.windsurf" ]; then
        rm -rf "$target/.windsurf"
        print_success "Removed .windsurf directory"
    fi
    
    if [ -f "$target/.windsurfrules" ]; then
        rm -f "$target/.windsurfrules"
        print_success "Removed .windsurfrules"
    fi
    
    print_success "Windsurf uninstalled"
}

uninstall_aider() {
    local target="${1:-.}"
    echo ""
    echo -e "${RED}  🗑️  Uninstalling Aider...${NC}"
    
    if [ -d "$target/.aider" ]; then
        rm -rf "$target/.aider"
        print_success "Removed .aider directory"
    fi
    
    if [ -f "$target/.aider.conf.yml" ]; then
        rm -f "$target/.aider.conf.yml"
        print_success "Removed .aider.conf.yml"
    fi
    
    print_success "Aider uninstalled"
}

uninstall_continue() {
    local target="${1:-.}"
    echo ""
    echo -e "${RED}  🗑️  Uninstalling Continue.dev...${NC}"
    
    if [ -d "$target/.continue" ]; then
        rm -rf "$target/.continue"
        print_success "Removed .continue directory"
    fi
    
    print_success "Continue.dev uninstalled"
}

uninstall_hermes() {
    local target="${1:-.}"
    echo ""
    echo -e "${RED}  🗑️  Uninstalling Hermes Agent...${NC}"
    
    if [ -d "$target/.hermes" ]; then
        rm -rf "$target/.hermes"
        print_success "Removed .hermes directory"
    fi
    
    print_success "Hermes Agent uninstalled"
}

# ===== ACTION FUNCTIONS =====

install_selected() {
    local installed=0
    
    [ "${SELECTED[claude]:-0}" = "1" ] && install_claude "." && ((installed++))
    [ "${SELECTED[cursor]:-0}" = "1" ] && install_cursor "." && ((installed++))
    [ "${SELECTED[windsurf]:-0}" = "1" ] && install_windsurf "." && ((installed++))
    [ "${SELECTED[aider]:-0}" = "1" ] && install_aider "." && ((installed++))
    [ "${SELECTED[continue]:-0}" = "1" ] && install_continue "." && ((installed++))
    [ "${SELECTED[hermes]:-0}" = "1" ] && install_hermes "." && ((installed++))
    
    echo ""
    if [ $installed -gt 0 ]; then
        print_success "Successfully installed $installed agent(s)"
    else
        print_warning "No agents selected for installation"
    fi
}

update_selected() {
    local updated=0
    
    [ "${SELECTED[claude]:-0}" = "1" ] && install_claude "." && ((updated++))
    [ "${SELECTED[cursor]:-0}" = "1" ] && install_cursor "." && ((updated++))
    [ "${SELECTED[windsurf]:-0}" = "1" ] && install_windsurf "." && ((updated++))
    [ "${SELECTED[aider]:-0}" = "1" ] && install_aider "." && ((updated++))
    [ "${SELECTED[continue]:-0}" = "1" ] && install_continue "." && ((updated++))
    [ "${SELECTED[hermes]:-0}" = "1" ] && install_hermes "." && ((updated++))
    
    echo ""
    if [ $updated -gt 0 ]; then
        print_success "Successfully updated $updated agent(s)"
    else
        print_warning "No agents selected for update"
    fi
}

uninstall_selected() {
    local uninstalled=0
    
    [ "${SELECTED[claude]:-0}" = "1" ] && uninstall_claude "." && ((uninstalled++))
    [ "${SELECTED[cursor]:-0}" = "1" ] && uninstall_cursor "." && ((uninstalled++))
    [ "${SELECTED[windsurf]:-0}" = "1" ] && uninstall_windsurf "." && ((uninstalled++))
    [ "${SELECTED[aider]:-0}" = "1" ] && uninstall_aider "." && ((uninstalled++))
    [ "${SELECTED[continue]:-0}" = "1" ] && uninstall_continue "." && ((uninstalled++))
    [ "${SELECTED[hermes]:-0}" = "1" ] && uninstall_hermes "." && ((uninstalled++))
    
    echo ""
    if [ $uninstalled -gt 0 ]; then
        print_success "Successfully uninstalled $uninstalled agent(s)"
    else
        print_warning "No agents selected for uninstallation"
    fi
}

# Parse command line arguments
parse_args() {
    while [ $# -gt 0 ]; do
        case "$1" in
            --claude) SELECTED[claude]=1; shift ;;
            --cursor) SELECTED[cursor]=1; shift ;;
            --windsurf) SELECTED[windsurf]=1; shift ;;
            --aider) SELECTED[aider]=1; shift ;;
            --continue) SELECTED[continue]=1; shift ;;
            --hermes) SELECTED[hermes]=1; shift ;;
            --all) select_all; shift ;;
            --uninstall)
                # Parse next args as uninstall targets
                shift
                while [ $# -gt 0 ] && [[ ! "$1" =~ ^-- ]]; do
                    case "$1" in
                        claude) SELECTED[claude]=1 ;;
                        cursor) SELECTED[cursor]=1 ;;
                        windsurf) SELECTED[windsurf]=1 ;;
                        aider) SELECTED[aider]=1 ;;
                        continue) SELECTED[continue]=1 ;;
                        hermes) SELECTED[hermes]=1 ;;
                        all) select_all ;;
                        *) print_error "Unknown agent: $1"; exit 1 ;;
                    esac
                    shift
                done
                uninstall_selected
                exit 0
                ;;
            --update)
                shift
                while [ $# -gt 0 ] && [[ ! "$1" =~ ^-- ]]; do
                    case "$1" in
                        claude) SELECTED[claude]=1 ;;
                        cursor) SELECTED[cursor]=1 ;;
                        windsurf) SELECTED[windsurf]=1 ;;
                        aider) SELECTED[aider]=1 ;;
                        continue) SELECTED[continue]=1 ;;
                        hermes) SELECTED[hermes]=1 ;;
                        all) select_all ;;
                        *) print_error "Unknown agent: $1"; exit 1 ;;
                    esac
                    shift
                done
                update_selected
                exit 0
                ;;
            --help|-h)
                echo "Usage: ./install.sh [OPTIONS]"
                echo ""
                echo "Install Options:"
                echo "  --claude              Install for Claude Code"
                echo "  --cursor              Install for Cursor AI"
                echo "  --windsurf            Install for Windsurf"
                echo "  --aider               Install for Aider"
                echo "  --continue            Install for Continue.dev"
                echo "  --hermes              Install for Hermes Agent"
                echo "  --all                 Install for all agents"
                echo ""
                echo "Uninstall Options:"
                echo "  --uninstall claude    Uninstall Claude Code"
                echo "  --uninstall cursor    Uninstall Cursor AI"
                echo "  --uninstall all       Uninstall all agents"
                echo ""
                echo "Update Options:"
                echo "  --update claude       Update Claude Code"
                echo "  --update all          Update all agents"
                echo ""
                echo "Interactive Mode (no arguments):"
                echo "  ./install.sh          Start interactive menu"
                exit 0
                ;;
            *) print_error "Unknown option: $1"; exit 1 ;;
        esac
    done
}

# Main
main() {
    # If arguments provided, use non-interactive mode
    if [ $# -gt 0 ]; then
        parse_args "$@"
        install_selected
        exit 0
    fi
    
    # Interactive mode
    while true; do
        print_banner
        show_menu
        
        read -p "  🔢 Enter command (1-11, 0): " choice
        echo ""
        
        case "$choice" in
            [1-6])
                # Get agent name from choice
                local agents=("claude" "cursor" "windsurf" "aider" "continue" "hermes")
                local idx=$((choice - 1))
                local agent="${agents[$idx]}"
                toggle_selection "$agent"
                ;;
            7)
                select_all
                echo -e "${GREEN}  ✓ All agents selected${NC}"
                sleep 1
                ;;
            8)
                deselect_all
                echo -e "${YELLOW}  ✓ All deselected${NC}"
                sleep 1
                ;;
            9)
                install_selected
                ;;
            10)
                update_selected
                ;;
            11)
                # Confirm uninstall
                echo -e "${RED}  ⚠️  WARNING: This will remove selected agents!${NC}"
                read -p "  Are you sure? (y/N): " confirm
                if [ "$confirm" = "y" ] || [ "$confirm" = "Y" ]; then
                    uninstall_selected
                else
                    echo -e "${YELLOW}  Cancelled${NC}"
                fi
                ;;
            0)
                echo ""
                echo -e "${GREEN}  👋 Goodbye!${NC}"
                echo ""
                exit 0
                ;;
            *)
                echo -e "${RED}  ❌ Invalid option${NC}"
                sleep 1
                ;;
        esac
        
        echo ""
        read -p "  ⏎ Press Enter to continue..."
    done
}

main "$@"
