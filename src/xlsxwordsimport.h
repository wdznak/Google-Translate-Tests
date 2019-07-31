#ifndef XLSXWORDSIMPORT_H
#define XLSXWORDSIMPORT_H

#include "wordsimportinterface.h"

#include <QtXlsx>

#include <memory>

class WordModel;

class XlsxWordsImport : public WordsImportInterface
{
public:
    XlsxWordsImport(const QString& text);
    XlsxWordsImport(const WordsImportInterface&) = delete;
    XlsxWordsImport& operator=(const WordsImportInterface&) = delete;
    ~XlsxWordsImport();

    WordModel* words() const override;

private:
    QXlsx::Document xlsx;
    WordModel* m_words = new WordModel();

    void readData() const;
    void readWords() const;
    void readLanguages() const;
};

#endif // XLSXWORDSIMPORT_H
