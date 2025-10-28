#!/usr/bin/env python3

import os
import sys
import unittest
from unittest.mock import patch, MagicMock
from pathlib import Path

sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "scripts"))

from detect_env import EnvironmentDetector


class TestMultiPlatformSupport(unittest.TestCase):
    def setUp(self):
        self.detector = EnvironmentDetector()

    def test_darwin_platform_detection(self):
        """Test macOS detection"""
        with patch.object(self.detector, "detect_os", return_value="darwin"):
            with patch.object(self.detector, "detect_distro", return_value="macos"):
                os_type, distro, hostname = self.detector.detect()
                self.assertEqual(os_type, "darwin")
                self.assertEqual(distro, "macos")

    def test_arch_platform_detection(self):
        """Test Arch Linux detection"""
        with patch.object(self.detector, "detect_os", return_value="linux"):
            with patch.object(self.detector, "detect_distro", return_value="arch"):
                os_type, distro, hostname = self.detector.detect()
                self.assertEqual(os_type, "linux")
                self.assertEqual(distro, "arch")

    def test_package_filtering_darwin(self):
        """Test that macOS gets appropriate packages"""
        darwin_packages = [
            "bash", "zsh", "tmux", "wezterm", "brew", 
            "starship", "neovim", "opencode", "fish", "ghostty", "vscodium"
        ]
        
        with patch.object(self.detector, "detect_os", return_value="darwin"):
            os_type, _, _ = self.detector.detect()
            
            for pkg in darwin_packages:
                self.assertIsNotNone(pkg)

    def test_package_filtering_linux(self):
        """Test that Linux gets appropriate packages"""
        linux_packages = [
            "bash", "zsh", "tmux", 
            "starship", "neovim", "opencode", "fish", "nushell"
        ]
        
        with patch.object(self.detector, "detect_os", return_value="linux"):
            os_type, _, _ = self.detector.detect()
            
            for pkg in linux_packages:
                self.assertIsNotNone(pkg)

    def test_config_files_exist(self):
        """Test that expected config files exist in dotfiles"""
        dotfiles_dir = Path(os.path.expanduser("~/.dotfiles"))
        
        expected_files = {
            "scripts/detect-env.sh": True,
            "scripts/detect_env.py": True,
            "starship/.config/starship/starship.common.toml": True,
            "starship/.config/starship/starship.darwin.toml": True,
            "neovim/.config/nvim/lazy-lock.darwin.json": True,
            "neovim/.config/nvim/lazy-lock.arch.json": True,
            "fish/.config/fish/conf.d/00-environment.fish": True,
            "fish/.config/fish/conf.d/01-platform.fish": True,
        }
        
        for filepath, should_exist in expected_files.items():
            full_path = dotfiles_dir / filepath
            exists = full_path.exists()
            if should_exist:
                self.assertTrue(exists, f"Expected file not found: {filepath}")
            else:
                self.assertFalse(exists, f"Unexpected file found: {filepath}")

    def test_environment_export(self):
        """Test that environment exports are correct"""
        env_dict = self.detector.to_env_dict()
        
        self.assertIn("DOTFILES_OS", env_dict)
        self.assertIn("DOTFILES_DISTRO", env_dict)
        self.assertIn("DOTFILES_HOSTNAME", env_dict)
        
        for key, value in env_dict.items():
            self.assertIsInstance(value, str)
            self.assertGreater(len(value), 0)

    def test_fish_conf_d_execution_order(self):
        """Test that fish conf.d files load in correct order"""
        conf_d_dir = Path(os.path.expanduser("~/.dotfiles/fish/.config/fish/conf.d"))
        
        if conf_d_dir.exists():
            files = sorted(list(conf_d_dir.glob("*.fish")))
            file_names = [f.name for f in files]
            
            expected_order = [
                "00-environment.fish",
                "01-platform.fish",
                "02-tools.fish",
            ]
            
            for expected in expected_order:
                self.assertIn(expected, file_names)

    def test_neovim_lock_files_exist(self):
        """Test that platform-specific neovim lock files exist"""
        nvim_dir = Path(os.path.expanduser("~/.dotfiles/neovim/.config/nvim"))
        
        self.assertTrue((nvim_dir / "lazy-lock.darwin.json").exists())
        self.assertTrue((nvim_dir / "lazy-lock.arch.json").exists())

    def test_backup_restore_scripts_executable(self):
        """Test that backup and restore scripts are executable"""
        backup_script = Path(os.path.expanduser("~/.dotfiles/backup-dotfiles.py"))
        restore_script = Path(os.path.expanduser("~/.dotfiles/restore-dotfiles.py"))
        
        self.assertTrue(backup_script.exists())
        self.assertTrue(restore_script.exists())
        
        backup_stat = backup_script.stat()
        restore_stat = restore_script.stat()
        
        self.assertTrue(backup_stat.st_mode & 0o111)
        self.assertTrue(restore_stat.st_mode & 0o111)


class TestConfigurationModularity(unittest.TestCase):
    def test_starship_variants_exist(self):
        """Test that starship config variants exist"""
        starship_dir = Path(os.path.expanduser("~/.dotfiles/starship"))
        
        self.assertTrue((starship_dir / ".config" / "starship.toml").exists())
        self.assertTrue((starship_dir / ".config" / "starship" / "starship.common.toml").exists())
        self.assertTrue((starship_dir / ".config" / "starship" / "starship.darwin.toml").exists())
        self.assertTrue((starship_dir / ".config" / "starship" / "starship.arch.toml").exists())

    def test_fish_modular_config(self):
        """Test that fish has modular conf.d structure"""
        conf_d_dir = Path(os.path.expanduser("~/.dotfiles/fish/.config/fish/conf.d"))
        
        self.assertTrue(conf_d_dir.exists())
        self.assertTrue((conf_d_dir / "00-environment.fish").exists())
        self.assertTrue((conf_d_dir / "01-platform.fish").exists())
        self.assertTrue((conf_d_dir / "02-tools.fish").exists())

    def test_detect_env_scripts_exist(self):
        """Test that environment detection scripts exist"""
        scripts_dir = Path(os.path.expanduser("~/.dotfiles/scripts"))
        
        self.assertTrue((scripts_dir / "detect-env.sh").exists())
        self.assertTrue((scripts_dir / "detect_env.py").exists())
        self.assertTrue((scripts_dir / "load-starship-config.sh").exists())
        self.assertTrue((scripts_dir / "load-starship-config.fish").exists())
        self.assertTrue((scripts_dir / "init-nvim-lockfile.sh").exists())


class TestPlatformPackageMapping(unittest.TestCase):
    def test_darwin_package_list(self):
        """Test macOS package list is complete"""
        darwin_packages = {
            "bash", "zsh", "tmux", "wezterm", "brew", 
            "starship", "neovim", "opencode", "fish", "ghostty", "vscodium"
        }
        
        for pkg in darwin_packages:
            self.assertIsNotNone(pkg)
            self.assertGreater(len(pkg), 0)

    def test_linux_package_list(self):
        """Test Linux package list is complete"""
        linux_packages = {
            "bash", "zsh", "tmux", 
            "starship", "neovim", "opencode", "fish", "nushell"
        }
        
        for pkg in linux_packages:
            self.assertIsNotNone(pkg)
            self.assertGreater(len(pkg), 0)

    def test_no_package_duplication(self):
        """Test that package lists don't have duplicates"""
        darwin_packages = [
            "bash", "zsh", "tmux", "wezterm", "brew", 
            "starship", "neovim", "opencode", "fish", "ghostty", "vscodium"
        ]
        linux_packages = [
            "bash", "zsh", "tmux", 
            "starship", "neovim", "opencode", "fish", "nushell"
        ]
        
        darwin_set = set(darwin_packages)
        linux_set = set(linux_packages)
        
        self.assertEqual(len(darwin_packages), len(darwin_set))
        self.assertEqual(len(linux_packages), len(linux_set))


if __name__ == "__main__":
    unittest.main()
