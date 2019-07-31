#include "wordsimportfactory.h"
#include "xlsxwordsimport.h"

#include <QFileInfo>
#include <boost/bind.hpp>
#include <boost/functional/factory.hpp>

std::unique_ptr<WordsImportInterface> WordsImportFactory::create(const QString& fileName)
{
    auto it = factories.find(QFileInfo(fileName).suffix());

    if(it != factories.end())
        return std::unique_ptr<WordsImportInterface>(it->second(fileName));

    return std::unique_ptr<WordsImportInterface>(nullptr);
}

std::map< QString, a_factory > WordsImportFactory::factories = {
    { QStringLiteral("xlsx"), boost::bind(boost::factory< XlsxWordsImport* >(), _1) }
};
