#!/usr/bin/env bash
# Coding Agent Skill Library installer.
#
# Project-local, dependency-free (bash + coreutils + tar), and safe by construction:
#   * never overwrites an existing instruction or config file,
#   * removes only paths recorded in its own manifest,
#   * installs from a local checkout or by downloading a source tarball.
#
# One-liner install without cloning (this script fetches the library itself):
#   curl -fsSL https://raw.githubusercontent.com/AnishtayiN/skills/main/install.sh \
#     | bash -s -- --claude --target /path/to/project
#   bash <(curl -fsSL https://raw.githubusercontent.com/AnishtayiN/skills/main/install.sh) --claude
set -Eeuo pipefail

VERSION="6.0.0"
REPO="AnishtayiN/skills"
REF="main"
ARCHIVE_URL="${SKILLS_ARCHIVE_URL:-}"
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" >/dev/null 2>&1 && pwd)" || SCRIPT_DIR="$(pwd)"
SOURCE_DIR=""
TARGET="$(pwd)"
DRY_RUN=0
ACTION="install"
SELECTED=()
CREATED=()
SKILL_PATHS=()

C_RESET=$'\033[0m' C_BOLD=$'\033[1m' C_BLUE=$'\033[0;34m' C_CYAN=$'\033[0;36m'
C_GREEN=$'\033[0;32m' C_YELLOW=$'\033[1;33m' C_RED=$'\033[0;31m'

info() { printf '%s\n' "${C_BLUE}ℹ ${C_RESET}${*}"; }
ok()   { printf '%s\n' "${C_GREEN}✓ ${C_RESET}${*}"; }
warn() { printf '%s\n' "${C_YELLOW}! ${C_RESET}${*}" >&2; }
fail() { printf '%s\n' "${C_RED}✗ ${C_RESET}${*}" >&2; exit 1; }

usage() {
  cat <<'EOF'
Coding Agent Skill Library installer

Usage:
  install.sh [ACTION] [AGENTS...] [OPTIONS]

Actions (default: install):
  --install       Copy the managed skills into the selected agents
  --update        Same as --install; refreshes managed skills in place
  --uninstall     Remove only what this installer recorded in its manifest
  --check         Validate library metadata, the dependency graph, and this script
  --self-test     Install, update and uninstall into a throwaway target
  --list          Print every skill in the library with its path

Agents:
  --claude        .claude/skills/      + CLAUDE.md
  --cursor        .cursor/skills/      + .cursorrules and .cursor/rules/*.mdc
  --windsurf      .windsurf/skills/    + .windsurfrules
  --aider         .aider/skills/       + .aider.conf.yml with a `read:` entry
  --continue      .continue/skills/    + README explaining manual loading
  --hermes        .hermes/skills/      + .hermes/config.yaml
  --all           All six agents

Options:
  --target DIR      Project directory to install into (default: current dir)
  --source DIR      Use a local library checkout instead of downloading
  --ref REF         Git ref (branch, tag, or sha) to download; default: main
  --repo OWNER/NAME GitHub repository used to build the download URL
  --dry-run         Show what would happen without touching files
  --no-color        Disable ANSI colors
  -h, --help        Show this help

Examples:
  install.sh --claude
  install.sh --all --target ../my-project
  install.sh --update --claude
  install.sh --uninstall --cursor --target /work/app
  install.sh --ref <tag-or-sha> --source ~/src/skills --claude
  install.sh --check

Safety:
  Existing instruction and config files are always preserved. Uninstall reads the
  manifest under .agent-skills-manifests/ and deletes only the paths this installer
  created. Set SKILLS_ARCHIVE_URL to install from a mirror or an internal proxy.
EOF
}

no_color() { C_RESET='' C_BOLD='' C_BLUE='' C_CYAN='' C_GREEN='' C_YELLOW='' C_RED=''; }

all_agents=(claude cursor windsurf aider continue hermes)

agent_label() {
  case "$1" in
    claude)   printf 'Claude Code' ;;
    cursor)   printf 'Cursor' ;;
    windsurf) printf 'Windsurf' ;;
    aider)    printf 'Aider' ;;
    continue) printf 'Continue.dev' ;;
    hermes)   printf 'Hermes Agent' ;;
    *)        return 1 ;;
  esac
}

agent_skills_dir() {
  case "$1" in
    claude)   printf '%s' "$TARGET/.claude/skills" ;;
    cursor)   printf '%s' "$TARGET/.cursor/skills" ;;
    windsurf) printf '%s' "$TARGET/.windsurf/skills" ;;
    aider)    printf '%s' "$TARGET/.aider/skills" ;;
    continue) printf '%s' "$TARGET/.continue/skills" ;;
    hermes)   printf '%s' "$TARGET/.hermes/skills" ;;
    *)        return 1 ;;
  esac
}

agent_manifest() { printf '%s' "$TARGET/.agent-skills-manifests/$1.manifest"; }

# Temp dirs are registered through a file, not an array: `tmp="$(mktemp_root)"` runs in a
# subshell, so an array append there would be lost and the directory would leak.
CLEANUP_LIST="$(mktemp "${TMPDIR:-/tmp}/agent-skills-cleanup.XXXXXX")"
cleanup() {
  local dir
  [[ -f "$CLEANUP_LIST" ]] || return 0
  while IFS= read -r dir; do
    [[ -n "$dir" && -d "$dir" && "$dir" != "/tmp" ]] && rm -rf -- "$dir"
  done < "$CLEANUP_LIST"
  rm -f -- "$CLEANUP_LIST"
}

mktemp_root() { # sets MKTEMP_DIR
  MKTEMP_DIR="$(mktemp -d "${TMPDIR:-/tmp}/agent-skills.XXXXXX")"
  printf '%s\n' "$MKTEMP_DIR" >> "$CLEANUP_LIST"
}

is_library() {
  local d="$1"
  [[ -f "$d/scripts/validate_skills.py" ]] || return 1
  [[ -n "$(find "$d" -mindepth 3 -maxdepth 3 -type f -name SKILL.md -print -quit 2>/dev/null)" ]]
}

# Where do the skills come from? An explicit --source, the checkout holding this script,
# or a tarball fetched from GitHub. The last case is what makes the curl one-liner work:
# a piped script has no directory of its own, so it must download the library.
resolve_source() {
  if [[ -n "$SOURCE_DIR" ]]; then
    [[ -d "$SOURCE_DIR" ]] || fail "--source is not a directory: $SOURCE_DIR"
    SOURCE_DIR="$(cd -- "$SOURCE_DIR" && pwd)"
    is_library "$SOURCE_DIR" || fail "--source does not look like the skills library (no scripts/validate_skills.py, no */*/SKILL.md): $SOURCE_DIR"
    return
  fi
  if is_library "$SCRIPT_DIR"; then
    SOURCE_DIR="$SCRIPT_DIR"
    return
  fi
  bootstrap_source
}

bootstrap_source() {
  local tmp url out root
  command -v tar >/dev/null 2>&1 || fail "tar is required to unpack the downloaded library"
  mktemp_root; tmp="$MKTEMP_DIR"
  url="$ARCHIVE_URL"
  [[ -n "$url" ]] || url="https://github.com/$REPO/archive/$REF.tar.gz"
  info "No library checkout next to this script; fetching $REPO@$REF"
  info "Source: $url"
  if command -v curl >/dev/null 2>&1; then
    curl -fsSL --retry 3 --connect-timeout 10 -o "$tmp/library.tar.gz" "$url" \
      || fail "Download failed: $url
  Retry with --ref <branch|tag|sha>, point --source at a local checkout, or set SKILLS_ARCHIVE_URL."
  elif command -v wget >/dev/null 2>&1; then
    wget -q -O "$tmp/library.tar.gz" "$url" || fail "Download failed: $url (wget)"
  else
    fail "curl or wget is required for the no-clone install; otherwise clone the repository and run ./install.sh"
  fi
  out="$tmp/library"
  mkdir -p "$out"
  tar -xzf "$tmp/library.tar.gz" -C "$out" || fail "could not unpack $url"
  root="$(find "$out" -mindepth 1 -maxdepth 1 -type d -print | head -n 1)"
  [[ -n "$root" ]] || fail "the downloaded archive contained no directory"
  is_library "$root" || fail "the downloaded archive is not a skills library checkout"
  SOURCE_DIR="$(cd -- "$root" && pwd -P)"
  ok "Using $REPO@$REF from a temporary checkout"
}

load_skills() {
  SKILL_PATHS=()
  local line
  while IFS= read -r line; do
    [[ -n "$line" ]] && SKILL_PATHS+=("$line")
  done < <(find "$SOURCE_DIR" -mindepth 3 -maxdepth 3 -type f -name SKILL.md -print | LC_ALL=C sort)
  ((${#SKILL_PATHS[@]} > 0)) || fail "no <category>/<skill>/SKILL.md files found in $SOURCE_DIR"
}

skill_count() { printf '%s' "${#SKILL_PATHS[@]}"; }

# ------------------------------------------------------------------ instruction files
# Created once, never overwritten, and recorded in the manifest so uninstall can undo them.
# Content arrives as an argument rather than a pipe: a pipe writer would die of SIGPIPE
# whenever this function returns early on an existing file.
write_file_if_missing() {
  local rel="$1" content="$2" file="$TARGET/$1"
  if [[ -e "$file" ]]; then
    warn "Preserved existing $rel"
    return
  fi
  CREATED+=("$rel")
  if (( DRY_RUN )); then
    info "Would create $rel"
    return
  fi
  mkdir -p -- "$(dirname -- "$file")"
  printf '%s\n' "$content" > "$file"
  ok "Created $rel"
}

bridge_text() {
  local dir="$1"
  cat <<EOF
# Coding Agent Skill Library

Before a non-trivial task, open \`$dir/INDEX.md\`, pick the smallest set of playbooks that
changes the next action, and read those \`SKILL.md\` files. Inspect before editing, keep the
diff scoped to the cause, and verify with project-native checks proportional to the risk.
Never invent a passing result. Never expose secrets or private reasoning: report
assumptions, decisions, and evidence instead.
EOF
}

write_agent_instructions() {
  local agent="$1" dir
  dir="$(agent_skills_dir "$agent")"
  dir="${dir#"$TARGET"/}"
  case "$agent" in
    claude)
      write_file_if_missing "CLAUDE.md" "$(bridge_text "$dir")"
      ;;
    cursor)
      write_file_if_missing ".cursorrules" "$(bridge_text "$dir")"
      write_file_if_missing ".cursor/rules/agent-skills.mdc" \
        "$(printf -- '---\ndescription: Coding Agent Skill Library router\nglobs: \"**/*\"\nalwaysApply: true\n---\n\n%s\n' "$(bridge_text "$dir")")"
      ;;
    windsurf)
      write_file_if_missing ".windsurfrules" "$(bridge_text "$dir")"
      ;;
    aider)
      # Aider has no skill discovery; `read:` injects the index into every chat.
      write_file_if_missing ".aider.conf.yml" \
        "$(printf '# Added by the Coding Agent Skill Library installer.\n# Delete the read: entry below to stop loading the skill index.\nread:\n  - .aider/skills/INDEX.md')"
      ;;
    continue)
      # shellcheck disable=SC2016  # backticks here are literal Markdown, not substitutions
      write_file_if_missing "$dir/README.md" \
        "$(printf '# Continue.dev\n\nContinue has no automatic skill discovery. Open `INDEX.md`, find the row for\nthe current task, and add that `SKILL.md` to the chat context before the agent\nedits code.\n')"
      ;;
    hermes)
      write_file_if_missing ".hermes/config.yaml" \
        "$(printf 'skills:\n  path: %s\n  auto_load: false\n  triggers: true' "$dir")"
      ;;
  esac
}

# ------------------------------------------------------------------------ index + docs
build_index() {
  printf '# Skill index\n\n'
  printf 'Generated by install.sh v%s from %s@%s. One row per playbook; load only what the task needs.\n\n' \
    "$VERSION" "$REPO" "$REF"
  printf '| Skill | Category | Priority | Purpose | File |\n|---|---|---|---|---|\n'
  local path rel name
  for path in "${SKILL_PATHS[@]}"; do
    rel="${path#"$SOURCE_DIR"/}"
    name="$(basename "$(dirname "$path")")"
    awk -v rel="$rel" -v dir="$name" '
      /^---[ \t]*$/ { fm++; if (fm == 2) exit; next }
      fm >= 1 {
        if ($0 ~ /^name:/)       { sub(/^name:[ \t]*/, ""); name = $0 }
        if ($0 ~ /^priority:/)    { sub(/^priority:[ \t]*/, ""); prio = $0 }
        if ($0 ~ /^description:/) {
          inf = 1
          sub(/^description:[ \t]*>?-?[ \t]*/, "")
          if (length($0)) desc = (desc == "" ? $0 : desc " " $0)
          next
        }
        if (inf == 1) {
          line = $0
          sub(/^[ \t]+/, "", line)
          if (line != "") desc = (desc == "" ? line : desc " " line)
          if (length(desc) > 190) inf = 0
        }
      }
      END {
        sub(/[ \t]*TRIGGERS:.*/, "", desc)
        sub(/[ \t]*(English|فارسی):[ \t]*/, "", desc)
        gsub(/[ \t]+/, " ", desc)
        gsub(/\|/, "/", desc)
        if (length(desc) > 200) desc = substr(desc, 1, 200) "…"
        cat = rel; sub(/\/.*/, "", cat)
        if (name == "") name = dir
        # Path comes from the installed directory, so it stays correct even if a
        # frontmatter `name:` and its directory ever disagree.
        printf "| %s | %s | %s | %s | `%s/SKILL.md` |\n", name, cat, (prio == "" ? "-" : prio), desc, dir
      }
    ' "$path"
  done
}

# Write a file into the destination and record it in the manifest. Relies on $manifest
# (previous) and ${manifest}.new (this run) from install_agent's scope: a path the
# installer never recorded belongs to the user and is never overwritten.
first_line() { local line=""; IFS= read -r line < "$1" || true; printf '%s' "$line"; }
owns_path() {
  local rel="$1"
  [[ -f "$manifest" ]] && grep -qxF "file:$rel" "$manifest"
}

write_managed_file() {
  local dest="$1" name="$2" content="${3-}" file rel
  file="$dest/$name"
  rel="${dest#"$TARGET"/}/$name"
  if [[ -e "$file" ]] && ! owns_path "$rel" \
    && ! { [[ "$name" == INDEX.md ]] && [[ "$(first_line "$file")" == "# Skill index" ]]; }; then
    warn "Preserved existing $rel (not managed by this installer)"
    return
  fi
  if (( DRY_RUN )); then
    info "Would write $rel"
    return
  fi
  mkdir -p -- "$dest" "$(dirname -- "$manifest")"
  printf '%s\n' "$content" > "$file"
  printf 'file:%s\n' "$rel" >> "${manifest}.new"
}

write_shared_docs() {
  local dest="$1" doc rel
  for doc in ROUTER.md AGENT.md; do
    [[ -f "$SOURCE_DIR/$doc" ]] || continue
    rel="${dest#"$TARGET"/}/$doc"
    if [[ -e "$dest/$doc" ]] && ! owns_path "$rel"; then
      warn "Preserved existing $rel (not managed by this installer)"
      continue
    fi
    if (( DRY_RUN )); then
      info "Would copy $doc to $rel"
      continue
    fi
    mkdir -p -- "$dest" "$(dirname -- "$manifest")"
    cp -a -- "$SOURCE_DIR/$doc" "$dest/$doc"
    printf 'file:%s\n' "$rel" >> "${manifest}.new"
  done
}

# ----------------------------------------------------------------------------- actions
# Manifest entries are `dir:`/`file:` paths relative to the target. Anything absolute,
# escaping the target, or hand-mangled is ignored so a bad manifest cannot delete home.
manage_path() {
  local entry="$1" base="$2" mode="$3" kind path abs
  [[ -n "$entry" ]] || return 0
  kind="${entry%%:*}"
  path="${entry#*:}"
  [[ "$kind" == dir || "$kind" == file ]] || return 0
  if [[ -z "$path" || "$path" == /* || "$path" == *..* ]]; then
    warn "Ignoring unsafe manifest entry: $entry"
    return
  fi
  abs="$base/$path"
  [[ "$abs" == "$base"/* ]] || { warn "Ignoring escaping manifest entry: $entry"; return; }
  [[ -e "$abs" || -L "$abs" ]] || return 0
  if [[ "$mode" == print ]]; then
    printf '  %s\n' "$path"
    return
  fi
  # A `file:` entry must stay a file; never let a stale manifest remove a directory tree.
  if [[ "$kind" == file && ! -f "$abs" && ! -L "$abs" ]]; then
    warn "Manifest says file but found a directory: $path"
    return
  fi
  rm -rf -- "$abs"
}

install_agent() {
  local agent="$1" destination manifest path rel reldir name n=0 created
  local -A SEEN_NAMES=()
  destination="$(agent_skills_dir "$agent")"
  manifest="$(agent_manifest "$agent")"
  info "$(agent_label "$agent"): installing $(skill_count) skills into ${destination#"$TARGET"/}"

  if (( DRY_RUN )); then
    for path in "${SKILL_PATHS[@]}"; do
      printf '  %s\n' "${path#"$SOURCE_DIR"/} -> ${destination#"$TARGET"/}/$(basename "$(dirname "$path")")/SKILL.md"
    done
    write_managed_file "$destination" INDEX.md
    write_shared_docs "$destination"
    write_agent_instructions "$agent"
    ok "Dry run: $(skill_count) skills would be installed for $(agent_label "$agent")"
    return
  fi

  mkdir -p -- "$destination" "$(dirname -- "$manifest")"
  : > "${manifest}.new"

  # Drop previously managed paths first so renamed or deleted playbooks do not linger.
  if [[ -f "$manifest" ]]; then
    while IFS= read -r rel; do
      manage_path "$rel" "$TARGET" remove
    done < "$manifest"
  fi

  # Agents discover `<skills>/<name>/SKILL.md`, so the layout under the agent directory is
  # flat: the category stays visible in the generated INDEX.md instead of the path.
  for path in "${SKILL_PATHS[@]}"; do
    rel="${path#"$SOURCE_DIR"/}"       # coding/debugging/SKILL.md
    reldir="${rel%/*}"                 # coding/debugging
    name="$(basename "$reldir")"
    [[ -z "${SEEN_NAMES[$name]+x}" ]] || fail "two skills share the name '$name' ($SOURCE_DIR/${SEEN_NAMES[$name]} and $reldir); rename one of them"
    SEEN_NAMES["$name"]="$reldir"
    cp -a -- "$SOURCE_DIR/$reldir" "$destination/"
    printf 'dir:%s/%s\n' "${destination#"$TARGET"/}" "$name" >> "${manifest}.new"
    n=$((n + 1))
  done

  write_managed_file "$destination" INDEX.md "$(build_index)"
  write_shared_docs "$destination"
  write_agent_instructions "$agent"

  for created in "${CREATED[@]:-}"; do
    [[ -n "$created" ]] && printf 'file:%s\n' "$created" >> "${manifest}.new"
  done
  sort -u "${manifest}.new" -o "$manifest"
  rm -f -- "${manifest}.new"
  ok "Installed $n skills for $(agent_label "$agent") ($(wc -l < "$manifest" | tr -d ' ') managed paths)"
}

# A manifest written by the pre-6.0 installer listed bare category directories
# ("coding") instead of typed paths. v5 copied only SKILL.md files, so a subdir holding
# exactly one SKILL.md is provably ours; anything else belongs to the user and stays.
uninstall_legacy_manifest() {
  local destination="$1" manifest="$2" category skill dir files removed=0
  while IFS= read -r category; do
    [[ -n "$category" && "$category" != /* && "$category" != *..* ]] || continue
    [[ "$category" == dir:* || "$category" == file:* ]] && continue
    [[ -d "$destination/$category" ]] || continue
    for skill in "$destination/$category"/*/; do
      [[ -d "$skill" ]] || continue
      files="$(find "$skill" -type f | wc -l | tr -d ' ')"
      [[ -f "$skill/SKILL.md" && "$files" == "1" ]] || { warn "Kept $(basename "$skill"): not a v5-installed skill directory"; continue; }
      if (( DRY_RUN )); then
        info "Would remove ${skill#"$TARGET"/}"
      else
        dir="$(dirname -- "$skill")"
        rm -rf -- "${skill%/}"
        [[ -d "$dir" ]] && find "$dir" -depth -type d -empty -delete
        removed=$((removed + 1))
      fi
    done
  done < "$manifest"
  if (( DRY_RUN )); then
    ok "Dry run: a v5 manifest was found; managed paths would be reconciled"
    return
  fi
  rm -f -- "$manifest"
  [[ -d "$destination" ]] && find "$destination" -depth -type d -empty -delete
  rmdir --ignore-fail-on-non-empty -- "$(dirname -- "$manifest")" 2>/dev/null || true
  warn "Migrated a pre-6.0 manifest: removed $removed v5-managed skill director(ies)"
}

uninstall_agent() {
  local agent="$1" destination manifest entry removed=0
  destination="$(agent_skills_dir "$agent")"
  manifest="$(agent_manifest "$agent")"
  if [[ ! -f "$manifest" ]]; then
    warn "No managed manifest for $(agent_label "$agent"); nothing removed"
    return
  fi
  if ! grep -qE '^(dir|file):' "$manifest"; then
    uninstall_legacy_manifest "$destination" "$manifest"
    return
  fi
  while IFS= read -r entry; do
    [[ "$entry" == dir:* || "$entry" == file:* ]] || continue
    if (( DRY_RUN )); then
      manage_path "$entry" "$TARGET" print
    else
      manage_path "$entry" "$TARGET" remove
      removed=$((removed + 1))
    fi
  done < "$manifest"
  if (( DRY_RUN )); then
    ok "Dry run complete for $(agent_label "$agent")"
    return
  fi
  rm -f -- "$manifest"
  [[ -d "$destination" ]] && find "$destination" -depth -type d -empty -delete
  rmdir --ignore-fail-on-non-empty -- "$(dirname -- "$manifest")" 2>/dev/null || true
  ok "Removed $removed managed paths for $(agent_label "$agent"); user files preserved"
}

list_skills() {
  local path rel categories count
  categories="$(printf '%s\n' "${SKILL_PATHS[@]}" | sed "s|^$SOURCE_DIR/||; s|/.*||" | sort -u)"
  count="$(printf '%s\n' "$categories" | grep -c .)"
  printf '%s\n' "Library: $SOURCE_DIR"
  printf '%s\n' "Source:  $REPO@$REF"
  printf '%s\n' "Skills:  $(skill_count) in $count categories"
  for path in "${SKILL_PATHS[@]}"; do
    rel="${path#"$SOURCE_DIR"/}"
    printf '  %s\n' "${rel%/SKILL.md}"
  done
}

run_check() {
  command -v python3 >/dev/null 2>&1 || fail "python3 is required for --check"
  [[ -f "$SOURCE_DIR/scripts/validate_skills.py" ]] || fail "scripts/validate_skills.py is missing from $SOURCE_DIR"
  ( cd -- "$SOURCE_DIR" && python3 scripts/validate_skills.py )
  bash -n "$SOURCE_DIR/install.sh" && ok "install.sh syntax OK"
}

# End-to-end proof that install → update → uninstall round-trips cleanly. Used by CI.
self_test() {
  local tmp target before agent found status=0
  mktemp_root; tmp="$MKTEMP_DIR"
  target="$tmp/project"
  mkdir -p "$target"
  before="$(skill_count)"
  TARGET="$target"
  for agent in "${all_agents[@]}"; do
    install_agent "$agent" > /dev/null 2>&1 || { warn "self-test: install failed for $agent"; return 1; }
    found="$(find "$(agent_skills_dir "$agent")" -name SKILL.md | wc -l | tr -d ' ')"
    [[ "$found" == "$before" ]] || { warn "self-test: $agent has $found of $before SKILL.md files"; status=1; }
    [[ -f "$(agent_skills_dir "$agent")/INDEX.md" ]] || { warn "self-test: $agent has no INDEX.md"; status=1; }
    [[ -f "$(agent_manifest "$agent")" ]] || { warn "self-test: $agent has no manifest"; status=1; }
    install_agent "$agent" > /dev/null 2>&1 || { warn "self-test: update failed for $agent"; status=1; }
    find "$(agent_skills_dir "$agent")" -name SKILL.md | wc -l | grep -q "^[[:space:]]*$before$" \
      || { warn "self-test: $agent count changed after update"; status=1; }
    uninstall_agent "$agent" > /dev/null 2>&1 || { warn "self-test: uninstall failed for $agent"; status=1; }
    if [[ -d "$(agent_skills_dir "$agent")" ]] && [[ -n "$(find "$(agent_skills_dir "$agent")" -type f 2>/dev/null | head -n 1)" ]]; then
      warn "self-test: $agent left files behind after uninstall"
      status=1
    fi
  done
  [[ -e "$target/.agent-skills-manifests" ]] && { warn "self-test: manifest directory survived uninstall"; status=1; }

  # A pre-6.0 manifest listed bare category directories. The migration may remove only the
  # nested skill dirs that hold nothing but a SKILL.md — this guards the one rm -rf path that
  # runs against a layout the installer did not create in this format.
  local legacy="$target/.claude/skills/quality/review" user="$target/.claude/skills/quality/mine"
  mkdir -p "$legacy" "$user" "$(dirname -- "$(agent_manifest claude)")"
  : > "$legacy/SKILL.md"
  : > "$user/SKILL.md"
  : > "$user/helper.py"
  printf 'quality\n' > "$(agent_manifest claude)"
  uninstall_agent claude > /dev/null 2>&1 || { warn "self-test: legacy manifest uninstall failed"; status=1; }
  [[ ! -e "$legacy" ]] || { warn "self-test: v5-managed skill directory was left behind"; status=1; }
  [[ -f "$user/helper.py" ]] || { warn "self-test: legacy cleanup deleted a user file"; status=1; }
  [[ ! -e "$(agent_manifest claude)" ]] || { warn "self-test: legacy manifest was not rewritten"; status=1; }
  if (( status == 0 )); then
    ok "self-test passed: ${before} skills × ${#all_agents[@]} agents install/update/uninstall is clean, and the v5 manifest migration is safe"
  fi
  return "$status"
}

# -------------------------------------------------------------------------- argument parsing
select_all() { SELECTED=("${all_agents[@]}"); }

add_agent() {
  local agent="$1" existing
  for existing in "${SELECTED[@]:-}"; do
    [[ "$existing" == "$agent" ]] && return
  done
  SELECTED+=("$agent")
}

parse_args() {
  while (($#)); do
    case "$1" in
      --install) ACTION=install ;;
      --update) ACTION=update ;;
      --uninstall) ACTION=uninstall ;;
      --check) ACTION=check ;;
      --self-test) ACTION=self-test ;;
      --list) ACTION=list ;;
      --all) select_all ;;
      --claude|--cursor|--windsurf|--aider|--continue|--hermes) add_agent "${1#--}" ;;
      --target) (($# >= 2)) || fail "--target requires a directory"; TARGET="$2"; shift ;;
      --source) (($# >= 2)) || fail "--source requires a directory"; SOURCE_DIR="$2"; shift ;;
      --ref) (($# >= 2)) || fail "--ref requires a value"; REF="$2"; shift ;;
      --repo) (($# >= 2)) || fail "--repo requires OWNER/NAME"; REPO="$2"; shift ;;
      --dry-run) DRY_RUN=1 ;;
      --no-color) no_color ;;
      -h|--help) usage; exit 0 ;;
      *) fail "Unknown option: $1 (use --help)" ;;
    esac
    shift
  done
}

interactive() {
  printf '%b\nCoding Agent Skill Library v%s%b\n' "$C_CYAN$C_BOLD" "$VERSION" "$C_RESET"
  printf 'Target: %s\n' "$TARGET"
  printf 'Source: %s\n\n' "$SOURCE_DIR"
  local i choice
  for i in "${!all_agents[@]}"; do printf '  %d) %s\n' "$((i + 1))" "$(agent_label "${all_agents[$i]}")"; done
  printf '\n  a) All agents\n  c) Check library\n  q) Quit\n\nSelect agents (for example: 1 3): '
  read -r choice
  [[ "$choice" == q ]] && exit 0
  [[ "$choice" == c ]] && { run_check; exit 0; }
  if [[ "$choice" == a ]]; then
    select_all
  else
    SELECTED=()
    for i in $choice; do
      [[ "$i" =~ ^[1-6]$ ]] || fail "Invalid selection: $i"
      add_agent "${all_agents[$((i - 1))]}"
    done
  fi
  ACTION=install
}

safe_target() {
  [[ -d "$TARGET" ]] || fail "Target directory does not exist: $TARGET"
  TARGET="$(cd -- "$TARGET" && pwd)"
  [[ "$TARGET" != "$SOURCE_DIR" ]] || fail "Target is the skills library itself. Run from your project or pass --target /path/to/project."
}

report_next_step() {
  local agent dir
  (( DRY_RUN )) && return
  for agent in "${SELECTED[@]:-}"; do
    [[ -n "$agent" ]] || continue
    dir="$(agent_skills_dir "$agent")"
    [[ -f "$dir/INDEX.md" ]] || continue
    info "$(agent_label "$agent"): open ${dir#"$TARGET"/}/INDEX.md and load the row for your task"
  done
  info "Reload the agent or start a new session so it picks up the new files."
}

main() {
  trap cleanup EXIT INT TERM
  parse_args "$@"
  case "$ACTION" in
    check) resolve_source; load_skills; run_check; return ;;
    list) resolve_source; load_skills; list_skills; return ;;
  esac
  (($# == 0)) && interactive
  resolve_source
  load_skills
  [[ "$ACTION" == self-test ]] && { self_test; return; }
  safe_target
  ((${#SELECTED[@]} > 0)) || fail "Select at least one agent (try --help)"
  local agent
  for agent in "${SELECTED[@]}"; do
    agent_label "$agent" > /dev/null || fail "Unsupported agent: $agent"
    CREATED=()
    if [[ "$ACTION" == uninstall ]]; then
      uninstall_agent "$agent"
    else
      install_agent "$agent"
    fi
  done
  report_next_step
}

main "$@"
