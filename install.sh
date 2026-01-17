#!/bin/bash
# SCP Terminal SDDM Theme Installer
# Usage: sudo ./install.sh [install|uninstall|test]

set -e

THEME_NAME="scp_terminal"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SDDM_THEMES_DIR="/usr/share/sddm/themes"
INSTALL_DIR="${SDDM_THEMES_DIR}/${THEME_NAME}"
SDDM_CONF="/etc/sddm.conf"
SDDM_CONF_D="/etc/sddm.conf.d"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Functions
print_header() {
    echo -e "${RED}"
    echo "═══════════════════════════════════════════════════"
    echo "   SCP TERMINAL - SDDM THEME INSTALLER"
    echo "   Antimemetics Division - Site 41"
    echo "═══════════════════════════════════════════════════"
    echo -e "${NC}"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_info() {
    echo -e "${YELLOW}[INFO]${NC} $1"
}

check_root() {
    if [ "$EUID" -ne 0 ]; then
        print_error "This script must be run as root (use sudo)"
        exit 1
    fi
}

check_sddm() {
    if ! command -v sddm &> /dev/null; then
        print_error "SDDM is not installed"
        print_info "Install SDDM first: sudo pacman -S sddm (Arch) or sudo apt install sddm (Debian/Ubuntu)"
        exit 1
    fi
    print_success "SDDM found: $(sddm --version)"
}

backup_config() {
    if [ -f "$SDDM_CONF" ]; then
        local backup="${SDDM_CONF}.backup.$(date +%Y%m%d_%H%M%S)"
        cp "$SDDM_CONF" "$backup"
        print_info "Backed up SDDM config to: $backup"
    fi
}

install_theme() {
    print_header
    check_root
    check_sddm
    
    print_info "Installing theme to: $INSTALL_DIR"
    
    # Create installation directory
    mkdir -p "$INSTALL_DIR"
    
    # Copy theme files
    print_info "Copying theme files..."
    cp -r "$SCRIPT_DIR/qml" "$INSTALL_DIR/"
    cp -r "$SCRIPT_DIR/assets" "$INSTALL_DIR/"
    cp -r "$SCRIPT_DIR/fonts" "$INSTALL_DIR/"
    cp -r "$SCRIPT_DIR/sound" "$INSTALL_DIR/"
    cp -r "$SCRIPT_DIR/shaders" "$INSTALL_DIR/"
    cp "$SCRIPT_DIR/metadata.desktop" "$INSTALL_DIR/"
    cp "$SCRIPT_DIR/theme.conf" "$INSTALL_DIR/"
    
    if [ -f "$SCRIPT_DIR/README.md" ]; then
        cp "$SCRIPT_DIR/README.md" "$INSTALL_DIR/"
    fi
    
    # Set permissions
    print_info "Setting permissions..."
    chmod -R 755 "$INSTALL_DIR"
    chown -R root:root "$INSTALL_DIR"
    
    print_success "Theme files installed"
    
    # Configure SDDM
    print_info "Configuring SDDM..."
    backup_config
    
    # Use sddm.conf.d if available (preferred)
    if [ -d "$SDDM_CONF_D" ]; then
        cat > "${SDDM_CONF_D}/theme.conf" <<EOF
[Theme]
Current=${THEME_NAME}
EOF
        print_success "Created ${SDDM_CONF_D}/theme.conf"
    else
        # Fallback to main sddm.conf
        if [ -f "$SDDM_CONF" ]; then
            # Update existing file
            if grep -q "^\[Theme\]" "$SDDM_CONF"; then
                sed -i "/^\[Theme\]/,/^\[/ s/^Current=.*/Current=${THEME_NAME}/" "$SDDM_CONF"
            else
                echo -e "\n[Theme]\nCurrent=${THEME_NAME}" >> "$SDDM_CONF"
            fi
        else
            # Create new config
            cat > "$SDDM_CONF" <<EOF
[Theme]
Current=${THEME_NAME}
EOF
        fi
        print_success "Updated $SDDM_CONF"
    fi
    
    print_success "Installation complete!"
    echo ""
    print_info "To apply changes, restart SDDM:"
    echo "  sudo systemctl restart sddm"
    echo ""
    print_info "Or reboot your system"
    echo ""
    print_info "To test without restarting:"
    echo "  sudo ./install.sh test"
}

uninstall_theme() {
    print_header
    check_root
    
    print_info "Uninstalling theme..."
    
    # Remove theme directory
    if [ -d "$INSTALL_DIR" ]; then
        rm -rf "$INSTALL_DIR"
        print_success "Removed theme files from $INSTALL_DIR"
    else
        print_info "Theme directory not found, nothing to remove"
    fi
    
    # Reset SDDM config
    if [ -f "${SDDM_CONF_D}/theme.conf" ]; then
        rm "${SDDM_CONF_D}/theme.conf"
        print_success "Removed ${SDDM_CONF_D}/theme.conf"
    fi
    
    # Note: We don't automatically change Current= in main sddm.conf
    # as user might want to switch to another theme manually
    
    print_success "Uninstallation complete!"
    print_info "You may want to manually set another theme in $SDDM_CONF"
}

test_theme() {
    check_root
    
    print_info "Testing theme in test mode..."
    print_info "Press Ctrl+C to exit"
    echo ""
    
    if [ -d "$INSTALL_DIR" ]; then
        sddm-greeter --test-mode --theme "$INSTALL_DIR"
    else
        print_error "Theme not installed. Run: sudo ./install.sh install"
        exit 1
    fi
}

preview_local() {
    print_info "Previewing theme from current directory (no SDDM components)..."
    print_info "Press Ctrl+C to exit"
    echo ""
    
    if command -v qmlscene &> /dev/null; then
        qmlscene "$SCRIPT_DIR/qml/Main.qml"
    else
        print_error "qmlscene not found. Install qt5-declarative:"
        print_info "  Arch: sudo pacman -S qt5-declarative"
        print_info "  Debian/Ubuntu: sudo apt install qml-module-qtquick-controls2"
        exit 1
    fi
}

show_usage() {
    echo "Usage: $0 [command]"
    echo ""
    echo "Commands:"
    echo "  install       Install theme system-wide (requires root)"
    echo "  uninstall     Remove installed theme (requires root)"
    echo "  test          Test installed theme with sddm-greeter (requires root)"
    echo "  preview       Preview theme locally with qmlscene (no root needed)"
    echo "  help          Show this help message"
    echo ""
    echo "Examples:"
    echo "  sudo ./install.sh install"
    echo "  sudo ./install.sh test"
    echo "  ./install.sh preview"
}

# Main
case "${1:-install}" in
    install)
        install_theme
        ;;
    uninstall)
        uninstall_theme
        ;;
    test)
        test_theme
        ;;
    preview)
        preview_local
        ;;
    help|--help|-h)
        show_usage
        ;;
    *)
        print_error "Unknown command: $1"
        echo ""
        show_usage
        exit 1
        ;;
esac

