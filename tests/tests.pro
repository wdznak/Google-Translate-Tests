include(gtest_dependency.pri)

TEMPLATE = app

QT += qml \
    quick \
    sql \
    gui \
    xlsx \
    #testlib

CONFIG += c++14 \
    console

CONFIG -= app_bundle \

HEADERS += \
    environmentdb.h \
    tst_usermanager.h \
    tst_usersmodel.h \
    tst_importdata.h

SOURCES += \
    main.cpp \
    ../src/wordsimportfactory.cpp \
    ../src/xlsxwordsimport.cpp \
    ../src/importdata.cpp \
    ../src/wordmodel.cpp \
    ../src/usermanager.cpp \
    ../src/userwordsmodel.cpp \
    ../src/gtestssqlqueries.cpp \
    ../src/usersmodel.cpp \
    ../src/languagesmodel.cpp \
    ../src/groupsmodel.cpp \
    ../src/groupwordsmodel.cpp

INCLUDEPATH *= "C:/Program Files/boost/boost_1_64_0/" \
    ../src
