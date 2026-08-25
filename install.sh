#!/bin/bash

# 🧠 Skills Installer
# One-command installation for AI agent skills
# Usage: ./install.sh [agent]

set -e

SKILLS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPT_NAME="skills-installer"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

print_banner() {
    echo -e "${CYAN}"
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║          🧠 Skills Installer - AI Agent Skills Library      ║"
    echo "║                                                            ║"
    echo "║   49 production-ready skills for your AI agents            ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

# Count skills
count_skills() {
    local count=$(find "$SKILLS_DIR" -name "SKILL.md" -type f | wc -l)
    echo "$count"
}

# Install for Claude Code
install_claude() {
    echo -e "\n${CYAN}📦 Installing for Claude Code...${NC}\n"
    
    local target_dir="${1:-.}"
    local claude_dir="$target_dir/.claude"
    local skills_target="$claude_dir/skills"
    
    # Create directories
    mkdir -p "$claude_dir"
    mkdir -p "$skills_target"
    
    # Copy all skills
    cp -r "$SKILLS_DIR"/*/SKILL.md "$skills_target/" 2>/dev/null || true
    cp -r "$SKILLS_DIR"/*/references "$skills_target/" 2>/dev/null || true
    
    # Create or update CLAUDE.md
    if [ -f "$target_dir/CLAUDE.md" ]; then
        print_warning "CLAUDE.md already exists. Appending skills section..."
        cat >> "$target_dir/CLAUDE.md" << 'EOF'

---

## 🧠 Skills Reference

This project uses skills from the Skills Collection.
When performing tasks, check the skills directory for relevant instructions.

Available skills are in `.claude/skills/` directory.
Read the relevant SKILL.md before starting any task.
EOF
    else
        cat > "$target_dir/CLAUDE.md" << 'EOF'
# CLAUDE.md

## 🧠 Skills Reference

This project uses skills from the Skills Collection.
When performing tasks, check the skills directory for relevant instructions.

Available skills are in `.claude/skills/` directory.
Read the relevant SKILL.md before starting any task.

### Quick Reference
- `skills/debug/SKILL.md` — For debugging any code issue
- `skills/code-review/SKILL.md` — For reviewing code quality
- `skills/system-design/SKILL.md` — For architecture decisions
- `skills/security-audit/SKILL.md` — For security reviews
EOF
    fi
    
    local count=$(count_skills)
    print_success "Installed $count skills for Claude Code"
    print_info "Skills location: $skills_target"
    print_info "Config: $target_dir/CLAUDE.md"
}

# Install for Cursor
install_cursor() {
    echo -e "\n${CYAN}📦 Installing for Cursor AI...${NC}\n"
    
    local target_dir="${1:-.}"
    local cursor_file="$target_dir/.cursorrules"
    
    # Copy skills
    mkdir -p "$target_dir/.cursor/skills"
    cp -r "$SKILLS_DIR"/*/SKILL.md "$target_dir/.cursor/skills/" 2>/dev/null || true
    
    # Create or update .cursorrules
    if [ -f "$cursor_file" ]; then
        print_warning ".cursorrules already exists. Appending skills section..."
        cat >> "$cursor_file" << 'EOF'

---

## Skills Reference

When performing tasks, read the relevant skill file from `.cursor/skills/` directory.
EOF
    else
        cat > "$cursor_file" << 'EOF'
# Cursor Rules

## Skills Reference

When performing tasks, read the relevant skill file from `.cursor/skills/` directory.

Available skills: debug, code-review, refactor, test-generation, system-design, and 44 more.
EOF
    fi
    
    local count=$(count_skills)
    print_success "Installed $count skills for Cursor AI"
}

# Install for Windsurf
install_windsurf() {
    echo -e "\n${CYAN}📦 Installing for Windsurf...${NC}\n"
    
    local target_dir="${1:-.}"
    local windsurf_file="$target_dir/.windsurfrules"
    
    # Copy skills
    mkdir -p "$target_dir/.windsurf/skills"
    cp -r "$SKILLS_DIR"/*/SKILL.md "$target_dir/.windsurf/skills/" 2>/dev/null || true
    
    # Create .windsurfrules
    if [ -f "$windsurf_file" ]; then
        print_warning ".windsurfrules already exists. Appending skills section..."
        cat >> "$windsurf_file" << 'EOF'

---

## Skills Reference

When performing tasks, read the relevant skill file from `.windsurf/skills/` directory.
EOF
    else
        cat > "$windsurf_file" << 'EOF'
# Windsurf Rules

## Skills Reference

When performing tasks, read the relevant skill file from `.windsurf/skills/` directory.

Available skills: debug, code-review, refactor, test-generation, system-design, and 44 more.
EOF
    fi
    
    local count=$(count_skills)
    print_success "Installed $count skills for Windsurf"
}

# Install for Continue.dev
install_continue() {
    echo -e "\n${CYAN}📦 Installing for Continue.dev...${NC}\n"
    
    local target_dir="${1:-.}"
    local continue_dir="$target_dir/.continue"
    
    # Copy skills
    mkdir -p "$continue_dir/skills"
    cp -r "$SKILLS_DIR"/*/SKILL.md "$continue_dir/skills/" 2>/dev/null || true
    
    local count=$(count_skills)
    print_success "Installed $count skills for Continue.dev"
    print_info "Skills location: $continue_dir/skills/"
}

# Install for Aider
install_aider() {
    echo -e "\n${CYAN}📦 Installing for Aider...${NC}\n"
    
    local target_dir="${1:-.}"
    local aider_file="$target_dir/.aider.conf.yml"
    
    # Copy skills
    mkdir -p "$target_dir/.aider/skills"
    cp -r "$SKILLS_DIR"/*/SKILL.md "$target_dir/.aider/skills/" 2>/dev/null || true
    
    # Create .aider.conf.yml
    if [ -f "$aider_file" ]; then
        print_warning ".aider.conf.yml already exists. Skipping..."
    else
        cat > "$aider_file" << 'EOF'
# Aider Configuration

# Skills are in .aider/skills/ directory
# Read the relevant SKILL.md before performing tasks
EOF
    fi
    
    local count=$(count_skills)
    print_success "Installed $count skills for Aider"
}

# Install for Hermes
install_hermes() {
    echo -e "\n${CYAN}📦 Installing for Hermes Agent...${NC}\n"
    
    local target_dir="${1:-.}"
    local hermes_dir="$target_dir/.hermes"
    
    # Copy skills
    mkdir -p "$hermes_dir/skills"
    cp -r "$SKILLS_DIR"/*/SKILL.md "$hermes_dir/skills/" 2>/dev/null || true
    
    # Create hermes config
    cat > "$hermes_dir/config.yaml" << 'EOF'
# Hermes Skills Configuration

skills:
  path: .hermes/skills
  auto_load: true
  triggers: true
EOF
    
    local count=$(count_skills)
    print_success "Installed $count skills for Hermes Agent"
}

# Install for all agents
install_all() {
    echo -e "\n${CYAN}📦 Installing for all agents...${NC}\n"
    
    local target_dir="${1:-.}"
    
    install_claude "$target_dir"
    install_cursor "$target_dir"
    install_windsurf "$target_dir"
    install_continue "$target_dir"
    install_aider "$target_dir"
    install_hermes "$target_dir"
    
    echo -e "\n${GREEN}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}✅ All skills installed for all agents!${NC}"
    echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
}

# Show help
show_help() {
    echo -e "${CYAN}Usage:${NC}"
    echo "  ./install.sh [agent] [target-dir]"
    echo ""
    echo -e "${CYAN}Agents:${NC}"
    echo "  claude      Install for Claude Code"
    echo "  cursor      Install for Cursor AI"
    echo "  windsurf    Install for Windsurf"
    echo "  continue    Install for Continue.dev"
    echo "  aider       Install for Aider"
    echo "  hermes      Install for Hermes Agent"
    echo "  all         Install for all supported agents"
    echo ""
    echo -e "${CYAN}Examples:${NC}"
    echo "  ./install.sh claude              # Install in current directory"
    echo "  ./install.sh cursor /path/to     # Install in specific directory"
    echo "  ./install.sh all                 # Install for all agents"
    echo ""
    echo -e "${CYAN}Options:${NC}"
    echo "  -h, --help    Show this help message"
    echo "  -v, --version Show version"
}

# Main
main() {
    print_banner
    
    local agent="${1:-}"
    local target_dir="${2:-.}"
    
    case "$agent" in
        claude|claudocode)
            install_claude "$target_dir"
            ;;
        cursor|cursorai)
            install_cursor "$target_dir"
            ;;
        windsurf)
            install_windsurf "$target_dir"
            ;;
        continue|continuedev)
            install_continue "$target_dir"
            ;;
        aider)
            install_aider "$target_dir"
            ;;
        hermes|hermesagent)
            install_hermes "$target_dir"
            ;;
        all)
            install_all "$target_dir"
            ;;
        -h|--help)
            show_help
            ;;
        -v|--version)
            echo "Skills Installer v2.2.0"
            ;;
        "")
            # Auto-detect: install for current directory's likely agent
            print_info "No agent specified. Installing skills directory only..."
            
            mkdir -p "$target_dir/skills"
            cp -r "$SKILLS_DIR"/* "$target_dir/skills/"
            
            local count=$(count_skills)
            print_success "Copied $count skills to $target_dir/skills/"
            print_info "Run './install.sh [agent]' to configure for your agent"
            ;;
        *)
            print_error "Unknown agent: $agent"
            echo "Run './install.sh --help' for available options"
            exit 1
            ;;
    esac
    
    echo ""
    echo -e "${CYAN}📚 Skills Documentation:${NC}"
    echo "   https://github.com/AnishtayiN/skills#readme"
    echo ""
}

main "$@"
