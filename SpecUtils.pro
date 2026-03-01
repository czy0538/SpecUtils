TEMPLATE = lib
TARGET = SpecUtils

CONFIG += staticlib create_prl
CONFIG += c++17
CONFIG -= qt
CONFIG -= app_bundle

SPECUTILS_PRO_DIR = $$clean_path($$_PRO_FILE_PWD_)
include($$SPECUTILS_PRO_DIR/qmake/specutils_defaults.pri)
include($$SPECUTILS_PRO_DIR/qmake/specutils_sources.pri)
include($$SPECUTILS_PRO_DIR/qmake/generate_specutils_headers.pri)

DESTDIR = $$OUT_PWD
OBJECTS_DIR = $$OUT_PWD/obj
MOC_DIR = $$OUT_PWD/moc
RCC_DIR = $$OUT_PWD/rcc
UI_DIR = $$OUT_PWD/ui

win32 {
    LIBS += -lShlwapi
}

android {
    LIBS += -llog
}

unix:!macx {
    !equals(SPECUTILS_USING_NO_THREADING, 1): LIBS += -lpthread
}

equals(SPECUTILS_ENABLE_URI_SPECTRA, 1) {
    LIBS += -lz
}

equals(SPECUTILS_FLT_PARSE_METHOD, boost)|equals(SPECUTILS_PERFORM_DEVELOPER_CHECKS, 1) {
    LIBS += -lboost_system
}

equals(SPECUTILS_FLT_PARSE_METHOD, fastfloat) {
    isEmpty(SPECUTILS_FAST_FLOAT_INCLUDE) {
        warning(SPECUTILS_FLT_PARSE_METHOD is 'fastfloat' but SPECUTILS_FAST_FLOAT_INCLUDE is empty; add fast_float include path.)
    } else {
        INCLUDEPATH += $$SPECUTILS_FAST_FLOAT_INCLUDE
    }
}
