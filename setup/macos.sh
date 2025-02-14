#!/bin/bash

if [[ "$(uname)" != "Darwin" ]]; then
    echo "Oh no! macOS was expected instead of $(uname)."
    exit 1
fi

# Setup Xcode Command Line Tools
if ! xcode-select -p >/dev/null 2>&1; then
    echo "Xcode Command Line Tools not found. Installing..."
    xcode-select --install
else
    echo "Xcode Command Line Tools are already installed."
fi

# Setup Oh My Zsh
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    echo "Oh My Zsh not found. Installing..."
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
    echo "Oh My Zsh is already installed."
fi

# Setup Homebrew
if ! command -v brew >/dev/null 2>&1; then
    echo "Homebrew not found. Installing..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo "eval $(/opt/homebrew/bin/brew shellenv)" >>"$HOME"/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    echo "Homebrew is already installed."
fi

HOMEBREW_FORMULAE=(
    tree
    gnupg
    pinentry-mac
    node
    k9s
    helm
    kubernetes-cli
    zsh-syntax-highlighting
    zsh-autosuggestions
)

HOMEBREW_CASKS=(
    zed
    maccy
    github
    httpie
    rancher
    spotify
    logi-options+
    google-chrome
    jetbrains-toolbox
    visual-studio-code
)

# Install Homebrew formulae
for formula in "${HOMEBREW_FORMULAE[@]}"; do
    if brew list "$formula" >/dev/null 2>&1; then
        echo "$formula is already installed."
    else
        echo "Installing $formula..."
        brew install "$formula"
    fi
done

# Install Homebrew casks
for cask in "${HOMEBREW_CASKS[@]}"; do
    if brew list --cask "$cask" >/dev/null 2>&1; then
        echo "$cask is already installed."
    else
        echo "Installing $cask..."
        brew install --cask "$cask"
    fi
done

read -rp "Do you want to run brew cleanup? [y/N]: " cleanup
if [[ "$cleanup" =~ ^[Yy]$ ]]; then
    brew cleanup --prune=all
fi
