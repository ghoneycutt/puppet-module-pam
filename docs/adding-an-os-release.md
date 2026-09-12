# Adding a new operating system release

The checklist for adding support for a new OS release. Work from the most
similar existing release and adjust for real differences.

## Key tenet: vanilla defaults only

The platform data in `data/` must reflect a **basic, vanilla install** of
the OS: exactly the PAM configuration the distribution ships, nothing more.
Never carry over settings from a contributor's own systems, site policies,
or hardening guides. Users layer their own choices on top via parameters
and Hiera. Every value in the data file must be traceable to the capture
below.

## 1. Capture the distribution defaults

Use the same container image the acceptance tests will use: the `image:`
key in the platform's nodeset under `spec/acceptance/nodesets/` (create the
nodeset first if needed, see step 6). Capture the shipped PAM files, for
example on Debian/Ubuntu:

```sh
docker run --rm debian:12 bash -c "export DEBIAN_FRONTEND=noninteractive; \
  apt-get update -qq >/dev/null; apt-get install -qq -y openssh-server >/dev/null; \
  for f in /etc/pam.d/common-* /etc/pam.d/login /etc/pam.d/sshd; do \
    echo \"===== \$f\"; grep -vE '^#|^\$' \$f; done"
```

On EL, install `openssh-server` with dnf and capture `/etc/pam.d/login`,
`/etc/pam.d/sshd`, `system-auth` and `password-auth`. Note that some
packages are minimal-container anomalies: check the package `Priority:`
before concluding a real install lacks a module referenced elsewhere.

## 2. Hiera data

Add the data file under `data/os/` (family path for EL and Suse, OS name
path for Debian and Ubuntu; see `hiera.yaml`), mirroring the capture.

## 3. metadata.json

Add the release to the OS's `operatingsystemrelease` array. This puts the
platform into the unit test matrix.

## 4. Spec coverage

Update the helper mappings in `spec/spec_platforms.rb` (package name,
common files, suffix, access defaults, links, group) if the new release
differs from its predecessor.

## 5. Test fixtures

Add `spec/fixtures/<os_id>-pam_*` files containing the module's **exact
rendered output** (the `os_id` is the on_supported_os name with
oraclelinux mapped to redhat). Start from the nearest sibling's fixtures
and adjust; the suite fails with a content diff when they are wrong.

## 6. Acceptance

Add the nodeset and the entry in the `.github/workflows/ci.yaml`
acceptance matrix.

## 7. README

Add the release to the supported list under Limitations.

## 8. Verify

```sh
bundle exec rake parallel_spec
```

The total example count must **increase**; if it did not, facterdb has no
facts for the release and the platform is silently skipped (grep the
output for "No facts were found"). All examples pass with 100% resource
coverage. Push and confirm the new acceptance job passes.
