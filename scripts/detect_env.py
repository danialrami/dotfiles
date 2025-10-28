#!/usr/bin/env python3

import os
import sys
import platform
import subprocess
from pathlib import Path


class EnvironmentDetector:
    def __init__(self, debug=False):
        self.debug = debug
        self._os_release_cache = None

    def detect_os(self):
        system = platform.system().lower()
        if system == "darwin":
            return "darwin"
        elif system == "linux":
            return "linux"
        else:
            return system

    def _read_os_release(self):
        if self._os_release_cache is not None:
            return self._os_release_cache

        self._os_release_cache = {}
        os_release_path = Path("/etc/os-release")

        if not os_release_path.exists():
            return self._os_release_cache

        try:
            with open(os_release_path) as f:
                for line in f:
                    line = line.strip()
                    if not line or line.startswith("#"):
                        continue
                    if "=" in line:
                        key, value = line.split("=", 1)
                        self._os_release_cache[key] = value.strip('"')
        except Exception:
            pass

        return self._os_release_cache

    def detect_distro(self):
        os_type = self.detect_os()

        if os_type == "darwin":
            return "macos"

        os_release = self._read_os_release()
        distro_id = os_release.get("ID", "unknown")

        distro_map = {
            "arch": "arch",
            "ubuntu": "ubuntu",
            "fedora": "fedora",
            "debian": "debian",
            "centos": "centos",
            "rhel": "rhel",
        }

        return distro_map.get(distro_id, distro_id)

    def detect_hostname(self):
        try:
            result = subprocess.run(
                ["hostname", "-s"], capture_output=True, text=True, check=False
            )
            if result.returncode == 0:
                hostname = result.stdout.strip()
                if hostname:
                    return hostname

            result = subprocess.run(
                ["hostname"], capture_output=True, text=True, check=False
            )
            if result.returncode == 0:
                hostname = result.stdout.strip()
                if hostname:
                    return hostname
        except Exception:
            pass

        return "unknown"

    def detect(self):
        os_type = self.detect_os()
        distro = self.detect_distro()
        hostname = self.detect_hostname()

        if self.debug:
            print(
                f"[dotfiles-env] OS: {os_type}, Distro: {distro}, Hostname: {hostname}",
                file=sys.stderr,
            )

        return os_type, distro, hostname

    def to_env_dict(self):
        os_type, distro, hostname = self.detect()
        return {
            "DOTFILES_OS": os_type,
            "DOTFILES_DISTRO": distro,
            "DOTFILES_HOSTNAME": hostname,
        }


def main():
    debug = os.environ.get("DOTFILES_DEBUG", "0") == "1"
    detector = EnvironmentDetector(debug=debug)
    os_type, distro, hostname = detector.detect()

    print(f"DOTFILES_OS={os_type}")
    print(f"DOTFILES_DISTRO={distro}")
    print(f"DOTFILES_HOSTNAME={hostname}")


if __name__ == "__main__":
    main()
