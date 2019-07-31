#include "xlsxwordsimport.h"
#include "wordmodel.h"

#include <QQmlEngine>



XlsxWordsImport::XlsxWordsImport(const QString& text): xlsx(text)
{
    //TODO: Create file validation
    QQmlEngine::setObjectOwnership(m_words, QQmlEngine::CppOwnership);
    readData();
}

XlsxWordsImport::~XlsxWordsImport() {
    delete m_words;
}

WordModel* XlsxWordsImport::words() const
{
    return m_words;
}

void XlsxWordsImport::readData() const
{
    readLanguages();
    readWords();
}

void XlsxWordsImport::readWords() const
{
    int rowCount = 1;

    QString langA{ xlsx.cellAt(1, 1)->value().toString() };
    QString langB{ xlsx.cellAt(1, 2)->value().toString() };
    QVariant firstLanguage = ( langA < langB ) ? langA: langB;

    while(QXlsx::Cell *cell = xlsx.cellAt(rowCount, 1)) {
        if(firstLanguage == cell->value()) {
            m_words->addWord(Word(xlsx.cellAt(rowCount, 3)->value().toString(), xlsx.cellAt(rowCount, 4)->value().toString()));
        }else {
            m_words->addWord(Word(xlsx.cellAt(rowCount, 4)->value().toString(), xlsx.cellAt(rowCount, 3)->value().toString()));
        }
        rowCount++;
    }
}

void XlsxWordsImport::readLanguages() const
{
    m_words->addHeader(xlsx.read("A1").toString(), xlsx.read("B1").toString());
}
