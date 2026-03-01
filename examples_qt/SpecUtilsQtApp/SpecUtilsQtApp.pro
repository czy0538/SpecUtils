TEMPLATE = app
TARGET = SpecUtilsQtApp

QT += core
CONFIG += console c++17
CONFIG -= app_bundle

SOURCES += main.cpp

SPECUTILS_ROOT = $$clean_path($$PWD/../..)
SPECUTILS_LIB_DIR = $$clean_path($$OUT_PWD/../specutils)
SPECUTILS_GENERATED_INCLUDE = $$clean_path($$SPECUTILS_LIB_DIR/generated)

include($$SPECUTILS_ROOT/qmake/specutils.pri)
