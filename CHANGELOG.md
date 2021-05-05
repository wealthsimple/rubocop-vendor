# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## master (unreleased)

## 0.7.1 - 2021-04-16
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
