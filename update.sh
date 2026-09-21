#!/bin/sh
# Updates the ArchiDep tutor to its latest version: with `git pull` in a clone
# of its repository, or by downloading its files from GitHub otherwise.
# STUDENT.md is never touched.
set -eu

repo="ArchiDep/tutor"
raw="https://raw.githubusercontent.com/$repo/main"
files="AGENTS.md CLAUDE.md STUDENT.example.md update.sh"
dir=$(cd "$(dirname "$0")" && pwd -P)

# Only a clone of the tutor itself, not a repository the files were downloaded
# into, such as one of the student's own projects.
in_tutor_clone() {
  top=$(git -C "$dir" rev-parse --show-toplevel 2>/dev/null) || return 1
  [ "$top" = "$dir" ] || return 1
  git -C "$dir" remote get-url origin 2>/dev/null | grep -qi "$repo"
}

# `exec` replaces this script with Git: in a clone, nothing below runs, and a
# failed pull is reported as it is rather than followed by a download.
if command -v git >/dev/null 2>&1 && in_tutor_clone; then
  exec git -C "$dir" pull --ff-only
fi

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

# Everything is downloaded before anything is replaced, so a failed download
# leaves the previous version whole.
for file in $files; do
  curl -fsSL "$raw/$file" -o "$tmp/$file"
done

updated=0
for file in $files; do
  if ! cmp -s "$tmp/$file" "$dir/$file" 2>/dev/null; then
    # A rename, so that this script keeps reading its old copy while it runs.
    mv "$tmp/$file" "$dir/$file"
    echo "Updated $file"
    updated=1
  fi
done

if [ "$updated" -eq 0 ]; then
  echo "Already up to date."
fi
