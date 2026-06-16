USE_FVM := true

ifeq ($(USE_FVM),true)
	FLUTTER := fvm flutter
	DART := fvm dart
else
	FLUTTER := flutter
	DART := dart
endif

GREEN := \033[0;32m
BLUE := \033[0;34m
RED := \033[0;31m
NC := \033[0m

.PHONY: all check_version clean pub_get l10n build_runner rename info clean_cache init init_skeleton reset_git validate_rename
# Usage:
#   Bootstrap a brand-new app from this boilerplate in ONE command:
#     make init project_name=my_app package_name=com.company.myapp app_name="My App"
#
#   ...or only rename an existing project (keeps example features):
#     make rename project_name=my_app package_name=com.company.myapp app_name="My App"
#
# Params:
#   project_name   — Dart package name in pubspec.yaml (snake_case)
#   package_name   — Android + iOS bundle ID (e.g. com.company.myapp)
#   android_package — Android only (optional, overrides package_name for Android)
#   ios_bundle      — iOS only    (optional, overrides package_name for iOS)
#   app_name        — Display name shown on device home screen
#
# `make init` = init_skeleton (remove example features) + rename + clean +
#                  reset git history (with confirmation) + verify.

all: check_version clean pub_get l10n build_runner
	@echo "$(GREEN)🎉 All tasks completed successfully!$(NC)"

check_version:
	@echo "$(BLUE)🔍 Checking Dart SDK version from pubspec.yaml...$(NC)"
	@REQUIRED_DART_VERSION=$$(sed -n '/^environment:/,/^[^ ]/p' pubspec.yaml \
		| grep -E 'sdk:' \
		| grep -v 'flutter' \
		| sed -E 's/.*\^?([0-9]+\.[0-9]+\.[0-9]+).*/\1/'); \
	if [ -z "$$REQUIRED_DART_VERSION" ]; then \
		echo "$(RED)❌ Cannot detect Dart SDK version from pubspec.yaml$(NC)"; \
		exit 1; \
	fi; \
	echo "$(GREEN)✔ Required Dart SDK: >= $$REQUIRED_DART_VERSION$(NC)"; \
	CURRENT_DART_VERSION=$$($(FLUTTER) --version \
		| grep 'Dart' \
		| sed -E 's/.*Dart ([0-9]+\.[0-9]+\.[0-9]+).*/\1/'); \
	echo "$(GREEN)✔ Current Dart SDK: $$CURRENT_DART_VERSION$(NC)"; \
	if [ "$$(printf '%s\n' "$$REQUIRED_DART_VERSION" "$$CURRENT_DART_VERSION" | sort -V | head -n1)" != "$$REQUIRED_DART_VERSION" ]; then \
		echo "$(RED)❌ Dart SDK >= $$REQUIRED_DART_VERSION is required$(NC)"; \
		exit 1; \
	fi; \
	echo "$(GREEN)🎉 Dart SDK version check passed$(NC)"

clean:
	@echo "$(BLUE)🚀 flutter clean$(NC)"
	@$(FLUTTER) clean

pub_get:
	@echo "$(BLUE)🚀 flutter pub get$(NC)"
	@$(FLUTTER) pub get

l10n:
	@echo "$(BLUE)🚀 easy_localization generate$(NC)"
	@$(DART) run easy_localization:generate -S assets/translations
	@$(DART) run easy_localization:generate -S assets/translations -f keys -o locale_keys.g.dart

build_runner:
	@echo "$(BLUE)🚀 build_runner$(NC)"
	@$(DART) run build_runner build -d

rename:
	@echo "$(BLUE)📛 Detecting old project name...$(NC)"
	@OLD_PROJECT_NAME=$$(grep '^name:' pubspec.yaml | awk '{print $$2}'); \
	OLD_ANDROID_APPLICATION_ID=$$(grep -R "applicationId" android/app 2>/dev/null \
    		| sed -E 's/.*applicationId[ ="]+([^"]+).*/\1/' \
    		| head -n 1); \
	OLD_IOS_BUNDLE_ID=$$(grep -R "PRODUCT_BUNDLE_IDENTIFIER" ios/Runner.xcodeproj/project.pbxproj \
    		| sed -E 's/.*= ([^;]+);/\1/' \
    		| head -n 1); \
	if [ -z "$$OLD_PROJECT_NAME" ]; then \
		echo "$(RED)❌ Cannot detect old project name$(NC)"; \
		exit 1; \
	fi; \
	echo "$(GREEN)✔ Old PROJECT name: $$OLD_PROJECT_NAME$(NC)"; \
	echo "$(GREEN)✔ Old PACKAGE name (Android): $$OLD_ANDROID_APPLICATION_ID$(NC)"; \
	echo "$(GREEN)✔ Old BUNDLE ID (iOS): $$OLD_IOS_BUNDLE_ID$(NC)"; \
	\
	if [ -n "$(project_name)" ]; then \
		echo "$(BLUE)✏️ Updating project name → $(project_name)$(NC)"; \
		sed -i '' "s/^name: $$OLD_PROJECT_NAME$$/name: $(project_name)/" pubspec.yaml; \
		grep -rl "package:$$OLD_PROJECT_NAME/" lib test 2>/dev/null \
		| xargs sed -i '' "s/package:$$OLD_PROJECT_NAME\//package:$(project_name)\//g" || true; \
	fi; \
	\
    if [ -n "$(package_name)" ]; then \
    	echo "$(BLUE)📦🍎 Changing package name (Android + iOS) → $(package_name)$(NC)"; \
    	$(DART) run change_app_package_name:main $(package_name); \
    else \
		if [ -n "$(android_package)" ]; then \
			echo "$(BLUE)📦 Changing Android package → $(android_package)$(NC)"; \
			$(DART) run change_app_package_name:main $(android_package) --android; \
		fi; \
			\
		if [ -n "$(ios_bundle)" ]; then \
			echo "$(BLUE)🍎 Changing iOS bundle → $(ios_bundle)$(NC)"; \
			$(DART) run change_app_package_name:main $(ios_bundle) --ios;\
		fi; \
	fi;
	@if [ -n "$(app_name)" ]; then \
		echo "$(BLUE)🏷️  Updating display name → $(app_name)$(NC)"; \
		OLD_APP_NAME=$$(grep -m1 'resValue.*"app_name"' android/app/build.gradle.kts \
			| sed -E 's/.*"app_name", "([^"]+)".*/\1/' \
			| sed 's/^\[STG\] //;s/^\[DEV\] //'); \
		sed -i '' \
			-e "s/\[DEV\] $$OLD_APP_NAME/[DEV] $(app_name)/g" \
			-e "s/\[STG\] $$OLD_APP_NAME/[STG] $(app_name)/g" \
			-e "s/\"app_name\", \"$$OLD_APP_NAME\"/\"app_name\", \"$(app_name)\"/g" \
			android/app/build.gradle.kts; \
		/usr/libexec/PlistBuddy -c "Set :CFBundleDisplayName $(app_name)" ios/Runner/Info.plist; \
		/usr/libexec/PlistBuddy -c "Set :CFBundleName $(app_name)" ios/Runner/Info.plist; \
		echo "$(GREEN)✔ Display name updated$(NC)"; \
	fi
	@echo "$(BLUE)⚙️  Regenerating code (build_runner + l10n)...$(NC)"
	@$(MAKE) pub_get
	@$(MAKE) l10n
	@$(MAKE) build_runner
	@$(MAKE) info
	@echo "$(GREEN)🎉 Rename completed successfully!$(NC)"

info:
	@echo "$(BLUE)📋 Detecting current project information...$(NC)"
	@PROJECT_NAME=$$(grep '^name:' pubspec.yaml | awk '{print $$2}'); \
	ANDROID_PACKAGE=$$(grep -R "applicationId" android/app 2>/dev/null \
		| sed -E 's/.*applicationId[ ="]+([^"]+).*/\1/' \
		| head -n 1); \
	IOS_BUNDLE=$$(grep -R "PRODUCT_BUNDLE_IDENTIFIER" ios/Runner.xcodeproj/project.pbxproj 2>/dev/null \
		| sed -E 's/.*= ([^;]+);/\1/' \
		| head -n 1); \
	\
	echo "$(GREEN)✔ Project name      : $$PROJECT_NAME$(NC)"; \
	echo "$(GREEN)✔ Android package   : $$ANDROID_PACKAGE$(NC)"; \
	echo "$(GREEN)✔ iOS bundle id     : $$IOS_BUNDLE$(NC)"

validate_rename:
	@if [ -z "$(old_project_name)" ] || [ -z "$(old_package)" ]; then \
		echo "$(RED)❌ Usage: make validate_rename old_project_name=flutter_clean_bloc old_package=flutter.clean.bloc$(NC)"; \
		exit 1; \
	fi
	@echo "$(BLUE)🔍 Checking for remaining boilerplate traces of '$(old_project_name)' / '$(old_package)'...$(NC)"
	@FOUND=0; \
	\
	check_file() { \
		result=$$(grep -n "$(old_project_name)\|$(old_package)" "$$1" 2>/dev/null | grep -v "^Binary"); \
		if [ -n "$$result" ]; then \
			echo "$(RED)  ✗ $$1$(NC)"; \
			echo "$$result" | head -5 | sed 's/^/    /'; \
			FOUND=1; \
		fi; \
	}; \
	\
	echo "$(BLUE)  → pubspec.yaml$(NC)"; \
	grep -n "$(old_project_name)\|$(old_package)" pubspec.yaml && FOUND=1 || echo "    ✔ clean"; \
	\
	echo "$(BLUE)  → Dart imports (lib/ + test/)$(NC)"; \
	DART_HITS=$$(grep -rn "package:$(old_project_name)/" lib test 2>/dev/null); \
	if [ -n "$$DART_HITS" ]; then \
		echo "$(RED)$$DART_HITS$(NC)" | head -10; \
		FOUND=1; \
	else echo "    ✔ clean"; fi; \
	\
	echo "$(BLUE)  → Android build.gradle.kts$(NC)"; \
	GRADLE_HITS=$$(grep -n "$(old_package)\|$(old_project_name)" android/app/build.gradle.kts 2>/dev/null); \
	if [ -n "$$GRADLE_HITS" ]; then \
		echo "$(RED)$$GRADLE_HITS$(NC)"; FOUND=1; \
	else echo "    ✔ clean"; fi; \
	\
	echo "$(BLUE)  → Android Kotlin source$(NC)"; \
	KT_HITS=$$(grep -rn "$(old_package)\|$(old_project_name)" android/app/src/main/kotlin 2>/dev/null); \
	if [ -n "$$KT_HITS" ]; then \
		echo "$(RED)$$KT_HITS$(NC)"; FOUND=1; \
	else echo "    ✔ clean"; fi; \
	\
	echo "$(BLUE)  → iOS Info.plist$(NC)"; \
	PLIST_HITS=$$(grep -n "$(old_package)\|$(old_project_name)" ios/Runner/Info.plist 2>/dev/null); \
	if [ -n "$$PLIST_HITS" ]; then \
		echo "$(RED)$$PLIST_HITS$(NC)"; FOUND=1; \
	else echo "    ✔ clean"; fi; \
	\
	echo "$(BLUE)  → iOS project.pbxproj$(NC)"; \
	PBXPROJ_HITS=$$(grep -n "$(old_package)\|$(old_project_name)" ios/Runner.xcodeproj/project.pbxproj 2>/dev/null); \
	if [ -n "$$PBXPROJ_HITS" ]; then \
		echo "$(RED)$$PBXPROJ_HITS$(NC)" | head -10; FOUND=1; \
	else echo "    ✔ clean"; fi; \
	\
	echo ""; \
	if [ "$$FOUND" = "1" ]; then \
		echo "$(RED)❌ Rename incomplete — traces found above$(NC)"; exit 1; \
	else \
		echo "$(GREEN)✔ No traces of old name found$(NC)"; \
	fi
	@echo "$(BLUE)🔬 Running flutter analyze...$(NC)"
	@$(FLUTTER) analyze --no-fatal-infos && echo "$(GREEN)✔ analyze passed$(NC)" || (echo "$(RED)❌ analyze failed$(NC)"; exit 1)
	@echo "$(GREEN)🎉 Validation passed! Project is clean.$(NC)"

clean_cache:
	@echo "$(BLUE)🧹 Cleaning old project traces and caches...$(NC)"
	@$(FLUTTER) clean
	@$(FLUTTER) pub get
	@rm -rf android/app/.cxx/ .idea/ coverage/ build/
	@rm -f *.iml android/*.iml
	@echo "$(GREEN)✔ Cache cleaned successfully!$(NC)"

# ─────────────────────────────────────────────────────────────────────────────
# init — one command to turn this boilerplate into a fresh project.
#   make init project_name=my_app package_name=com.company.myapp app_name="My App"
# ─────────────────────────────────────────────────────────────────────────────
SKELETON_DIR := tool/skeleton

init:
	@if [ -z "$(project_name)" ] || [ -z "$(package_name)" ]; then \
		echo "$(RED)❌ Usage: make init project_name=my_app package_name=com.company.myapp app_name=\"My App\"$(NC)"; \
		exit 1; \
	fi
	@echo "$(BLUE)🚀 Bootstrapping a new app from the boilerplate...$(NC)"
	@$(MAKE) init_skeleton FROM_INIT=1
	@$(MAKE) rename project_name=$(project_name) package_name=$(package_name) app_name="$(app_name)"
	@echo "$(BLUE)🧹 Removing skeleton templates (no boilerplate traces left)...$(NC)"
	@rm -rf $(SKELETON_DIR)
	@rmdir tool 2>/dev/null || true
	@$(MAKE) clean_cache
	@echo "$(BLUE)🔬 Verifying project compiles...$(NC)"
	@$(FLUTTER) analyze --no-fatal-infos && echo "$(GREEN)✔ analyze passed$(NC)" || (echo "$(RED)❌ analyze failed — please review$(NC)"; exit 1)
	@$(MAKE) reset_git
	@echo "$(GREEN)🎉 New app '$(project_name)' is ready to build on!$(NC)"
	@$(MAKE) info

# Remove example features (country / favourite / search) and install a minimal
# Home + Setting skeleton from tool/skeleton. One-shot — run via init.
init_skeleton:
	@if [ "$(FROM_INIT)" != "1" ]; then \
		echo "$(RED)❌ 'init_skeleton' is an internal step — it must run via 'make init'.$(NC)"; \
		echo "$(BLUE)   Use: make init project_name=my_app package_name=com.company.myapp app_name=\"My App\"$(NC)"; \
		exit 1; \
	fi
	@if [ ! -d "$(SKELETON_DIR)" ]; then \
		echo "$(RED)❌ $(SKELETON_DIR) not found. 'init_skeleton' is a one-shot step and was already applied.$(NC)"; \
		exit 1; \
	fi
	@echo "$(BLUE)🗑️  Removing example features (country / favourite / search)...$(NC)"
	@rm -rf \
		lib/data/datasource/country \
		lib/data/datasource/favourite \
		lib/data/mappers \
		lib/data/models/country \
		lib/data/repositories/country \
		lib/data/repositories/favourite \
		lib/domain/entities \
		lib/domain/repositories/country \
		lib/domain/repositories/favourite \
		lib/domain/use_cases/country \
		lib/domain/use_cases/favourite \
		lib/presentation/features/country \
		lib/presentation/features/favourite \
		lib/presentation/features/search \
		test/data/datasource/country \
		test/data/datasource/favourite \
		test/data/mappers \
		test/data/repositories/country \
		test/data/repositories/favourite \
		test/domain/use_cases/country \
		test/domain/use_cases/favourite \
		test/presentation/features
	@echo "$(BLUE)📝 Installing minimal Home + Setting skeleton...$(NC)"
	@cp $(SKELETON_DIR)/app_routes.dart.tmpl       lib/presentation/router/app_routes.dart
	@cp $(SKELETON_DIR)/app_router.dart.tmpl        lib/presentation/router/app_router.dart
	@cp $(SKELETON_DIR)/main_home_screen.dart.tmpl  lib/presentation/features/main_home/main_home_screen.dart
	@cp $(SKELETON_DIR)/home_screen.dart.tmpl       lib/presentation/features/home/home_screen.dart
	@cp $(SKELETON_DIR)/storage_keys.dart.tmpl      lib/core/constants/storage_keys.dart
	@cp $(SKELETON_DIR)/api_endpoint.dart.tmpl      lib/data/datasource/http/api_endpoint.dart
	@cp $(SKELETON_DIR)/app_config.dart.tmpl        lib/core/config/app_config.dart
	@cp $(SKELETON_DIR)/en-US.json                  assets/translations/en-US.json
	@cp $(SKELETON_DIR)/vi-VN.json                  assets/translations/vi-VN.json
	@cp $(SKELETON_DIR)/ja-JP.json                  assets/translations/ja-JP.json
	@cp $(SKELETON_DIR)/README.md                   README.md
	@echo "$(GREEN)✔ Example features removed, skeleton installed$(NC)"

# Wipe boilerplate git history and start fresh with a single 'Initial commit'.
# Destructive — asks for confirmation. Skipped if you don't type 'yes'.
reset_git:
	@echo "$(RED)⚠️  This DELETES the existing git history and re-initializes the repo.$(NC)"
	@printf "Type 'yes' to reset git history (anything else skips): "; \
	read ans; \
	if [ "$$ans" = "yes" ]; then \
		rm -rf .git; \
		(git init -q -b main 2>/dev/null || git init -q); \
		git add -A; \
		git commit -q -m "Initial commit"; \
		echo "$(GREEN)✔ Fresh git history created on branch '$$(git branch --show-current)'$(NC)"; \
	else \
		echo "$(BLUE)↩ Skipped git reset — boilerplate history kept.$(NC)"; \
	fi
