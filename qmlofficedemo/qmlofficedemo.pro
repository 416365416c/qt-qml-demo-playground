#-------------------------------------------------
#
# Project created by QtCreator 2010-06-25T13:24:57
#
#-------------------------------------------------

QT       += core gui webkit declarative

TARGET = qmlofficedemo
TEMPLATE = app


SOURCES += main.cpp\
        mainwindow.cpp \
    customwidget.cpp \
    interface.cpp

HEADERS  += mainwindow.h \
    customwidget.h \
    interface.h

FORMS    += mainwindow.ui \
    customwidget.ui

OTHER_FILES += \
    qml/Testable.qml \
    qml/main.qml \
    qml/Button.qml
