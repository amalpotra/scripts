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
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
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
    gh
    tree
    gnupg
    pinentry-mac
    node
    k9s
    helm
    azure-cli
    kubernetes-cli
    zsh-syntax-highlighting
    zsh-autosuggestions
)

HOMEBREW_CASKS=(
    zed
    fork
    httpie
    rancher
    spotify
    google-chrome
    jetbrains-toolbox
    visual-studio-code
    firefox@developer-edition
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

# Configure zsh plugins
if brew list zsh-autosuggestions >/dev/null 2>&1 && ! grep -q "zsh-autosuggestions" "$HOME/.zshrc"; then
    echo "source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh" >>"$HOME/.zshrc"
fi

if brew list zsh-syntax-highlighting >/dev/null 2>&1 && ! grep -q "zsh-syntax-highlighting" "$HOME/.zshrc"; then
    echo "source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >>"$HOME/.zshrc"
fi

read -rp "Do you want to run brew cleanup? [y/N]: " cleanup
if [[ "$cleanup" =~ ^[Yy]$ ]]; then
    brew cleanup --prune=all
fi
