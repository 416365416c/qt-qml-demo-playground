#-------------------------------------------------
#
# Project created by QtCreator 2010-05-27T20:20:07
#
#-------------------------------------------------

QT       += core gui declarative

TARGET = quicklauncher
TEMPLATE = app


SOURCES += main.cpp\
        quickview.cpp

HEADERS  += quickview.h

RESOURCES += \
    quicklauncher.qrc

OTHER_FILES += \
    quicklauncher.qml \
    components/LauncherDelegate.qml \
    components/LauncherModel.qml
