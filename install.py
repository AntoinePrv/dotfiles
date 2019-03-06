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


def prompt_install(
    source: pathlib.Path,
    dest: pathlib.Path,
    dry_run: bool = True,
    symlinks: bool = True
) -> None:
    # Deal with previous file
    if dest.exists():
        answer = input(f"File {dest.name} already exists. Replace? [y/n]")
        override = answer.lower().strip().startswith("y")
        if not override:
            return
        if not dry_run:
            if symlinks:
                if override:
                    if dest.is_symlink():
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


def main(
    dry_run: bool = True,
) -> None:
    installs = {
        HOME_DIR/".bashrc": PROJECT_DIR/"bash/bashrc",
        HOME_DIR/".bash_profile": PROJECT_DIR/"bash/bashrc",
        HOME_DIR/".config/bash": PROJECT_DIR/"bash",
    }
    for dest, source in installs.items():
        prompt_install(source=source, dest=dest, dry_run=dry_run)


if __name__ == "__main__":
    # Parse program options
    parser = argparse.ArgumentParser(
        description="Install all the config files for the user.")
    parser.add_argument(
        "--dry-run", "-n",
        help="Show steps without executing.",
        default=False,
        action="store_true")
    args = parser.parse_args()

    # Define logging as printing
    logging.basicConfig(
        level=logging.INFO, stream=sys.stdout, format="%(message)s")

    # Run the install
    main(**vars(args))
