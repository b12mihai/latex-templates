#!/usr/bin/env bash
set -euo pipefail

INPUT_DIR="${1:-.}"

JPG_DIR="$INPUT_DIR/jpg_pages"
CLEAN_DIR="$INPUT_DIR/cleaned_pages"
MPX_DIR="$INPUT_DIR/mpx_out"

DPI=300
THRESHOLD="72%"

if command -v magick >/dev/null 2>&1; then
    IM="magick"
elif command -v convert >/dev/null 2>&1; then
    IM="convert"
else
    echo "Error: ImageMagick not found."
    echo "Install with: sudo apt install imagemagick"
    exit 1
fi

if ! command -v pdftoppm >/dev/null 2>&1; then
    echo "Error: pdftoppm not found."
    echo "Install with: sudo apt install poppler-utils"
    exit 1
fi

if ! command -v mpx >/dev/null 2>&1; then
    echo "Error: mpx not found."
    echo "Install with: sudo npm install -g @mathpix/mpx-cli"
    echo "Then login with: mpx login"
    exit 1
fi

mkdir -p "$JPG_DIR" "$CLEAN_DIR" "$MPX_DIR"

for pdf in "$INPUT_DIR"/*.pdf; do
    [ -e "$pdf" ] || {
        echo "No PDF files found in $INPUT_DIR"
        exit 0
    }

    pdf_base="$(basename "$pdf" .pdf)"

    pdf_jpg_dir="$JPG_DIR/$pdf_base"
    pdf_clean_dir="$CLEAN_DIR/$pdf_base"
    pdf_mpx_dir="$MPX_DIR/$pdf_base"

    mkdir -p "$pdf_jpg_dir" "$pdf_clean_dir" "$pdf_mpx_dir"

    echo "=================================================="
    echo "Converting PDF: $pdf"
    pdftoppm -jpeg -r "$DPI" "$pdf" "$pdf_jpg_dir/page"

    for img in "$pdf_jpg_dir"/*.jpg; do
        [ -e "$img" ] || continue

        page_base="$(basename "$img" .jpg)"

        cleaned="$pdf_clean_dir/${page_base}.png"
        out="$pdf_mpx_dir/${page_base}.mmd"
        log="$pdf_mpx_dir/${page_base}.log"

        echo
        echo "Cleaning page: $img"

        "$IM" "$img" \
          -colorspace Gray \
          -contrast-stretch 1%x1% \
          -threshold "$THRESHOLD" \
          -strip \
          "$cleaned"

        #echo "Sending to Mathpix: $cleaned"

        #if mpx convert "$cleaned" "$out" 2>&1 | tee "$log"; then
        #    echo "OK: $out"
        #else
        #    echo "FAILED: $img"
        #    echo "See log: $log"
        #fi
    done
done

echo
echo "Done."
echo "JPG pages:     $JPG_DIR"
echo "Cleaned pages: $CLEAN_DIR"
#echo "Mathpix out:   $MPX_DIR"
