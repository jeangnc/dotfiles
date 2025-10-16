# Claude Plugins Makefile
# Manages local Claude Code plugins

# Colors
RED := \033[0;31m
GREEN := \033[0;32m
YELLOW := \033[1;33m
BLUE := \033[0;34m
NC := \033[0m

# Paths
PLUGINS_DIR := $(CURDIR)/plugins
MARKETPLACE_NAME := local

.PHONY: install uninstall update help

# Install marketplace and plugins
install:
	@echo -e "$(BLUE)[INFO]$(NC) Installing Claude plugins marketplace..."
	@echo -e "$(YELLOW)[ACTION]$(NC) Run this command in Claude Code:"
	@echo ""
	@echo "  /plugin marketplace add $(MARKETPLACE_NAME) ~/.dotfiles/claude/plugins"
	@echo ""
	@echo -e "$(BLUE)[INFO]$(NC) Then install the dev plugin:"
	@echo ""
	@echo "  /plugin install dev@$(MARKETPLACE_NAME)"
	@echo ""

# Remove marketplace
uninstall:
	@echo -e "$(YELLOW)[ACTION]$(NC) Run this command in Claude Code:"
	@echo ""
	@echo "  /plugin marketplace remove $(MARKETPLACE_NAME)"
	@echo ""

# Update plugins (commit changes)
update:
	@echo -e "$(BLUE)[INFO]$(NC) Committing plugin changes..."
	@cd $(PLUGINS_DIR) && \
		git add -A && \
		git commit -m "Update plugins" && \
		echo -e "$(GREEN)[SUCCESS]$(NC) Plugin changes committed"
	@echo -e "$(YELLOW)[ACTION]$(NC) Run this command in Claude Code to sync:"
	@echo ""
	@echo "  /plugin update dev@$(MARKETPLACE_NAME)"
	@echo ""

# Show help
help:
	@echo "Claude Plugins Makefile"
	@echo ""
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@echo "  install   - Show commands to install marketplace and plugins"
	@echo "  update    - Commit plugin changes and show update command"
	@echo "  uninstall - Show command to remove marketplace"
	@echo "  help      - Show this help message"
