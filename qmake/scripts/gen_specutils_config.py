#!/usr/bin/env python3

import argparse
import re
import sys
from pathlib import Path


CM_DEFINE_RE = re.compile(r"^\s*#cmakedefine01\s+([A-Za-z0-9_]+)\s*$")


def parse_bool(value: str) -> int:
    normalized = str(value).strip().lower()
    if normalized in {"1", "true", "on", "yes"}:
        return 1
    if normalized in {"0", "false", "off", "no"}:
        return 0
    raise ValueError(f"invalid boolean value: {value!r}")


def main() -> int:
    parser = argparse.ArgumentParser(description="Generate SpecUtils_config.h from cmake-style template.")
    parser.add_argument("--template", required=True, dest="template_path")
    parser.add_argument("--output", required=True, dest="output_path")
    parser.add_argument("--perform-developer-checks", default="0")
    parser.add_argument("--enable-d3-chart", default="1")
    parser.add_argument("--enable-uri-spectra", default="0")
    parser.add_argument("--use-wt-threadpool", default="0")
    parser.add_argument("--using-no-threading", default="0")
    parser.add_argument("--d3-support-file-static", default="1")
    parser.add_argument("--inja-templates", default="0")
    parser.add_argument("--build-fuzzing-tests", default="0")
    parser.add_argument("--python-bindings", default="0")
    parser.add_argument("--java-swig", default="0")
    parser.add_argument("--use-simd", default="0")
    parser.add_argument("--enable-equality-checks", default="0")
    parser.add_argument("--flt-parse-method", default="strtod")
    args = parser.parse_args()

    parse_method = args.flt_parse_method.strip().lower()
    if parse_method not in {"fastfloat", "fromchars", "boost", "strtod"}:
        print(
            f"error: invalid --flt-parse-method '{args.flt_parse_method}' "
            "(expected one of fastfloat, fromchars, boost, strtod)",
            file=sys.stderr,
        )
        return 2

    values = {
        "PERFORM_DEVELOPER_CHECKS": parse_bool(args.perform_developer_checks),
        "SpecUtils_ENABLE_D3_CHART": parse_bool(args.enable_d3_chart),
        "SpecUtils_ENABLE_URI_SPECTRA": parse_bool(args.enable_uri_spectra),
        "SpecUtils_USE_WT_THREADPOOL": parse_bool(args.use_wt_threadpool),
        "SpecUtils_USING_NO_THREADING": parse_bool(args.using_no_threading),
        "SpecUtils_D3_SUPPORT_FILE_STATIC": parse_bool(args.d3_support_file_static),
        "SpecUtils_INJA_TEMPLATES": parse_bool(args.inja_templates),
        "SpecUtils_BUILD_FUZZING_TESTS": parse_bool(args.build_fuzzing_tests),
        "SpecUtils_PYTHON_BINDINGS": parse_bool(args.python_bindings),
        "SpecUtils_JAVA_SWIG": parse_bool(args.java_swig),
        "SpecUtils_USE_SIMD": parse_bool(args.use_simd),
        "SpecUtils_ENABLE_EQUALITY_CHECKS": parse_bool(args.enable_equality_checks),
        "SpecUtils_USE_FAST_FLOAT": 1 if parse_method == "fastfloat" else 0,
        "SpecUtils_USE_FROM_CHARS": 1 if parse_method == "fromchars" else 0,
        "SpecUtils_USE_BOOST_SPIRIT": 1 if parse_method == "boost" else 0,
        "SpecUtils_USE_STRTOD": 1 if parse_method == "strtod" else 0,
    }

    template_path = Path(args.template_path)
    output_path = Path(args.output_path)
    template_text = template_path.read_text(encoding="utf-8")

    rendered_lines = []
    for line in template_text.splitlines(keepends=True):
        match = CM_DEFINE_RE.match(line.rstrip("\r\n"))
        if match:
            macro = match.group(1)
            value = 1 if values.get(macro, 0) else 0
            rendered_lines.append(f"#define {macro} {value}\n")
        else:
            rendered_lines.append(line)

    output_path.parent.mkdir(parents=True, exist_ok=True)
    output_path.write_text("".join(rendered_lines), encoding="utf-8")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
