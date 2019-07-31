#ifndef WORDSIMPORTFACTORY_H
#define WORDSIMPORTFACTORY_H

#include "wordsimportinterface.h"
#include <QString>
#include <map>
#include <memory>
#include <boost/function.hpp>
#include <string>

using a_factory = boost::function< WordsImportInterface*(const QString&) >;

class WordsImportFactory
{
public:
    static std::unique_ptr< WordsImportInterface > create(const QString& fileName);
private:
    WordsImportFactory();
    static std::map< QString, a_factory > factories;
};

#endif // WORDSIMPORTFACTORY_H
