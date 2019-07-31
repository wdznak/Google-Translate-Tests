#ifndef WordsImportInterface_H
#define WordsImportInterface_H

#include <QString>
#include <QPair>
#include <QList>
#include "wordmodel.h"

class WordsImportInterface {
public:
    WordsImportInterface() = default;
    WordsImportInterface(const WordsImportInterface&) = delete;
    WordsImportInterface& operator=(const WordsImportInterface&) = delete;
    virtual ~WordsImportInterface() = default;

    virtual WordModel* words() const = 0;
};

#endif // WordsImportInterface_H
