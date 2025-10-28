#!/usr/bin/env python3

import os
import sys
import tempfile
import unittest
from unittest.mock import patch, MagicMock, mock_open
from pathlib import Path

sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "scripts"))

from detect_env import EnvironmentDetector


class TestEnvironmentDetector(unittest.TestCase):
    def setUp(self):
        self.detector = EnvironmentDetector(debug=False)

    def test_detect_os_darwin(self):
        with patch("platform.system", return_value="Darwin"):
            self.assertEqual(self.detector.detect_os(), "darwin")

    def test_detect_os_linux(self):
        with patch("platform.system", return_value="Linux"):
            self.assertEqual(self.detector.detect_os(), "linux")

    def test_detect_os_other(self):
        with patch("platform.system", return_value="Windows"):
            self.assertEqual(self.detector.detect_os(), "windows")

    def test_detect_distro_macos(self):
        with patch.object(self.detector, "detect_os", return_value="darwin"):
            self.assertEqual(self.detector.detect_distro(), "macos")

    def test_detect_distro_arch(self):
        os_release_content = 'ID=arch\nNAME="Arch Linux"\n'
        with patch("pathlib.Path.exists", return_value=True):
            with patch("builtins.open", mock_open(read_data=os_release_content)):
                detector = EnvironmentDetector()
                detector._os_release_cache = None
                with patch.object(detector, "detect_os", return_value="linux"):
                    self.assertEqual(detector.detect_distro(), "arch")

    def test_detect_distro_ubuntu(self):
        os_release_content = 'ID=ubuntu\nNAME="Ubuntu"\n'
        with patch("pathlib.Path.exists", return_value=True):
            with patch("builtins.open", mock_open(read_data=os_release_content)):
                detector = EnvironmentDetector()
                detector._os_release_cache = None
                with patch.object(detector, "detect_os", return_value="linux"):
                    self.assertEqual(detector.detect_distro(), "ubuntu")

    def test_detect_distro_fedora(self):
        os_release_content = 'ID=fedora\nNAME="Fedora"\n'
        with patch("pathlib.Path.exists", return_value=True):
            with patch("builtins.open", mock_open(read_data=os_release_content)):
                detector = EnvironmentDetector()
                detector._os_release_cache = None
                with patch.object(detector, "detect_os", return_value="linux"):
                    self.assertEqual(detector.detect_distro(), "fedora")

    def test_detect_distro_unknown(self):
        with patch("pathlib.Path.exists", return_value=False):
            with patch.object(self.detector, "detect_os", return_value="linux"):
                self.assertEqual(self.detector.detect_distro(), "unknown")

    def test_detect_hostname_success(self):
        mock_result = MagicMock()
        mock_result.returncode = 0
        mock_result.stdout = "my-computer\n"
        
        with patch("subprocess.run", return_value=mock_result):
            self.assertEqual(self.detector.detect_hostname(), "my-computer")

    def test_detect_hostname_fallback(self):
        mock_result_fail = MagicMock()
        mock_result_fail.returncode = 1
        mock_result_fail.stdout = ""
        
        mock_result_success = MagicMock()
        mock_result_success.returncode = 0
        mock_result_success.stdout = "fallback-hostname\n"
        
        with patch("subprocess.run", side_effect=[mock_result_fail, mock_result_success]):
            self.assertEqual(self.detector.detect_hostname(), "fallback-hostname")

    def test_detect_hostname_failure(self):
        mock_result = MagicMock()
        mock_result.returncode = 1
        mock_result.stdout = ""
        
        with patch("subprocess.run", return_value=mock_result):
            self.assertEqual(self.detector.detect_hostname(), "unknown")

    def test_detect_hostname_exception(self):
        with patch("subprocess.run", side_effect=Exception("Test exception")):
            self.assertEqual(self.detector.detect_hostname(), "unknown")

    def test_detect_all_macos(self):
        with patch.object(self.detector, "detect_os", return_value="darwin"):
            with patch.object(self.detector, "detect_distro", return_value="macos"):
                with patch.object(self.detector, "detect_hostname", return_value="klaxon"):
                    os_type, distro, hostname = self.detector.detect()
                    self.assertEqual(os_type, "darwin")
                    self.assertEqual(distro, "macos")
                    self.assertEqual(hostname, "klaxon")

    def test_detect_all_arch(self):
        with patch.object(self.detector, "detect_os", return_value="linux"):
            with patch.object(self.detector, "detect_distro", return_value="arch"):
                with patch.object(self.detector, "detect_hostname", return_value="siku"):
                    os_type, distro, hostname = self.detector.detect()
                    self.assertEqual(os_type, "linux")
                    self.assertEqual(distro, "arch")
                    self.assertEqual(hostname, "siku")

    def test_to_env_dict(self):
        with patch.object(self.detector, "detect_os", return_value="linux"):
            with patch.object(self.detector, "detect_distro", return_value="arch"):
                with patch.object(self.detector, "detect_hostname", return_value="siku"):
                    env_dict = self.detector.to_env_dict()
                    self.assertEqual(env_dict["DOTFILES_OS"], "linux")
                    self.assertEqual(env_dict["DOTFILES_DISTRO"], "arch")
                    self.assertEqual(env_dict["DOTFILES_HOSTNAME"], "siku")

    def test_os_release_parsing(self):
        os_release_content = (
            'NAME="Arch Linux"\n'
            'ID=arch\n'
            'ID_LIKE=archlinux\n'
            'VERSION_CODENAME=rolling\n'
        )
        with patch("pathlib.Path.exists", return_value=True):
            with patch("builtins.open", mock_open(read_data=os_release_content)):
                detector = EnvironmentDetector()
                detector._os_release_cache = None
                parsed = detector._read_os_release()
                self.assertEqual(parsed.get("ID"), "arch")
                self.assertEqual(parsed.get("NAME"), "Arch Linux")

    def test_debug_output(self):
        detector = EnvironmentDetector(debug=True)
        with patch.object(detector, "detect_os", return_value="linux"):
            with patch.object(detector, "detect_distro", return_value="arch"):
                with patch.object(detector, "detect_hostname", return_value="siku"):
                    with patch("sys.stderr"):
                        detector.detect()


class TestEnvironmentDetectorIntegration(unittest.TestCase):
    def test_detect_current_system(self):
        detector = EnvironmentDetector()
        os_type, distro, hostname = detector.detect()
        
        self.assertIn(os_type, ["darwin", "linux"])
        self.assertIsNotNone(distro)
        self.assertIsNotNone(hostname)
        
        if os_type == "darwin":
            self.assertEqual(distro, "macos")
        elif os_type == "linux":
            self.assertIn(distro, ["arch", "ubuntu", "fedora", "debian", "centos", "rhel", "unknown"])

    def test_env_dict_completeness(self):
        detector = EnvironmentDetector()
        env_dict = detector.to_env_dict()
        
        self.assertIn("DOTFILES_OS", env_dict)
        self.assertIn("DOTFILES_DISTRO", env_dict)
        self.assertIn("DOTFILES_HOSTNAME", env_dict)
        self.assertTrue(all(isinstance(v, str) for v in env_dict.values()))


if __name__ == "__main__":
    unittest.main()
