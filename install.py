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
BIN_DIR = HOME_DIR / ".local/bin"
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
            report_message=f"Installed {dest}.",
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
        if self.source.is_dir():
            self.dest.mkdir(parents=True)
            for source_p in self.source.glob("**/*"):
                dest_p = self.dest / source_p.relative_to(self.source)
                if source_p.is_dir():
                    dest_p.mkdir(parents=True)
                else:
                    dest_p.symlink_to(source_p)
        else:
            self.dest.symlink_to(self.source)


def run_nvim_cmd(*cmds: str) -> None:
    """Run commands in nvim."""
    cmd_str = " ".join(f"+'silent {cmd}'" for cmd in cmds)
    os.system(f"nvim -n --headless {cmd_str} +'qa!'")


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
        run_nvim_cmd("autocmd User PackerComplete quitall", "PackerSync")


class NvimGenerateFile(Action, abc.ABC):
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


class NvimGeneratePromptline(NvimGenerateFile):
    def install(self) -> None:
        """Generate promptline prompt."""
        run_nvim_cmd(f"source {self.script}", f"PromptlineSnapshot! {self.dest}")


class NvimGenerateTmuxline(NvimGenerateFile):
    def install(self) -> None:
        """Generate tmuxline tmux conf."""
        run_nvim_cmd(
            f"source {self.script}", "Tmuxline", f"TmuxlineSnapshot! {self.dest}"
        )


def main() -> None:
    # fmt: off
    installs = [
        FilesInstall(source=PROJECT_DIR/"bin", dest=BIN_DIR),
        FilesInstall(source=PROJECT_DIR/"shell", dest=CONFIG_DIR/"shell"),
        FilesInstall(source=CONFIG_DIR/"shell/profile", dest=HOME_DIR/".profile"),
        FilesInstall(source=CONFIG_DIR/"shell/bashrc", dest=HOME_DIR/".bashrc"),
        FilesInstall(source=CONFIG_DIR/"shell/zshrc", dest=HOME_DIR/".zshrc"),
        FilesInstall(source=PROJECT_DIR/"nvim", dest=CONFIG_DIR/"nvim"),
        FilesInstall(source=PROJECT_DIR/"tmux", dest=CONFIG_DIR/"tmux"),
        FilesInstall(source=CONFIG_DIR/"tmux/tmux.conf", dest=HOME_DIR/".tmux.conf"),
        FilesInstall(source=PROJECT_DIR/"git", dest=CONFIG_DIR/"git"),
        FilesInstall(source=PROJECT_DIR/"misc", dest=CONFIG_DIR/"misc"),
        FilesInstall(source=PROJECT_DIR/"misc/alacritty.yml", dest=CONFIG_DIR/"alacritty/alacritty.yml"),
        FilesInstall(source=PROJECT_DIR/"misc/ipython", dest=CONFIG_DIR/"ipython"),
        FilesInstall(source=CONFIG_DIR/"misc/inputrc", dest=HOME_DIR/".inputrc"),
        FilesInstall(source=CONFIG_DIR/"misc/editrc", dest=HOME_DIR/".editrc"),
        FilesInstall(source=CONFIG_DIR/"misc/condarc", dest=HOME_DIR/".condarc"),
        FilesInstall(source=PROJECT_DIR/"misc/clangd.yaml", dest=CONFIG_DIR/"clangd/config.yaml"),
        UpdateNvimPackages(),
        NvimGeneratePromptline(
            script=PROJECT_DIR/"shell/default-prompt.vim",
            dest=CONFIG_DIR/"shell/default-prompt.sh"
        ),
        NvimGeneratePromptline(
            script=PROJECT_DIR/"shell/tmux-prompt.vim",
            dest=CONFIG_DIR/"shell/tmux-prompt.sh"
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
    parser.add_argument(
        "--yes",
        "-y",
        help="Always replace existing installation targets",
        dest="replace_all",
        action="store_const",
        const=True,
    )
    args = parser.parse_args()
    Action.dry_run = args.dry_run
    Action.replace_all = args.replace_all

    # Define logging as printing
    logging.basicConfig(level=logging.INFO, stream=sys.stdout, format="%(message)s")

    # Run the install
    main()
