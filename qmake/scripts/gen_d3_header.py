#!/usr/bin/env python3

import argparse
import os
import sys
from pathlib import Path


def parse_bool(value: str) -> int:
    normalized = str(value).strip().lower()
    if normalized in {"1", "true", "on", "yes"}:
        return 1
    if normalized in {"0", "false", "off", "no"}:
        return 0
    raise ValueError(f"invalid boolean value: {value!r}")


def c_string(text: str) -> str:
    return '"' + text.replace("\\", "\\\\").replace('"', '\\"') + '"'


def render_array(name: str, file_path: Path) -> str:
    payload = file_path.read_bytes()
    items = [f"0x{byte:02x}" for byte in payload]
    items.append("0x00")

    per_line = 12
    lines = []
    for idx in range(0, len(items), per_line):
        lines.append("  " + ", ".join(items[idx : idx + per_line]))

    return (
        f"const unsigned char {name}[] = {{\n"
        + ",\n".join(lines)
        + "\n};\n"
        + f"const size_t {name}_SIZE = {len(payload)};\n"
    )


def main() -> int:
    parser = argparse.ArgumentParser(description="Generate D3SpectrumExportResources.h.")
    parser.add_argument("--output", required=True, dest="output_path")
    parser.add_argument("--static", required=True, dest="static_mode")
    parser.add_argument("--runtime-dir", required=True, dest="runtime_dir")
    parser.add_argument("--d3-min-js", required=True, dest="d3_min_js")
    parser.add_argument("--spectrum-js", required=True, dest="spectrum_js")
    parser.add_argument("--spectrum-css", required=True, dest="spectrum_css")
    args = parser.parse_args()

    static_mode = parse_bool(args.static_mode)
    output_path = Path(args.output_path)
    d3_min_js = Path(args.d3_min_js)
    spectrum_js = Path(args.spectrum_js)
    spectrum_css = Path(args.spectrum_css)

    lines = []
    lines.append("#ifndef D3_SPECTRUM_EXPORT_RESOURCES_H\n")
    lines.append("#define D3_SPECTRUM_EXPORT_RESOURCES_H\n\n")
    lines.append("#include <cstddef>\n\n")
    lines.append("#ifndef SpecUtils_D3_SUPPORT_FILE_STATIC\n")
    lines.append(f"#define SpecUtils_D3_SUPPORT_FILE_STATIC {static_mode}\n")
    lines.append("#endif\n\n")
    lines.append("#if( SpecUtils_D3_SUPPORT_FILE_STATIC )\n")

    if static_mode:
        if not d3_min_js.exists() or not spectrum_js.exists() or not spectrum_css.exists():
            print("error: one or more D3 resource files are missing", file=sys.stderr)
            return 2
        lines.append(render_array("D3_MIN_JS", d3_min_js))
        lines.append("\n")
        lines.append(render_array("SPECTRUM_CHART_D3_JS", spectrum_js))
        lines.append("\n")
        lines.append(render_array("SPECTRUM_CHART_D3_CSS", spectrum_css))
    else:
        lines.append("const unsigned char D3_MIN_JS[] = { 0x00 };\n")
        lines.append("const size_t D3_MIN_JS_SIZE = 0;\n")
        lines.append("const unsigned char SPECTRUM_CHART_D3_JS[] = { 0x00 };\n")
        lines.append("const size_t SPECTRUM_CHART_D3_JS_SIZE = 0;\n")
        lines.append("const unsigned char SPECTRUM_CHART_D3_CSS[] = { 0x00 };\n")
        lines.append("const size_t SPECTRUM_CHART_D3_CSS_SIZE = 0;\n")

    lines.append("#else\n")
    lines.append(f"const char * const D3_SCRIPT_RUNTIME_DIR = {c_string(args.runtime_dir)};\n")
    lines.append(
        f"const char * const D3_MIN_JS_FILENAME = {c_string(os.path.basename(args.d3_min_js))};\n"
    )
    lines.append(
        f"const char * const SPECTRUM_CHART_D3_JS_FILENAME = {c_string(os.path.basename(args.spectrum_js))};\n"
    )
    lines.append(
        f"const char * const SPECTRUM_CHART_D3_CSS_FILENAME = {c_string(os.path.basename(args.spectrum_css))};\n"
    )
    lines.append("#endif\n\n")
    lines.append("#endif\n")

    output_path.parent.mkdir(parents=True, exist_ok=True)
    output_path.write_text("".join(lines), encoding="utf-8")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
