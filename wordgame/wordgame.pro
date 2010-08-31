TEMPLATE = lib
TARGET  = wordgame
QT += declarative
CONFIG += qt plugin

TARGET = $$qtLibraryTarget($$TARGET)
TARGETPATH = Qt/labs/wordgame
target.path = $$[QT_INSTALL_IMPORTS]/$$TARGETPATH
qmldir.files = qmldir
qmldir.path = $$[QT_INSTALL_IMPORTS]/$$TARGETPATH
INSTALLS += target qmldir

# Input
SOURCES += \
    wordgame.cpp \
    wordlist.cpp \
    boardlogic.cpp

OTHER_FILES=qmldir

HEADERS += \
    wordgame.h \
    wordlist.h \
    boardlogic.h

RESOURCES += \
    dictionary.qrc
