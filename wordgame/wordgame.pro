TEMPLATE = lib
TARGET  = wordgame
QT += qml quick
CONFIG += qt plugin

TARGET = $$qtLibraryTarget($$TARGET)
TARGETPATH = Qt/labs/wordgame.2
target.path = $$[QT_INSTALL_QML]/$$TARGETPATH
qmldir.files = qmldir
qmldir.path = $$[QT_INSTALL_QML]/$$TARGETPATH
INSTALLS += target qmldir

# Input
SOURCES += \
    wordgame.cpp \
    wordlist.cpp \
    boardlogic.cpp \
    letters.cpp

OTHER_FILES=qmldir

HEADERS += \
    wordgame.h \
    wordlist.h \
    boardlogic.h \
    letters.h

RESOURCES += \
    dictionary.qrc
