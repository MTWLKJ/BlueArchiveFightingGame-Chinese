"""Compare what the game asked to translate with what the table holds.

The game collects every English string Loc.t() could not find (see --dump-missing in scripts/core/loc.gd);
this script diffs that list against assets/locale/zh_cn.json and prints what still needs a line.

    python tools/loc_coverage.py <missing.txt> [--table assets/locale/zh_cn.json]
"""
import argparse
import io
import json
import os

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("missing")
    ap.add_argument("--table", default=os.path.join(ROOT, "assets", "locale", "zh_cn.json"))
    args = ap.parse_args()

    table = json.load(io.open(args.table, encoding="utf-8"))
    with io.open(args.missing, encoding="utf-8") as f:
        asked = [line.rstrip("\n") for line in f if line.strip()]

    todo = [s for s in asked if s not in table]
    print("asked: %d   in the table: %d   still English: %d" % (len(asked), len(asked) - len(todo), len(todo)))
    for s in todo:
        print("  " + s)


if __name__ == "__main__":
    main()
