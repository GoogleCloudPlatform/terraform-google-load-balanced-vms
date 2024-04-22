# Changelog

All notable changes to this project will be documented in this file.

The format is based on
[Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to
[Semantic Versioning](https://semver.org/spec/v2.0.0.html).
This changelog is generated automatically based on [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/).

## [0.4.0](https://github.com/GoogleCloudPlatform/terraform-google-load-balanced-vms/compare/v0.3.1...v0.4.0) (2024-04-22)


### ⚠ BREAKING CHANGES

* **deps:** Update Terraform terraform-google-modules/network/google to v9 ([#75](https://github.com/GoogleCloudPlatform/terraform-google-load-balanced-vms/issues/75))
* **deps:** Update TF modules (major) ([#59](https://github.com/GoogleCloudPlatform/terraform-google-load-balanced-vms/issues/59))

### Features

* add support for make it mine and deploy via cloudbuild trigger … ([#80](https://github.com/GoogleCloudPlatform/terraform-google-load-balanced-vms/issues/80)) ([691c8ce](https://github.com/GoogleCloudPlatform/terraform-google-load-balanced-vms/commit/691c8ced11ef495f3d8680fec8f507ed0540fd40))
* Test 2 nodes instead of 3 ([#78](https://github.com/GoogleCloudPlatform/terraform-google-load-balanced-vms/issues/78)) ([f561d65](https://github.com/GoogleCloudPlatform/terraform-google-load-balanced-vms/commit/f561d6511e86ca80b7b8b1a28501b26d48ee00ca))


### Bug Fixes

* **deps:** update cft/developer-tools docker tag to v1.14 ([#54](https://github.com/GoogleCloudPlatform/terraform-google-load-balanced-vms/issues/54)) ([b297fb7](https://github.com/GoogleCloudPlatform/terraform-google-load-balanced-vms/commit/b297fb7ed33e90374e1e7115d35e8a3e11efdafb))
* **deps:** Update cft/developer-tools Docker tag to v1.16 ([#60](https://github.com/GoogleCloudPlatform/terraform-google-load-balanced-vms/issues/60)) ([f6d588e](https://github.com/GoogleCloudPlatform/terraform-google-load-balanced-vms/commit/f6d588e3d08ed528b107234bacd244ce103cb79c))
* **deps:** Update cft/developer-tools Docker tag to v1.17 ([#64](https://github.com/GoogleCloudPlatform/terraform-google-load-balanced-vms/issues/64)) ([f99a708](https://github.com/GoogleCloudPlatform/terraform-google-load-balanced-vms/commit/f99a70855d8e497c9a0d905690a6dd55953e533d))
* **deps:** Update Terraform terraform-google-modules/network/google to v9 ([#75](https://github.com/GoogleCloudPlatform/terraform-google-load-balanced-vms/issues/75)) ([5d46349](https://github.com/GoogleCloudPlatform/terraform-google-load-balanced-vms/commit/5d4634931cc1cec0054136335859bfd8142cb648))
* **deps:** Update TF modules (major) ([#59](https://github.com/GoogleCloudPlatform/terraform-google-load-balanced-vms/issues/59)) ([92cfa87](https://github.com/GoogleCloudPlatform/terraform-google-load-balanced-vms/commit/92cfa87a067a44c5a00ecd9a4a31457dc994cc67))

## [0.3.0](https://github.com/GoogleCloudPlatform/terraform-google-load-balanced-vms/compare/v0.2.0...v0.3.0) (2023-07-20)


### Features

* adds metadata autogen and validation ([#42](https://github.com/GoogleCloudPlatform/terraform-google-load-balanced-vms/issues/42)) ([6db3bcf](https://github.com/GoogleCloudPlatform/terraform-google-load-balanced-vms/commit/6db3bcfcfa84b8b2231d1db4c34923f1d5e8798c))


### Bug Fixes

* **deps:** update cft/developer-tools docker tag to v1.13 ([#49](https://github.com/GoogleCloudPlatform/terraform-google-load-balanced-vms/issues/49)) ([c480378](https://github.com/GoogleCloudPlatform/terraform-google-load-balanced-vms/commit/c4803783bb225bd620677f2e384c4ee1fe92c893))
* **deps:** update tf modules ([#28](https://github.com/GoogleCloudPlatform/terraform-google-load-balanced-vms/issues/28)) ([6bdf211](https://github.com/GoogleCloudPlatform/terraform-google-load-balanced-vms/commit/6bdf211da6febb394ecf21c164fc6636dbc3bba7))
* Update int.cloudbuild.yaml to use LR billing ([#50](https://github.com/GoogleCloudPlatform/terraform-google-load-balanced-vms/issues/50)) ([4ad4337](https://github.com/GoogleCloudPlatform/terraform-google-load-balanced-vms/commit/4ad4337cb8ad903fbe64b6b46d0aee528c1ec00a))

## [0.2.0](https://github.com/GoogleCloudPlatform/terraform-google-load-balanced-vms/compare/v0.1.4...v0.2.0) (2023-05-18)


### Features

* add link to in-console tour of solution ([#38](https://github.com/GoogleCloudPlatform/terraform-google-load-balanced-vms/issues/38)) ([e25a977](https://github.com/GoogleCloudPlatform/terraform-google-load-balanced-vms/commit/e25a977d24fbf9fb343e1fd62d746a5d57a196ef))
* wait for lb to start serving ([#40](https://github.com/GoogleCloudPlatform/terraform-google-load-balanced-vms/issues/40)) ([33b0cfc](https://github.com/GoogleCloudPlatform/terraform-google-load-balanced-vms/commit/33b0cfcb1a5f7847d3b1283395888f9d636be131))


### Bug Fixes

* updating node count max to allow for bigger audience. ([#43](https://github.com/GoogleCloudPlatform/terraform-google-load-balanced-vms/issues/43)) ([42f9a2a](https://github.com/GoogleCloudPlatform/terraform-google-load-balanced-vms/commit/42f9a2a0c0c2a4e122a360e67b4fb6a8b32272c5))

## [0.1.4](https://github.com/GoogleCloudPlatform/terraform-google-load-balanced-vms/compare/v0.1.3...v0.1.4) (2023-03-29)


### Bug Fixes

* resizing the output solution ([#35](https://github.com/GoogleCloudPlatform/terraform-google-load-balanced-vms/issues/35)) ([3a90f59](https://github.com/GoogleCloudPlatform/terraform-google-load-balanced-vms/commit/3a90f59bc6d268079136f6e4177b89185df9bfcb))

## [0.1.3](https://github.com/GoogleCloudPlatform/terraform-google-load-balanced-vms/compare/v0.1.2...v0.1.3) (2023-03-16)


### Bug Fixes

* altered exemplar to prevent whole solution from failing.  ([#32](https://github.com/GoogleCloudPlatform/terraform-google-load-balanced-vms/issues/32)) ([9a92168](https://github.com/GoogleCloudPlatform/terraform-google-load-balanced-vms/commit/9a92168cac7bc7c6be5f34f048dae381d80391c5))

## [0.1.2](https://github.com/GoogleCloudPlatform/terraform-google-load-balanced-vms/compare/v0.1.1...v0.1.2) (2023-02-01)


### Bug Fixes

* respond to a number of issues to get module working with SIC ([#22](https://github.com/GoogleCloudPlatform/terraform-google-load-balanced-vms/issues/22)) ([9e0ad2b](https://github.com/GoogleCloudPlatform/terraform-google-load-balanced-vms/commit/9e0ad2b64a5cf5f67e3dfae48c9360e357551a48))
* Update variables.tf to correct minor typos ([#20](https://github.com/GoogleCloudPlatform/terraform-google-load-balanced-vms/issues/20)) ([2e9463e](https://github.com/GoogleCloudPlatform/terraform-google-load-balanced-vms/commit/2e9463eb950fee50381070c1b8bef931f21e22ac))

## [0.1.1](https://github.com/GoogleCloudPlatform/terraform-google-load-balanced-vms/compare/v0.1.0...v0.1.1) (2022-11-10)


### Bug Fixes

* adding labels to managed instances ([7ae1515](https://github.com/GoogleCloudPlatform/terraform-google-load-balanced-vms/commit/7ae15155eb23d49ba150814656d816dccc10e416))

## 0.1.0 (2022-08-11)


### Bug Fixes

* making versioning work correclty. ([fb063ca](https://github.com/GoogleCloudPlatform/terraform-google-load-balanced-vms/commit/fb063ca97c56bbb651addb2a7ba56f200399b19c)), closes [#2](https://github.com/GoogleCloudPlatform/terraform-google-load-balanced-vms/issues/2)

## [0.1.0](https://github.com/terraform-google-modules/terraform-google-load-balanced-vms/releases/tag/v0.1.0) - 20XX-YY-ZZ

### Features

- Initial release

[0.1.0]: https://github.com/terraform-google-modules/terraform-google-load-balanced-vms/releases/tag/v0.1.0
