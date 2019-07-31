#ifndef GTESTSSQLQUERIES_H
#define GTESTSSQLQUERIES_H

#include "wordmodel.h"

#include <QObject>
#include <QDebug>

struct UserData;

namespace GTestsSqlQueries {
    namespace User {
        bool createLanguageTable(const UserData &name, const WordModel* model);
        UserData findUser(const QString& name);
        bool languageTableExists(const QString &tableName);
        void deleteLanguageTable(const QString& tableName);
    }

    namespace Tests {

    }
}

#endif // GTESTSSQLQUERIES_H
