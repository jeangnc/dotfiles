# Dotfiles Makefile
# Manages dotfiles installation using GNU Stow

# Define packages to install/uninstall
PACKAGES := zsh git kitty nvim tmux claude

# Colors for output
RED := \033[0;31m
GREEN := \033[0;32m
YELLOW := \033[1;33m
BLUE := \033[0;34m
NC := \033[0m

# Default target
.PHONY: install
install: check-stow
	@echo -e "$(BLUE)[INFO]$(NC) Starting dotfiles installation with GNU Stow"
	@$(foreach pkg,$(PACKAGES),\
		if [ -d "$(pkg)" ]; then \
			echo -e "$(BLUE)[INFO]$(NC) Installing $(pkg)..."; \
			if stow --target="$(HOME)" "$(pkg)"; then \
				echo -e "$(GREEN)[SUCCESS]$(NC) $(pkg) installed successfully"; \
			else \
				echo -e "$(RED)[ERROR]$(NC) Failed to install $(pkg)"; \
				echo -e "$(YELLOW)[WARN]$(NC) Check for conflicts in your home directory"; \
			fi; \
		else \
			echo -e "$(YELLOW)[WARN]$(NC) Package '$(pkg)' directory not found, skipping..."; \
		fi; \
	)
	@echo -e "$(GREEN)[SUCCESS]$(NC) Dotfiles installation completed!"
	@echo -e "$(BLUE)[INFO]$(NC) You may need to restart your shell or source your config files"

.PHONY: uninstall
uninstall:
	@echo -e "$(BLUE)[INFO]$(NC) Uninstalling dotfiles..."
	@$(foreach pkg,$(PACKAGES),\
		if [ -d "$(pkg)" ]; then \
			echo -e "$(BLUE)[INFO]$(NC) Removing $(pkg)..."; \
			stow --target="$(HOME)" --delete "$(pkg)" || \
				echo -e "$(YELLOW)[WARN]$(NC) Failed to remove $(pkg)"; \
		fi; \
	)
	@echo -e "$(GREEN)[SUCCESS]$(NC) Dotfiles uninstalled"

.PHONY: restow
restow:
	@echo -e "$(BLUE)[INFO]$(NC) Re-installing dotfiles..."
	@$(foreach pkg,$(PACKAGES),\
		if [ -d "$(pkg)" ]; then \
			echo -e "$(BLUE)[INFO]$(NC) Re-stowing $(pkg)..."; \
			stow --target="$(HOME)" --restow "$(pkg)" || \
				echo -e "$(YELLOW)[WARN]$(NC) Failed to restow $(pkg)"; \
		fi; \
	)
	@echo -e "$(GREEN)[SUCCESS]$(NC) Dotfiles re-installed"

.PHONY: check-stow
check-stow:
	@if ! command -v stow >/dev/null 2>&1; then \
		echo -e "$(RED)[ERROR]$(NC) GNU Stow is not installed!"; \
		echo "Install it with:"; \
		echo "  macOS: brew install stow"; \
		echo "  Ubuntu/Debian: sudo apt install stow"; \
		echo "  Fedora: sudo dnf install stow"; \
		exit 1; \
	fi

.PHONY: help
help:
	@echo "Usage: make [target]"
	@echo "Targets:"
	@echo "  install   - Install dotfiles (default)"
	@echo "  uninstall - Remove all symlinks"
	@echo "  restow    - Re-install (useful after changes)"
	@echo "  help      - Show this help message"