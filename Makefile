##
# Copyright 2024 Charles Y. Choi
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

## Requirements
# - Python 3.11+
# - GNU awk 5.3+
# - Python semver
# - Bash

PACKAGE_EL=cc-isearch-menu.el

TIMESTAMP := $(shell /bin/date "+%Y%m%d_%H%M%S")
PACKAGE_VERSION := $(shell ./scripts/read-version.sh $(PACKAGE_EL))
# BUMP_LEVEL: major|minor|patch|prerelease|build
BUMP_LEVEL=patch
PACKAGE_VERSION_BUMP := $(shell python -m semver bump $(BUMP_LEVEL) $(PACKAGE_VERSION))

.PHONY: tests \
create-pr \
bump \
checkout-development \
checkout-main \
sync-development-with-main \
create-merge-development-branch \
create-pr \
create-release-pr \
create-release-tag


## Run test regression
tests:
	$(MAKE) -C tests tests

## Bump Patch Version
bump: checkout-development
	sed -i 's/;; Version: $(PACKAGE_VERSION)/;; Version: $(PACKAGE_VERSION_BUMP)/' $(PACKAGE_EL)
	git commit -m 'Bump version to $(PACKAGE_VERSION_BUMP)' $(PACKAGE_EL)
	git push

checkout-development:
	git checkout development
	git branch --set-upstream-to=origin/development development
	git fetch origin --prune
	git pull

checkout-main:
	git checkout main
	git branch --set-upstream-to=origin/main main
	git fetch origin --prune
	git pull

sync-development-with-main: checkout-main checkout-development
	git merge main

create-merge-development-branch: checkout-development
	git checkout -b merge-development-to-main-$(TIMESTAMP)
	git push --set-upstream origin merge-development-to-main-$(TIMESTAMP)

## Create GitHub pull request for development
create-pr:
	gh pr create --base development --fill

## Create GitHub pull request for release
create-release-pr: create-merge-development-branch bump
	gh pr create --base main \
--title "Merge development to main $(TIMESTAMP)" \
--fill-verbose

create-release-tag: checkout-main
	git tag $(PACKAGE_VERSION)
	git push origin $(PACKAGE_VERSION)

create-gh-release:
	gh release create -t v$(PACKAGE_VERSION) --notes-from-tag $(PACKAGE_VERSION)
