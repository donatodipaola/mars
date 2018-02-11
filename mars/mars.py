#!/usr/bin/env python

from cli import *
from builder import *


def mars():
    cli = CommandLineInterface()

    if not cli.parse():
        sys.exit(1)

    cli.display_title()

    logger = Logger(cli.verbose_flag, cli.log_flag)
    builder = Builder(logger)

    simulation = builder.build_from_file(cli.file_name)
    if simulation:
        simulation.run(logger)


if __name__ == "__main__":
    mars()


