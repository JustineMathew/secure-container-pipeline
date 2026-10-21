# Attack 01: Exfiltrate CI credentials via a pull request

## Threat
T-01: long-lived AWS key, exposed to every step on pull request builds.
T-02: mutable ECR tags, trusted on deploy.

## Method
A PR added a step that base64-encoded the AWS secret and printed it.
GitHub masks the raw secret in logs, but not an encoded form of it.
The attacker read the encoded value from the PR run logs, decoded it
on their own machine, and used it to overwrite a trusted image tag.

## Why it works
- The key never expires, so a leak is permanent until manually revoked.
- Secrets are exposed at job level, so PR builds can read them.
- A disguised one-line change ("Run tests") passed without review.
- The scoped policy blocked recon (describe) but not the damage (push),
  and the registry URL is derivable from the public account ID.

## Result
- Secret leaked via base64, slipping past GitHub's log mask.
- Decoded on a laptop; authenticated as user/github-ci-baseline with
  no login or MFA.
- Overwrote tag c7a1491: the ~1 GB real Go image was replaced with a
  3.6 MB attacker image (verified: imageSizeInBytes = 3,626,984).
- ArgoCD, which trusts tags, would have deployed the attacker image.
- Leaked key revoked immediately (incident response).

## Mitigation
Phase 1: OIDC federation — no static key exists to steal; tokens are
short-lived and scoped to the repo/branch. Plus least-privilege
permissions, and not exposing deploy credentials to PR builds.
Phase 2: immutable tags + signing/provenance so a swapped image is
rejected even if pushed.
