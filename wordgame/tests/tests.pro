#-------------------------------------------------
#
# Project created by QtCreator 2010-08-06T11:38:19
#
#-------------------------------------------------

QT       += testlib declarative

TARGET = tst_wordgametest
CONFIG   += console
CONFIG   -= app_bundle

TEMPLATE = app

HEADERS += ../boardlogic.h ../wordlist.h
SOURCES += tst_wordgametest.cpp ../boardlogic.cpp ../wordlist.cpp
DEFINES += SRCDIR=\\\"$$PWD/\\\"
dicts.files = allwords.dict notwords.dict ../words.dict
dicts.path = $$PWD
INSTALLS += dicts

RESOURCES += \
    ../dictionary.qrc

OTHER_FILES += \
    allwords.dict \
    notwords.dict
