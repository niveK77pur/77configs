#!/usr/bin/env python3

# pyright: standard

"""
This is a simple script, that removes the padding introduced by the
Supernote when exporting PDF documents.

For example, when you open a portrait A4 document on the Manta and
re-export the document, you will obtain a new PDF that is wider than A4.
Reason being that the Manta has space to the left and right of the page to
make it fit onto the screen.

It turns out that the Supernote adds the padding in a very predictable
manner, by using a negative value to offset the bounding box to include
the extra margins on the screen.
"""

import sys

from pypdf import PdfReader, PdfWriter
import argparse
import pathlib


def get_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        prog=sys.argv[0],
        description="Remove Supernote PDF padding",
    )

    parser.add_argument(
        "-i",
        "--input",
        required=True,
        type=pathlib.Path,
        help="Input PDF from which to remove padding",
    )
    parser.add_argument(
        "-o",
        "--output",
        required=False,
        type=pathlib.Path,
        help="Destination for cropped PDF (default: <input>-cropped.pdf)",
    )

    args = parser.parse_args()

    if args.output is None:
        input = pathlib.Path(args.input)
        args.output = input.parent / f"{input.stem}-cropped{input.suffix}"

    return args


def main():
    args = get_args()
    reader = PdfReader(args.input)
    writer = PdfWriter()

    for i, page in enumerate(reader.pages):
        if not (page.mediabox.left < 0):
            print(f"No padding detected for page {i}. Aborting.")
            return
        page.mediabox.upper_right = (
            page.mediabox.right - abs(page.mediabox.left),
            page.mediabox.top,
        )
        page.mediabox.lower_left = (0, 0)

        # page.cropbox.upper_right = page.mediabox.upper_right
        # page.cropbox.lower_left = page.mediabox.lower_left

        writer.add_page(page)

    writer.write(args.output)
    print(f"Output written to: {args.output}")


if __name__ == "__main__":
    main()
