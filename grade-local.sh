#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
default_image='ghcr.io/computer-organization-at-ncku-ee/co-lab2-grader-v2@sha256:f0ff938b7c554c1d021d5e91e31dfcbaeb810b88892dec6c0c404fac530b42db'
grader_image="$default_image"
output_dir="${LAB2_GRADE_OUTPUT:-$repo_root/grading-output}"
grade_owner="${LAB2_GRADE_OWNER:-local}"

if [[ ! "$grader_image" =~ @sha256:[0-9a-f]{64}$ ]]; then
    printf '%s\n' \
        'Lab 2 grader image has not been promoted yet.' \
        'Use the published template whose local wrapper is pinned by the TA.' >&2
    exit 64
fi
grader_digest="${grader_image##*@}"

if ! command -v docker >/dev/null 2>&1; then
    printf '%s\n' 'Docker is required for the local grader.' >&2
    exit 69
fi

commit='0000000000000000000000000000000000000000'
if command -v git >/dev/null 2>&1; then
    candidate="$(git -C "$repo_root" rev-parse --verify HEAD 2>/dev/null || true)"
    if [[ "$candidate" =~ ^[0-9a-fA-F]{40}$ ]]; then
        commit="$candidate"
    fi
fi

mkdir -p -- "$output_dir"
chmod 0700 -- "$output_dir"

docker run --rm \
    --platform linux/amd64 \
    --user root \
    --network none \
    --read-only \
    --cap-drop ALL \
    --cap-add CHOWN \
    --cap-add DAC_OVERRIDE \
    --cap-add SETGID \
    --cap-add SETUID \
    --cap-add SYS_CHROOT \
    --security-opt no-new-privileges \
    --pids-limit 64 \
    --memory 768m \
    --cpus 2 \
    --tmpfs /tmp:rw,nosuid,nodev,noexec,size=128m,mode=1777 \
    --tmpfs /opt/lab2-grader/sandbox-rootfs/work:rw,nosuid,nodev,noexec,size=128m,mode=0711 \
    --volume "$repo_root:/submission:ro" \
    --volume "$output_dir:/output:rw" \
    --env "LAB2_GRADER_IMAGE_DIGEST=$grader_digest" \
    "$grader_image" \
    bash -c '
        /usr/local/bin/grade-one "$@"
        status=$?
        shopt -s nullglob
        outputs=(/output/*.json)
        if (( ${#outputs[@]} > 0 )); then
            chmod 0644 -- "${outputs[@]}"
        fi
        exit "$status"
    ' lab2-grade-one \
        --submission /submission \
        --owner "$grade_owner" \
        --output-dir /output \
        --manifest lab2-v1 \
        --commit "$commit"

printf 'Lab 2 grading results: %s\n' "$output_dir"
