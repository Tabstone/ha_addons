#!/usr/bin/env python3
from __future__ import annotations

import json
import re
import sys
import urllib.request
from collections.abc import Callable, Iterable
from typing import Any


EXCLUDED_TAGS = {"latest", "dev", "nightly", "beta"}
SEMVER_RE = re.compile(r"^v?(\d+)\.(\d+)\.(\d+)$")


def parse_semver_tag(tag: str) -> tuple[int, int, int] | None:
    match = SEMVER_RE.match(tag)
    if not match:
        return None
    return tuple(int(part) for part in match.groups())


def select_latest_semver_tag(tags: Iterable[str]) -> str:
    candidates = []
    for tag in tags:
        if tag in EXCLUDED_TAGS or tag.startswith("sha-"):
            continue
        version = parse_semver_tag(tag)
        if version is not None:
            candidates.append((version, tag))
    return max(candidates, default=((0, 0, 0), ""))[1]


def fetch_json(url: str) -> dict[str, Any]:
    request = urllib.request.Request(url, headers={"User-Agent": "ha-addons-sync-upstream"})
    with urllib.request.urlopen(request, timeout=30) as response:
        return json.load(response)


def find_latest_dockerhub_tag(
    repo: str,
    fetch: Callable[[str], dict[str, Any]] = fetch_json,
    max_pages: int = 20,
) -> str:
    url = f"https://hub.docker.com/v2/repositories/{repo}/tags/?page_size=100&ordering=last_updated"
    tags: list[str] = []

    for _ in range(max_pages):
        data = fetch(url)
        tags.extend(
            result.get("name", "")
            for result in data.get("results", [])
            if isinstance(result.get("name"), str)
        )
        url = data.get("next")
        if not url:
            break

    return select_latest_semver_tag(tags)


def find_latest_github_tag(repo: str, fetch: Callable[[str], dict[str, Any] | list[Any]] = fetch_json) -> str:
    data = fetch(f"https://api.github.com/repos/{repo}/tags?per_page=100")
    if not isinstance(data, list):
        return ""
    tags = [item.get("name", "") for item in data if isinstance(item, dict)]
    return select_latest_semver_tag(tag for tag in tags if isinstance(tag, str))


def main(argv: list[str]) -> int:
    if len(argv) != 3 or argv[1] not in {"dockerhub-latest", "github-latest-tag"}:
        print("usage: sync_upstream.py {dockerhub-latest|github-latest-tag} <repo>", file=sys.stderr)
        return 2

    command, repo = argv[1], argv[2]
    try:
        if command == "dockerhub-latest":
            print(find_latest_dockerhub_tag(repo))
        else:
            print(find_latest_github_tag(repo))
    except Exception as exc:
        print(f"Unable to fetch latest tag for {repo}: {exc}", file=sys.stderr)
        print("")
    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv))
