import argparse
import os
import sys

__version__ = "0.4.1"


def printline(depth: int, string: str, is_folder: bool, color: bool):
    cs = "\033[0;31m" if color and is_folder else ""
    ce = "\033[0m" if color and is_folder else ""
    print(" ." + str(depth) + " " + cs + string.replace("_", "\\_") + ce + ".")


def generate(
    path: str,
    current_dir: str,
    current_depth: int,
    max_depth: int,
    *,
    hidden: bool = False,
    ignore: set = set(),
    color: bool = False,
    dots: bool = True,
):
    # get directory data
    items = os.listdir(path)
    dirs = []
    files = []
    for item in items:
        if (not hidden and item.startswith(".")) or item in ignore:
            continue

        if os.path.isfile(os.path.join(path, item)):
            files.append(item)
        else:
            dirs.append(item)

    dirs.sort()
    files.sort()

    # print current directory
    printline(current_depth, current_dir, True, color)

    # print directories
    for d in dirs:
        if current_depth < max_depth:
            # descend
            generate(
                os.path.join(path, d),
                d,
                current_depth + 1,
                max_depth,
                color=color,
                ignore=ignore,
            )
        else:
            # only print names
            printline(current_depth + 1, d, True, color)
            if dots:
                printline(current_depth + 2, "\\dots", False, color)

    # print directory files
    for f in files:
        printline(current_depth + 1, f, False, color)


def main(argv=None):
    parser = argparse.ArgumentParser(
        prog="latex-dirtree-gen",
        allow_abbrev=False,
        formatter_class=argparse.ArgumentDefaultsHelpFormatter,
    )
    # Terminating arguments
    parser.add_argument(
        "-v",
        "--version",
        action="version",
        version="%(prog)s " + __version__,
    )
    # Required arguments
    parser.add_argument(
        "directory",
        help="project root",
        default=".",
    )
    # Optional arguments
    parser.add_argument(
        "-i",
        "--ignore",
        help="comma separated list of directories and files to be ignored",
        default="",
    )
    parser.add_argument(
        "-H",
        "--include-hidden",
        help='show files and directories starting with "."',
        action="store_true",
    )
    parser.add_argument(
        "-d",
        "--depth",
        help="how many directories should the program descend",
        type=int,
        default=5,
    )
    parser.add_argument(
        "--color",
        help="in stdout, draw directories in red (with no effect on generated LaTeX code)",
        action="store_true",
    )
    parser.add_argument(
        "--dots",
        help='draw "\\dots" inside folders at depth limit',
        action="store_true",
    )
    args = parser.parse_args()

    #

    if args.depth < 1:
        print("Depth has to be at least one.", file=sys.stderr)
        sys.exit(1)

    #

    ignore = set(args.ignore.split(",")) if args.ignore is not None else set()

    print("\\dirtree{%")
    generate(
        args.directory,
        "",
        1,
        args.depth,
        hidden=args.include_hidden,
        ignore=ignore,
        color=args.color,
        dots=args.dots,
    )
    print("}")

    sys.exit(0)


if __name__ == "__main__":
    main(sys.argv)
