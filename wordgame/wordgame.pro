TEMPLATE = lib
TARGET  = wordgame
QT += declarative
CONFIG += qt plugin

TARGET = $$qtLibraryTarget($$TARGET)

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
