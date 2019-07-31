TEMPLATE = app

QT += qml \
    quick \
    sql \
    gui \
    xlsx \

CONFIG += c++14 \
    debug

HEADERS += \
    importdata.h \
    wordsimportfactory.h \
    xlsxwordsimport.h \
    wordmodel.h \
    wordsimportinterface.h \
    usermanager.h \
    initsqlitedb.h \
    usersmodel.h \
    userwordsmodel.h \
    gtestssqlqueries.h \
    userdata.h \
    languagesmodel.h \
    groupsmodel.h \
    groupwordsmodel.h

SOURCES += main.cpp \
    wordsimportfactory.cpp \
    xlsxwordsimport.cpp \
    importdata.cpp \
    wordmodel.cpp \
    usermanager.cpp \
    userwordsmodel.cpp \
    gtestssqlqueries.cpp \
    usersmodel.cpp \
    languagesmodel.cpp \
    groupsmodel.cpp \
    groupwordsmodel.cpp

RESOURCES += qml.qrc

RC_ICONS = gtestsico.ico

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# The following define makes your compiler emit warnings if you use
# any feature of Qt which as been marked deprecated (the exact warnings
# depend on your compiler). Please consult the documentation of the
# deprecated API in order to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if you use deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

INCLUDEPATH += "G:/Program Files/boost/boost_1_64_0/"

win32 {
    TARGET_SRC   = $$PWD/DefaultGraphics
    TARGET_DEST  = $$OUT_PWD

    TARGET_SRC  ~= s,/,\\,g # fix slashes
    TARGET_DEST ~= s,/,\\,g # fix slashes

    QMAKE_POST_LINK +=$$quote(xcopy /y $${TARGET_SRC} $${TARGET_DEST}$$escape_expand(\n\t))
    message("[INFO] Will copy $${TARGET_SRC} to $${TARGET_DEST}")
}

QMAKE_CXXFLAGS_RELEASE -= -O2
QMAKE_CXXFLAGS_RELEASE += -O3


