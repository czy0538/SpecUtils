SPECUTILS_QMAKE_DIR = $$clean_path($$_PRO_FILE_PWD_)
include($$SPECUTILS_QMAKE_DIR/specutils_defaults.pri)

INCLUDEPATH += $$SPECUTILS_ROOT
INCLUDEPATH += $$SPECUTILS_ROOT/3rdparty
INCLUDEPATH += $$SPECUTILS_GENERATED_DIR

DEPENDPATH += $$SPECUTILS_ROOT
DEPENDPATH += $$SPECUTILS_ROOT/3rdparty
DEPENDPATH += $$SPECUTILS_GENERATED_DIR

SOURCES += \
    $$SPECUTILS_ROOT/src/SpecFile.cpp \
    $$SPECUTILS_ROOT/src/SpecFile_pcf.cpp \
    $$SPECUTILS_ROOT/src/SpecFile_cnf.cpp \
    $$SPECUTILS_ROOT/src/SpecFile_n42.cpp \
    $$SPECUTILS_ROOT/src/SpecFile_spc.cpp \
    $$SPECUTILS_ROOT/src/SpecFile_chn.cpp \
    $$SPECUTILS_ROOT/src/SpecFile_spe.cpp \
    $$SPECUTILS_ROOT/src/SpecFile_csv.cpp \
    $$SPECUTILS_ROOT/src/SpecFile_gr135.cpp \
    $$SPECUTILS_ROOT/src/SpecFile_aram.cpp \
    $$SPECUTILS_ROOT/src/SpecFile_lis.cpp \
    $$SPECUTILS_ROOT/src/SpecFile_lzs.cpp \
    $$SPECUTILS_ROOT/src/SpecFile_phd.cpp \
    $$SPECUTILS_ROOT/src/SpecFile_tka.cpp \
    $$SPECUTILS_ROOT/src/SpecFile_lsrm.cpp \
    $$SPECUTILS_ROOT/src/SpecFile_mca.cpp \
    $$SPECUTILS_ROOT/src/SpecFile_spmdf.cpp \
    $$SPECUTILS_ROOT/src/SpecFile_mps.cpp \
    $$SPECUTILS_ROOT/src/SpecFile_multiact.cpp \
    $$SPECUTILS_ROOT/src/SpecFile_uraider.cpp \
    $$SPECUTILS_ROOT/src/SpecFile_radiacode.cpp \
    $$SPECUTILS_ROOT/src/SpecFile_xml_other.cpp \
    $$SPECUTILS_ROOT/src/SpecFile_json.cpp \
    $$SPECUTILS_ROOT/src/SpecUtilsAsync.cpp \
    $$SPECUTILS_ROOT/src/SerialToDetectorModel.cpp \
    $$SPECUTILS_ROOT/src/EnergyCalibration.cpp \
    $$SPECUTILS_ROOT/src/CubicSpline.cpp \
    $$SPECUTILS_ROOT/src/StringAlgo.cpp \
    $$SPECUTILS_ROOT/src/Filesystem.cpp \
    $$SPECUTILS_ROOT/src/DateTime.cpp \
    $$SPECUTILS_ROOT/src/ParseUtils.cpp \
    $$SPECUTILS_ROOT/src/SpecFile_location.cpp \
    $$SPECUTILS_ROOT/src/CAMIO.cpp

HEADERS += \
    $$SPECUTILS_ROOT/SpecUtils/SpecFile.h \
    $$SPECUTILS_ROOT/SpecUtils/SpecUtilsAsync.h \
    $$SPECUTILS_ROOT/SpecUtils/SerialToDetectorModel.h \
    $$SPECUTILS_ROOT/SpecUtils/EnergyCalibration.h \
    $$SPECUTILS_ROOT/SpecUtils/CubicSpline.h \
    $$SPECUTILS_ROOT/SpecUtils/StringAlgo.h \
    $$SPECUTILS_ROOT/SpecUtils/Filesystem.h \
    $$SPECUTILS_ROOT/SpecUtils/DateTime.h \
    $$SPECUTILS_ROOT/SpecUtils/ParseUtils.h \
    $$SPECUTILS_ROOT/SpecUtils/SpecFile_location.h \
    $$SPECUTILS_ROOT/SpecUtils/RapidXmlUtils.hpp \
    $$SPECUTILS_ROOT/SpecUtils/CAMIO.h \
    $$SPECUTILS_GENERATED_DIR/SpecUtils_config.h \
    $$SPECUTILS_GENERATED_DIR/D3SpectrumExportResources.h

equals(SPECUTILS_INJA_TEMPLATES, 1) {
    SOURCES += $$SPECUTILS_ROOT/src/SpecFile_template.cpp
}

equals(SPECUTILS_ENABLE_D3_CHART, 1) {
    SOURCES += $$SPECUTILS_ROOT/src/D3SpectrumExport.cpp
    HEADERS += $$SPECUTILS_ROOT/SpecUtils/D3SpectrumExport.h
}

equals(SPECUTILS_ENABLE_URI_SPECTRA, 1) {
    SOURCES += \
        $$SPECUTILS_ROOT/src/UriSpectrum.cpp \
        $$SPECUTILS_ROOT/src/SpecFile_uri.cpp
    HEADERS += $$SPECUTILS_ROOT/SpecUtils/UriSpectrum.h
}
