#!/usr/bin/env python3.11

import pglast
import sys
import argparse


def get_parsed_args():
    parser = argparse.ArgumentParser(
        prog="sql-pretty.py",
        description="prettifies a postgres sql file",
    )
    parser.add_argument(
        "files",
        nargs="*",
        help="the file to prettify, use '-' or leave empty for stdin",
    )

    return parser.parse_args()

def find_line(s: str, location: int):
    cur = 0
    for i, line in enumerate(s.split('\n')):
        if cur <= location <= cur + len(line):
            return i + 1
        cur += len(line) + 1
    return 0


def main():
    args = get_parsed_args()

    files = list(set(args.files))
    if files == []:
        files.append("-")

    for file in files:
        s = ""
        if file == "-":
            for line in sys.stdin:
                s += line
        else:
            with open(file, "r") as f:
                s = f.read()

        # options:
        # https://pglast.readthedocs.io/en/v5/stream.html#pglast.stream.RawStream
        try:
            pretty = pglast.prettify(
                s,
                preserve_comments=True,
                semicolon_after_last_statement=True
            )
            print(pretty)
        except pglast.parser.ParseError as e:
            line = 0
            if len(e.args) > 1:
                location = e.args[1]
                line = find_line(s, location)
            print(f"{e} at line {line}", file=sys.stderr)


if __name__ == "__main__":
    main()
