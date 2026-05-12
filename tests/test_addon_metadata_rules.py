import re
import unittest


class AddonMetadataRulesTests(unittest.TestCase):
    def test_semver_version_still_allowed(self):
        version_re = re.compile(r"^(?:\d+\.\d+\.\d+-\d+|sha-\d+)$")
        self.assertRegex("1.3.0-1", version_re)

    def test_sha_version_should_be_allowed(self):
        version_re = re.compile(r"^(?:\d+\.\d+\.\d+-\d+|sha-\d+)$")
        self.assertRegex("sha-1", version_re)

    def test_sha_image_tag_should_be_allowed(self):
        tag_re = re.compile(r"^(?:v?\d+\.\d+\.\d+|sha-[0-9a-f]{7,40})$")
        self.assertRegex("sha-cdb12a9", tag_re)


if __name__ == "__main__":
    unittest.main()
