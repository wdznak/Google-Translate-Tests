TEMPLATE = subdirs

CONFIG += ordered

CONFIG(release, debug|release) {
    SUBDIRS += src
}
CONFIG(debug, debug|release) {
    SUBDIRS += src tests
    tests.depends = src
}


OTHER_FILES += \
