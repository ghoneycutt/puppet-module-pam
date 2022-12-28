# Contribution Guidelines

## Tests

  - Pull requests that add any additional functionality should have
    tests which cover the new feature to ensure it does what is
expected.

  - Pull requests with failing tests will not be merged.

  - Make use of [Vagrant](https://www.vagrantup.com/) for testing
    locally. Run `time ./tests/vagrant_test_all.sh ; echo $?` before
merging. This tests that the systems listed in the `Vagrantfile` can be
provisioned and SSH to them works.

## Features

  - Keep feature based PRs as small as possible, with as few commits as
    necessary. These are easier to review and will be merged quicker.

## Bug Fixes

  - Make sure you reference the issue you're closing with `Fixes #<issue
    number>`.

## Commits

  - Squash/rebase any commits where possible to reduce the noise in the PR

## Git commits

Reference the issue number, in the format `(GH-###)`.

```
(GH-901) Add support for foo
```

# Release process

1. update version in `metadata.json`
1. run `github_changelog_generator` with the version you updated in
   `metadata.json`.

    ```
    github_changelog_generator --user ghoneycutt --project puppet-module-pam \
      --since-tag v2.1.0 --exclude-tags-regex "v1" --future-release v3.4.0
    ```

1. Update `REFERENCE.md` with the command `pdk bundle exec rake strings:generate:reference`
1. Commit changes and push to master
1. Tag the new version, such as `git tag -a 'v2.0.0' -m 'v2.0.0'`
1. Push tags `git push --tags`
1. Update the puppet strings documentation with `pdk bundle exec rake strings:gh_pages:update`
