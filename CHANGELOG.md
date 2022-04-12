# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## 0.8.7 - 2022-04-12
### Changed
- Close stale PRs in 60 days

## 0.8.6 - 2022-04-11
### Changed
- Updated dependencies

## 0.8.5 - 2022-04-04
### Changed
- Updated dependencies

## 0.8.4 - 2022-03-28
### Changed
- Updated dependencies

## 0.8.3 - 2022-02-22
### Changed
- Updated dependencies

## 0.8.2 - 2022-02-14
### Changed
- Updated dependencies

## 0.8.1 - 2022-02-02
### Changed
- Updated dependencies

## 0.8.0 - 2021-12-31
### Changed
- Add Ruby 3 support

## 0.7.1 - 2021-12-06
### Changed
- Updated dependencies

## 0.7.0 - 2021-11-29
### Changed
- Disallow usage of the recursive-open-struct gem and its classes.

## 0.6.1 - 2021-04-16
### Changed
- Updated dependencies
- Migrate CI from CircleCI to GitHub Actions
- Change default GitHub branch to `main`
- Bump required ruby version to 2.7

## 0.6.0 - 2021-03-10

- Fix specs, make them work with latest Rubocop rules. ([@cabello][])

## 0.5.0 - 2019-05-13

- `RollbarInsideRescue` accepts `ActiveSupport::Rescuable#rescue_from` as a valid rescue block. ([@marcotc][])

## 0.4.0 - 2019-05-13

- Fix #6: Introduce `Vendor/RollbarInsideRescue`. ([@cabello][])

## 0.3.0 - 2019-04-25

- More conservative detection and auto-correction for RollbarLogger. ([@cabello][])
- Introduce auto-correction for RollbarLog. ([@cabello][])

## 0.2.1 - 2019-04-25

### Added

- Spec that checks version was bumped and changelog entry is present. ([@cabello][])

## 0.2.0 - 2019-04-23

### Added

- Introduce `Vendor/RollbarLog` cop. ([@cabello][])

## 0.1.0 - 2019-04-23

### Added

- Introduce `Vendor/RollbarInterpolation` cop. ([@cabello][])
- Introduce `Vendor/RollbarLogger` cop. ([@cabello][])
- Introduce `Vendor/RollbarWithException` cop. ([@cabello][])

[@cabello]: https://github.com/cabello
[@marcotc]: https://github.com/marcotc
