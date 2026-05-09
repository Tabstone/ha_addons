import importlib.util
import unittest
from pathlib import Path


SCRIPT = Path(__file__).resolve().parents[1] / ".github" / "scripts" / "sync_upstream.py"
spec = importlib.util.spec_from_file_location("sync_upstream", SCRIPT)
sync_upstream = importlib.util.module_from_spec(spec)
spec.loader.exec_module(sync_upstream)


class SyncUpstreamTests(unittest.TestCase):
    def test_select_latest_semver_tag_ignores_sha_tags(self):
        tags = ["sha-cdb12a9", "latest", "v1.3.0", "v1.10.0", "nightly"]

        self.assertEqual(sync_upstream.select_latest_semver_tag(tags), "v1.10.0")

    def test_find_latest_dockerhub_tag_scans_past_sha_only_first_page(self):
        pages = {
            "first": {
                "next": "second",
                "results": [
                    {"name": "sha-cdb12a9"},
                    {"name": "sha-aaaaaaaa"},
                    {"name": "latest"},
                ],
            },
            "second": {
                "next": None,
                "results": [
                    {"name": "v1.2.9"},
                    {"name": "v1.3.0"},
                ],
            },
        }

        def fetch_json(url):
            return pages["first" if url.startswith("https://") else url]

        self.assertEqual(
            sync_upstream.find_latest_dockerhub_tag("1467078763/metapi", fetch_json),
            "v1.3.0",
        )

    def test_find_latest_dockerhub_tag_returns_empty_when_no_semver_tag_exists(self):
        def fetch_json(url):
            return {
                "next": None,
                "results": [
                    {"name": "sha-cdb12a9"},
                    {"name": "latest"},
                ],
            }

        self.assertEqual(
            sync_upstream.find_latest_dockerhub_tag("1467078763/metapi", fetch_json),
            "",
        )


if __name__ == "__main__":
    unittest.main()
