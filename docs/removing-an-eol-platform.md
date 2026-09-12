# Removing an end of life platform

The checklist for dropping a platform when it reaches end of life. The
goal is to stop testing and supporting it while keeping its configuration
usable for people who still run it.

## Key tenet: do not break existing users

- **Hiera data moves, it is not deleted**: `git mv` the platform's data
  file from `data/` to `examples/hiera/eol/<OS>/<release>.yaml`. Users on
  the EOL platform copy it into their own Hiera hierarchy to keep the
  module working.
- **Class parameters and manifest code paths that the EOL data depends on
  are kept**, documented as end of life compatibility (see `pam_conf_file`
  and `other_file` in `manifests/init.pp`). Removing them would turn a
  soft deprecation into a hard compile failure.

## 1. metadata.json

Remove the release from the `operatingsystemrelease` array; remove the OS
entry entirely when no releases remain (a versionless entry would expand
the unit test matrix to every release facterdb knows).

## 2. Hiera data

Move the data file to `examples/hiera/eol/` as described above. Remove
hiera.yaml hierarchy levels only when nothing else uses them.

## 3. Spec coverage

Remove the platform's branches from `spec/spec_platforms.rb` and any
platform conditionals in the spec files. Traps: local variables assigned
only in removed branches, and pinned test blocks that reference a removed
release (facterdb may drop its facts and the block silently runs zero
examples).

## 4. Test fixtures

Remove the platform's `spec/fixtures/<os_id>-pam_*` files.

## 5. Acceptance

Remove the nodeset and the CI acceptance matrix entry.

## 6. README

Move the platform from the supported list to the "May work" list, which
points at `examples/hiera/eol`.

## 7. Verify

```sh
bundle exec rake parallel_spec
```

Expect the example count to **drop** by the removed platform's share with
0 failures and 100% resource coverage. Run the CI validate chain and push.
