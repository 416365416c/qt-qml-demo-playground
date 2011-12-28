#-------------------------------------------------
#
# Project created by QtCreator 2010-08-06T11:38:19
#
#-------------------------------------------------

QT       += testlib declarative quick

TARGET = tst_wordgametest
CONFIG   += console
CONFIG   -= app_bundle

TEMPLATE = app

HEADERS += ../boardlogic.h ../wordlist.h ../letters.h
SOURCES += tst_wordgametest.cpp ../boardlogic.cpp ../wordlist.cpp ../letters.cpp
DEFINES += SRCDIR=\\\"$$PWD/\\\"
dicts.files = allwords.dict notwords.dict ../words.dict
dicts.path = $$PWD
INSTALLS += dicts

RESOURCES += \
    ../dictionary.qrc

OTHER_FILES += \
    allwords.dict \
    notwords.dict \
    wordsInTest.1 \
    wordsInTest.2 \
    wordsInTest.3 \
    wordsInTest.4
