# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

```markdown
## [Unreleased] - YYYY-MM-DD
### Added
### Changed
### Deprecated
### Fixed
### Security
```

## [Unreleased] - YYYY-MM-DD
### Added
- Increased the verbosity of the github workflow commands.
### Changed
- Waxwing tests no longer use recursive make to test on an installed directory, but
  instead will test the built bashargs library itself.
- Waxwing builds test file in a target specific named directory.
- Test files renamed to use hyphens instead of underscores.
- Wrapped bowerbird macros with `ifdef` statements to avoid undefined variable warnings
  with recursive make.
- Removed the output suppression statements
- Updated the `bowerbird-deps` and `bowerbird-test` calls to the new syntax.
### Deprecated
### Fixed
- Marked the installed files as `.PRECIOUS` to avoid deletion when using recursive make
  for installation.
- Fixed the uninstall tests so that they actually try to uninstall a previous install.
  The tests didn't do anything meaningful before.
- Quoted strings in the variable value expressions in the installer tests that were
  causing errors on the ubuntu remote runner.
- Commands referencing a URL are now a single line to prevent errors when called as a
  dependency of another repo.
- Updated the github checkout action from v3 to v4 to fix deprecated node 16 warning.
- All the Makefile tests are run in the unique working directory.
### Security
- Removed the unnecessary SSH keys secret from the workflow file.


## [0.3.4] - 2024-06-07
### Added
- Added descriptions to the make targets for `make help`.
- Added more tests to address repeated argument calls.
- Added the flag `--warn-undefined-variable` to `MAKEFLAGS`.
### Changed
- The repo now uses the bowerbird tools to manage makefile related tests and create
  test targets.
### Fixed
- The test runner is now stricter about undefined variables and will fail test if an
  undefined variable is encountered during the test.


## [0.3.3] - 2024-02-16
### Added
- Added defaults for optional value arguments.


## [0.3.2] - 2024-02-09
### Fixed
- Fixed bash argument passing to allow quoted strings with spaces as arguments.


## [0.3.1] - 2024-01-16
### Added
- Improved the verbosity of the Makefile targets to help indicate when targets are completed.
- Created tests for the Makefile installation path variables.
### Changed
- Moved variables out of the primary Makefile and into private.mk to simplify the Makefile itself.


## [0.3.0] - 2024-01-10
### Added
- The version for boxerbird and waxwing can be controlled using the Makefile variables
  `BOXERBIRD_BRANCH` and `WAXWING_BRANCH`.
### Changed
- README.md updated to describe downloading release archives with `curl` and untaring instead
  of `cloning` with git.
- The Makefile variable WORKDIR_ROOT can now be overidden on the command line.
- Build dependencies are now populated under `$(WORKDIR_ROOT)/deps/`.
- Build artifacts are now populated under `$(WORKDIR_ROOT)/build/`.
- Test artifacts are now populated under`$(WORKDIR_ROOT)/test/`.
### Fixed
- Corrected issue with GitHub workflow where make target were not properly ran by calling each
  make target as a seperate command.


## [0.2.1] - 2024-01-08
### Added
- Code usage snippet now included in the readme.
### Changed
- Shared makefile utilities are now cloned from the Boxerbird repo.
### Fixed
- Corrected issue with GitHub workflow where make target were not properly ran by calling each
  make target as a seperate command.
### Security


## [0.2.0] - 2024-01-08
### Added
- Added an `install` target to standardize the usage of the library.
- GitHub workflow expanded to call targets `check`, `test`, `install`, `uninstall`.
### Changed
- Renamed the Makefile from `makefile` to `Makefile`.
- Reorganized the structure of the Makefile.
- Updated Makefile variables names to maintain consistency with other similar repos.


## [0.1.1] - 2023-12-30
### Fixed
- Updated the Changelog for the 0.1.0 and 0.1.1 releases.


## [0.1.0] - 2023-12-30
### Added
- Library of functions to parse named command line arguments.
- Test scripts
- Makefile to build and run tests
- GitHub workflow to perform automated testing
