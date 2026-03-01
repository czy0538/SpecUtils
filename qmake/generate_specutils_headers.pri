SPECUTILS_QMAKE_DIR = $$clean_path($$PWD)
include($$SPECUTILS_QMAKE_DIR/specutils_defaults.pri)

SPECUTILS_GENERATOR_DIR = $$SPECUTILS_QMAKE_DIR/scripts
SPECUTILS_CONFIG_TEMPLATE = $$SPECUTILS_ROOT/SpecUtils/SpecUtils_config.h.in
SPECUTILS_D3_MIN_JS_PATH = $$SPECUTILS_ROOT/d3_resources/d3.v3.min.js
SPECUTILS_D3_CHART_JS_PATH = $$SPECUTILS_ROOT/d3_resources/SpectrumChartD3.js
SPECUTILS_D3_CHART_CSS_PATH = $$SPECUTILS_ROOT/d3_resources/SpectrumChartD3.css

SPECUTILS_CONFIG_HEADER = $$SPECUTILS_GENERATED_DIR/SpecUtils_config.h
SPECUTILS_D3_HEADER = $$SPECUTILS_GENERATED_DIR/D3SpectrumExportResources.h

specutils_config_cmd = $$shell_quote($$SPECUTILS_PYTHON)
specutils_config_cmd += $$shell_quote($$SPECUTILS_GENERATOR_DIR/gen_specutils_config.py)
specutils_config_cmd += --template $$shell_quote($$SPECUTILS_CONFIG_TEMPLATE)
specutils_config_cmd += --output $$shell_quote($$SPECUTILS_CONFIG_HEADER)
specutils_config_cmd += --perform-developer-checks $$SPECUTILS_PERFORM_DEVELOPER_CHECKS
specutils_config_cmd += --enable-d3-chart $$SPECUTILS_ENABLE_D3_CHART
specutils_config_cmd += --enable-uri-spectra $$SPECUTILS_ENABLE_URI_SPECTRA
specutils_config_cmd += --use-wt-threadpool $$SPECUTILS_USE_WT_THREADPOOL
specutils_config_cmd += --using-no-threading $$SPECUTILS_USING_NO_THREADING
specutils_config_cmd += --d3-support-file-static $$SPECUTILS_D3_SUPPORT_FILE_STATIC
specutils_config_cmd += --inja-templates $$SPECUTILS_INJA_TEMPLATES
specutils_config_cmd += --build-fuzzing-tests $$SPECUTILS_BUILD_FUZZING_TESTS
specutils_config_cmd += --python-bindings $$SPECUTILS_PYTHON_BINDINGS
specutils_config_cmd += --java-swig $$SPECUTILS_JAVA_SWIG
specutils_config_cmd += --use-simd $$SPECUTILS_USE_SIMD
specutils_config_cmd += --enable-equality-checks $$SPECUTILS_ENABLE_EQUALITY_CHECKS
specutils_config_cmd += --flt-parse-method $$SPECUTILS_FLT_PARSE_METHOD

specutils_config_output = $$system($$specutils_config_cmd, lines, specutils_config_status)
!equals(specutils_config_status, 0) {
    error(Failed to generate SpecUtils_config.h)
}

specutils_d3_cmd = $$shell_quote($$SPECUTILS_PYTHON)
specutils_d3_cmd += $$shell_quote($$SPECUTILS_GENERATOR_DIR/gen_d3_header.py)
specutils_d3_cmd += --output $$shell_quote($$SPECUTILS_D3_HEADER)
specutils_d3_cmd += --static $$SPECUTILS_D3_SUPPORT_FILE_STATIC
specutils_d3_cmd += --runtime-dir $$shell_quote($$SPECUTILS_D3_SCRIPTS_RUNTIME_DIR)
specutils_d3_cmd += --d3-min-js $$shell_quote($$SPECUTILS_D3_MIN_JS_PATH)
specutils_d3_cmd += --spectrum-js $$shell_quote($$SPECUTILS_D3_CHART_JS_PATH)
specutils_d3_cmd += --spectrum-css $$shell_quote($$SPECUTILS_D3_CHART_CSS_PATH)

specutils_d3_output = $$system($$specutils_d3_cmd, lines, specutils_d3_status)
!equals(specutils_d3_status, 0) {
    error(Failed to generate D3SpectrumExportResources.h)
}

HEADERS += $$SPECUTILS_CONFIG_HEADER $$SPECUTILS_D3_HEADER
