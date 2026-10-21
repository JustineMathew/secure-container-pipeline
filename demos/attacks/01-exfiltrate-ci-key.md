# Attack 01: Exfiltrate CI credentials via a pull request

## Threat
T-01: long-lived AWS key, exposed to every step on pull request builds.

## Method
A PR adds a step that base64-encodes the AWS secret and prints it.
GitHub masks the raw secret in logs, but not an encoded form of it.
The attacker reads the encoded value from the PR run logs and decodes
it on their own machine.

## Why it works
- The key never expires, so a leak is permanent until manually revoked.
- Secrets are exposed at job level, so PR builds can read them.
- A disguised one-line change passed without review (`gh pr diff` catches it).

## Result
(filled in after running)

## Mitigation
Phase 1: OIDC federation — no static key exists to steal; tokens are
short-lived and scoped to the repo. Plus least-privilege permissions
and not exposing deploy secrets to PR builds.
