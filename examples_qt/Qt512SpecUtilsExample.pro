TEMPLATE = subdirs
CONFIG += ordered

SUBDIRS += specutils_lib
SUBDIRS += app

specutils_lib.file = ../SpecUtils.pro
specutils_lib.subdir = build/specutils

app.file = SpecUtilsQtApp/SpecUtilsQtApp.pro
app.subdir = build/app
app.depends = specutils_lib
