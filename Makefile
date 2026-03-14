.PHONY: build test lint format format-check sim help clean release install install-hooks

PDC = pdc
SIMULATOR = $(PLAYDATE_SDK_PATH)/bin/Playdate Simulator.app/Contents/MacOS/Playdate Simulator
SOURCE_DIR = source
BUILD_DIR = builds
PDX_FILE = $(BUILD_DIR)/stillwater-approach.pdx
PDXINFO = $(SOURCE_DIR)/pdxinfo

help: ## Show this message
	@grep -E '^[a-zA-Z_-]+:.*##' Makefile | awk 'BEGIN{FS=":.*## "} {printf "  make %-16s %s\n", $$1, $$2}'

build: ## Build the .pdx file
	mkdir -p $(BUILD_DIR)
	$(PDC) $(SOURCE_DIR) $(PDX_FILE)

test: ## Run test suite (busted)
	busted

lint: ## Run static analysis (luacheck)
	luacheck $(SOURCE_DIR) spec/

format: ## Format code with stylua
	stylua $(SOURCE_DIR) spec/

format-check: ## Check formatting without changes
	stylua --check $(SOURCE_DIR) spec/

sim: build ## Build and run simulator with logs
	"$(SIMULATOR)" $(PDX_FILE)

install: install-hooks ## Install dev dependencies (macOS/Linux)
	_scripts/install.sh

install-hooks: ## Install git hooks (run once after cloning)
	ln -sf ../../_scripts/pre-commit.sh .git/hooks/pre-commit

release: ## Bump version and tag release (requires VERSION=x.y.z)
	@if [ -z "$(VERSION)" ]; then \
		echo "Error: VERSION not specified. Usage: make release VERSION=x.y.z"; \
		exit 1; \
	fi
	@current_build=$$(grep buildNumber $(PDXINFO) | sed 's/buildNumber=//'); \
	new_build=$$(($$current_build + 1)); \
	sed -i.bak 's/version=.*/version=$(VERSION)/' $(PDXINFO); \
	sed -i.bak "s/buildNumber=.*/buildNumber=$$new_build/" $(PDXINFO); \
	rm $(PDXINFO).bak; \
	git add $(PDXINFO); \
	git commit -m "Release v$(VERSION)"; \
	git tag v$(VERSION); \
	echo ""; \
	echo "✓ v$(VERSION) tagged. To push:"; \
	echo "  git push origin HEAD && git push origin v$(VERSION)"

clean: ## Remove build artifacts
	rm -rf $(BUILD_DIR)
