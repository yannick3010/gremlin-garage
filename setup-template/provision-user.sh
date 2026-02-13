#!/bin/bash
#
# OpenClaw User Provisioning Script
# Part of Gremlin Garage Setup Service
#
# Usage: ./provision-user.sh <username> <telegram_id> <email>
#
# This script:
# 1. Creates user directories
# 2. Generates config from template
# 3. Sets up workspace files
# 4. Configures Telegram channel
#

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Defaults
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATE_DIR="$SCRIPT_DIR"
OPENCLAW_BASE="${OPENCLAW_BASE:-$HOME/.openclaw}"

# Usage function
usage() {
    echo "Usage: $0 <username> <telegram_id> [email]"
    echo ""
    echo "Arguments:"
    echo "  username     - Unique identifier for the user (no spaces)"
    echo "  telegram_id  - User's Telegram ID (numeric)"
    echo "  email        - User's email (optional)"
    echo ""
    echo "Environment Variables:"
    echo "  OPENCLAW_BASE     - Base directory for OpenClaw (default: ~/.openclaw)"
    echo "  ANTHROPIC_KEY     - Anthropic API key"
    echo "  TELEGRAM_TOKEN    - Telegram bot token"
    echo ""
    exit 1
}

# Log functions
log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Check prerequisites
check_prerequisites() {
    log_info "Checking prerequisites..."
    
    # Check if OpenClaw is installed
    if ! command -v openclaw &> /dev/null; then
        log_error "OpenClaw not found. Install with: npm install -g openclaw"
        exit 1
    fi
    
    # Check required env vars
    if [ -z "$ANTHROPIC_KEY" ]; then
        log_error "ANTHROPIC_KEY environment variable not set"
        exit 1
    fi
    
    if [ -z "$TELEGRAM_TOKEN" ]; then
        log_error "TELEGRAM_TOKEN environment variable not set"
        exit 1
    fi
    
    log_info "Prerequisites OK"
}

# Generate random gateway token
generate_token() {
    openssl rand -hex 32
}

# Create user directory structure
create_directories() {
    local user="$1"
    local user_dir="$OPENCLAW_BASE/instances/$user"
    
    log_info "Creating directory structure for $user..."
    
    mkdir -p "$user_dir"
    mkdir -p "$user_dir/workspace"
    mkdir -p "$user_dir/workspace/memory"
    mkdir -p "$user_dir/workspace/life"
    mkdir -p "$user_dir/workspace/life/projects"
    mkdir -p "$user_dir/workspace/life/areas"
    mkdir -p "$user_dir/workspace/life/resources"
    
    log_info "Directories created at $user_dir"
}

# Generate OpenClaw config from template
generate_config() {
    local user="$1"
    local telegram_id="$2"
    local user_dir="$OPENCLAW_BASE/instances/$user"
    local config_file="$user_dir/openclaw.json"
    local gateway_token=$(generate_token)
    
    log_info "Generating OpenClaw config..."
    
    # Read template and replace placeholders
    sed -e "s/__USER_NAME__/$user/g" \
        -e "s/__ANTHROPIC_API_KEY__/$ANTHROPIC_KEY/g" \
        -e "s/__TELEGRAM_BOT_TOKEN__/$TELEGRAM_TOKEN/g" \
        -e "s/__GENERATE_RANDOM_TOKEN__/$gateway_token/g" \
        -e "s|__WORKSPACE_PATH__|$user_dir/workspace|g" \
        "$TEMPLATE_DIR/openclaw.json.template" > "$config_file"
    
    log_info "Config generated at $config_file"
}

# Generate workspace files from templates
generate_workspace() {
    local user="$1"
    local telegram_id="$2"
    local email="$3"
    local user_dir="$OPENCLAW_BASE/instances/$user"
    
    log_info "Generating workspace files..."
    
    # Generate USER.md
    sed -e "s/__USER_NAME__/$user/g" \
        -e "s/__USER_NICKNAME__/$user/g" \
        -e "s/__PRONOUNS__/they\/them/g" \
        -e "s/__LOCATION__/Unknown/g" \
        -e "s/__TIMEZONE__/America\/Los_Angeles/g" \
        -e "s/__ROLE__/User/g" \
        -e "s/__BACKGROUND__/TBD/g" \
        -e "s/__DECISION_STYLE__/Thinks in frameworks and scenarios/g" \
        -e "s/__COMMUNICATION_STYLE__/Prefers concise, outcome-focused messages/g" \
        -e "s/__MEETING_PREFERENCES__/Prefers walking meetings/g" \
        -e "s/__STRENGTH_1__/Strategic thinking/g" \
        -e "s/__STRENGTH_2__/Relationship building/g" \
        -e "s/__STRENGTH_3__/Quick learner/g" \
        -e "s/__LEVERAGE_1__/Task automation/g" \
        -e "s/__LEVERAGE_2__/Research and synthesis/g" \
        -e "s/__LEVERAGE_3__/Schedule management/g" \
        -e "s/__PERSONAL_NOTES__/Added via Gremlin Garage setup/G" \
        "$TEMPLATE_DIR/workspace/USER.md.template" > "$user_dir/workspace/USER.md"
    
    # Generate SOUL.md
    sed -e "s/__ASSISTANT_NAME__/Assistant/g" \
        -e "s/__EMOJI__/🤖/g" \
        -e "s/__USER_NAME__/$user/g" \
        -e "s/__PERSONALITY_TONE__/Chill and helpful. Direct without being rude. Gets things done./g" \
        -e "s/__IDEAL_VIBE_QUOTE__/I've got you. Here's what matters. Here's what I recommend./g" \
        "$TEMPLATE_DIR/workspace/SOUL.md.template" > "$user_dir/workspace/SOUL.md"
    
    # Create other essential files
    cp "$TEMPLATE_DIR/workspace/MEMORY.md.template" "$user_dir/workspace/MEMORY.md" 2>/dev/null || true
    cp "$TEMPLATE_DIR/workspace/TASKS.md.template" "$user_dir/workspace/TASKS.md" 2>/dev/null || true
    cp "$TEMPLATE_DIR/workspace/IDENTITY.md.template" "$user_dir/workspace/IDENTITY.md" 2>/dev/null || true
    
    log_info "Workspace files generated"
}

# Create startup script
create_startup_script() {
    local user="$1"
    local user_dir="$OPENCLAW_BASE/instances/$user"
    
    log_info "Creating startup script..."
    
    cat > "$user_dir/start.sh" << 'EOF'
#!/bin/bash
#
# OpenClaw Startup Script
# Run this to start your AI assistant
#

OPENCLAW_DIR="$(dirname "$0")"
cd "$OPENCLAW_DIR"

# Load environment (add your API keys here)
export ANTHROPIC_API_KEY="your-key-here"

# Start OpenClaw with custom config
openclaw --config "$OPENCLAW_DIR/openclaw.json" gateway start
EOF

    chmod +x "$user_dir/start.sh"
    log_info "Startup script created"
}

# Main
main() {
    if [ $# -lt 2 ]; then
        usage
    fi
    
    local user="$1"
    local telegram_id="$2"
    local email="${3:-}"
    
    echo "========================================"
    echo "  Gremlin Garage - User Provisioning"
    echo "========================================"
    echo ""
    log_info "Provisioning user: $user"
    log_info "Telegram ID: $telegram_id"
    [ -n "$email" ] && log_info "Email: $email"
    echo ""
    
    check_prerequisites
    create_directories "$user"
    generate_config "$user" "$telegram_id"
    generate_workspace "$user" "$telegram_id" "$email"
    create_startup_script "$user"
    
    echo ""
    echo "========================================"
    log_info "Provisioning complete!"
    echo ""
    echo "Next steps:"
    echo "  1. Edit $OPENCLAW_BASE/instances/$user/openclaw.json"
    echo "  2. Add user's API keys"
    echo "  3. Run: $OPENCLAW_BASE/instances/$user/start.sh"
    echo ""
}

main "$@"
