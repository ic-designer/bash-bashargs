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
### Changed
- README.md updated to describe downloading release archives with `curl` and untaring instead
  of `cloning` with git.
### Deprecated
### Fixed
### Security


## [0.2.1] - 2024-01-08
### Added
- Code usage snippet now included in the readme.
### Changed
- Shared makefile utilities are now cloned from the Boxerbird repo
### Fixed
- Corrected issue with GitHub workflow where make target were not properly ran by calling each
  make target as a seperate command.
### Security


## [0.2.0] - 2024-01-08
### Added
- Added an `install` target to standardize the usage of the library
- GitHub workflow expanded to call targets `check`, `test`, `install`, `uninstall`
### Changed
- Renamed the Makefile from `makefile` to `Makefile`
- Reorganized the structure of the Makefile
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
