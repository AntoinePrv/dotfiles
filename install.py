#!/usr/bin/env python3
# coding: utf-8

"""This script install all the configuration files for the user."""

import argparse
import logging
import os
import pathlib
import shutil
import sys


logger = logging.getLogger(__name__)

HOME_DIR = pathlib.Path(os.environ["HOME"]).resolve()
PROJECT_DIR = pathlib.Path(__file__).parent.resolve()


def prompt_install_files(
    source: pathlib.Path,
    dest: pathlib.Path,
    dry_run: bool = True,
    symlinks: bool = True,
) -> None:
    # Deal with previous file
    if dest.exists():
        answer = input(f"File {dest} already exists. Replace? [y/n]")
        override = answer.lower().strip().startswith("y")
        if not override:
            return
        if not dry_run:
            if symlinks:
                if override:
                    if dest.is_symlink() or dest.is_file():
                        dest.unlink()
                    else:
                        shutil.rmtree(dest)
            else:
                raise NotImplementedError()
                # shutil.move()
    # Dangling symlink
    elif dest.is_symlink():
        if not dry_run:
            dest.unlink()

    # Finally install file
    if not dry_run:
        dest.symlink_to(source)
    logger.info(f"Installed {dest}.")


def run_nvim_cmd(*cmds: str) -> None:
    cmd_str = " ".join(f"+'{cmd}'" for cmd in cmds)
    os.system(f"nvim -n {cmd_str} +'qa!' &> /dev/null")


def nvim_generate_files() -> None:
    # Make sur all nvim deps are installed
    run_nvim_cmd("PlugUpgrade", "PlugInstall --sync", "PlugUpdate --sync")
    logger.info("Installed nvim packages.")

    # TODO make a prompt for existing file, factor the prompt from different commands
    for name in ("default-prompt", "tmux-prompt"):
        vim_script = PROJECT_DIR / f"bash/{name}.vim"
        sh_script = PROJECT_DIR / f"bash/{name}.sh"
        run_nvim_cmd(f"source {vim_script}", f"PromptlineSnapshot {sh_script}")
        logger.info(f"Generated file {sh_script}.")


def main(dry_run: bool = True) -> None:
    # target -> source
    installs = {
        HOME_DIR / ".config/bash": PROJECT_DIR / "bash",
        HOME_DIR / ".bashrc": HOME_DIR / ".config/bash/bashrc",
        HOME_DIR / ".bash_profile": HOME_DIR / ".config/bash/bashrc",
        HOME_DIR / ".config/nvim": PROJECT_DIR / "nvim",
        HOME_DIR / ".config/tmux": PROJECT_DIR / "tmux",
        HOME_DIR / ".tmux.conf": HOME_DIR / ".config/tmux/tmux.conf",
        HOME_DIR / ".config/git": PROJECT_DIR / "git",
        HOME_DIR / ".local/share/base16": PROJECT_DIR / "base16",
        HOME_DIR / ".config/misc": PROJECT_DIR / "misc",
        HOME_DIR / ".inputrc": HOME_DIR / ".config/misc/inputrc",
    }
    for dest, source in installs.items():
        prompt_install_files(source=source, dest=dest, dry_run=dry_run)

    nvim_generate_files()


if __name__ == "__main__":
    # Parse program options
    parser = argparse.ArgumentParser(
        description="Install all the config files for the user."
    )
    parser.add_argument(
        "--dry-run",
        "-n",
        help="Show steps without executing.",
        default=False,
        action="store_true",
    )
    args = parser.parse_args()

    # Define logging as printing
    logging.basicConfig(level=logging.INFO, stream=sys.stdout, format="%(message)s")

    # Run the install
    main(**vars(args))
