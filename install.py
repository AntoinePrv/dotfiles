#!/usr/bin/env python3
# coding: utf-8

"""This script install all the configuration files for the user."""

import abc
import argparse
import logging
import os
import pathlib
import shutil
import sys
from typing import Optional


HOME_DIR = pathlib.Path(os.environ["HOME"]).resolve()
CONFIG_DIR = pathlib.Path(
    os.environ.get("XDG_CONFIG_HOME", HOME_DIR / ".config")
).resolve()
DATA_DIR = pathlib.Path(
    os.environ.get("XDG_DATA_HOME", HOME_DIR / ".local/share")
).resolve()
PROJECT_DIR = pathlib.Path(__file__).parent.resolve()


class Action(abc.ABC):
    """An installation action.

    Global Attributes
    -----------------
    logger:
        The logger used for reporting.
    replace_all:
        If true, always erase targets, if false never erase targets, if none
        prompt when targets exist.
    dry_run:
        If true, actuall install is never performed.

    """

    logger = logging.getLogger(__name__)
    replace_all: Optional[bool] = None
    dry_run: bool = False

    def __init__(self, replace_prompt: str, report_message: str) -> None:
        """Inialize required attributes.

        Parameters
        ----------
        replace_prompt:
            Replacement prompt shown if target exists.
        report_message:
            Report message for an installation.

        """
        self.replace_prompt = replace_prompt
        self.report_message = report_message

    @abc.abstractmethod
    def exists(self) -> bool:
        """Return wether the installation target already exists."""
        ...

    @abc.abstractmethod
    def install(self) -> None:
        """Perform the actual installation.

        Erase existing targets if required.
        """
        ...

    def replace(self) -> bool:
        """Decide to replace existing target based on user input."""
        if Action.replace_all is None:
            answer = input(f"{self.replace_prompt} Replace? [y/n]")
            return answer.lower().strip().startswith("y")
        else:
            return Action.replace_all

    def run(self) -> None:
        """Execute the Action.

        Perform all checks and overrides.
        """
        if (not self.exists()) or self.replace():
            if not Action.dry_run:
                self.install()
            Action.logger.info(self.report_message)


class FilesInstall(Action):
    def __init__(self, source: pathlib.Path, dest: pathlib.Path) -> None:
        super().__init__(
            replace_prompt=f"Location {dest} already exists.",
            report_message=f"Instaled {dest}.",
        )
        self.source = source
        self.dest = dest

    def exists(self) -> bool:
        """Return wether the installation target already exists."""
        return self.dest.exists() or self.dest.is_symlink()

    def install(self) -> None:
        """Install the target files."""
        if self.dest.is_symlink() or self.dest.is_file():
            self.dest.unlink()
        elif self.dest.is_dir():
            shutil.rmtree(self.dest)
        self.dest.symlink_to(self.source)


def run_nvim_cmd(*cmds: str) -> None:
    """Run commands in nvim."""
    cmd_str = " ".join(f"+'{cmd}'" for cmd in cmds)
    os.system(f"nvim -n {cmd_str} +'qa!' &> /dev/null")


class UpdateNvimPackages(Action):
    def __init__(self) -> None:
        super().__init__(
            replace_prompt="Nvim packages already installed.",
            report_message="Updated nvim packages.",
        )

    def exists(self) -> bool:
        """Return false."""
        return False

    def install(self) -> None:
        """Update nvim package manager and packages."""
        run_nvim_cmd("PlugUpgrade", "PlugInstall --sync", "PlugUpdate --sync")


class NvimGenerateLine(Action, abc.ABC):
    def __init__(self, script: pathlib.Path, dest: pathlib.Path) -> None:
        super().__init__(
            replace_prompt=f"Location {dest} already exists.",
            report_message=f"Generated file {dest}.",
        )
        self.script = script
        self.dest = dest

    def exists(self) -> bool:
        """Return wether the installation target already exists."""
        return self.dest.exists() or self.dest.is_symlink()

    @abc.abstractmethod
    def install(self) -> None:
        """Perform the actual installation."""
        ...


class NvimGeneratePromptline(NvimGenerateLine):
    def install(self) -> bool:
        """Generate promptline bash prompt."""
        run_nvim_cmd(f"source {self.script}", f"PromptlineSnapshot! {self.dest}")


class NvimGenerateTmuxline(NvimGenerateLine):
    def install(self) -> bool:
        """Generate tmuxline tmux conf."""
        run_nvim_cmd(
            f"source {self.script}", "Tmuxline", f"TmuxlineSnapshot! {self.dest}"
        )


def main() -> None:
    # fmt: off
    installs = [
        FilesInstall(source=PROJECT_DIR/"bash", dest=CONFIG_DIR/"bash"),
        FilesInstall(source=CONFIG_DIR/"bash/bashrc", dest=HOME_DIR/".bashrc"),
        FilesInstall(source=CONFIG_DIR/"bash/bashrc", dest=HOME_DIR/".bash_profile"),
        FilesInstall(source=PROJECT_DIR/"nvim", dest=CONFIG_DIR/"nvim"),
        FilesInstall(source=PROJECT_DIR/"tmux", dest=CONFIG_DIR/"tmux"),
        FilesInstall(source=CONFIG_DIR/"tmux/tmux.conf", dest=HOME_DIR/".tmux.conf"),
        FilesInstall(source=PROJECT_DIR/"git", dest=CONFIG_DIR/"git"),
        FilesInstall(source=PROJECT_DIR/"base16", dest=DATA_DIR/"base16"),
        FilesInstall(source=PROJECT_DIR/"misc", dest=CONFIG_DIR/"misc"),
        FilesInstall(source=CONFIG_DIR/"misc/inputrc", dest=HOME_DIR/".inputrc"),
        UpdateNvimPackages(),
        NvimGeneratePromptline(
            script=PROJECT_DIR/"bash/default-prompt.vim",
            dest=CONFIG_DIR/"bash/default-prompt.sh"
        ),
        NvimGeneratePromptline(
            script=PROJECT_DIR/"bash/tmux-prompt.vim",
            dest=CONFIG_DIR/"bash/tmux-prompt.sh"
        ),
        NvimGenerateTmuxline(
            script=PROJECT_DIR/"tmux/tmuxline.vim",
            dest=CONFIG_DIR/"tmux/tmuxline.tmux"
        ),
    ]
    # fmt: on

    for action in installs:
        action.run()


if __name__ == "__main__":
    # Parse program options
    parser = argparse.ArgumentParser(
        description="Install all the config files for the user."
    )
    parser.add_argument(
        "--dry-run",
        "-n",
        help="Show steps without executing.",
        dest="dry_run",
        default=False,
        action="store_true",
    )
    args = parser.parse_args()
    Action.dry_run = args.dry_run

    # Define logging as printing
    logging.basicConfig(level=logging.INFO, stream=sys.stdout, format="%(message)s")

    # Run the install
    main()
