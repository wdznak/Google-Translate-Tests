#ifndef ENVIRONMENTDB_H
#define ENVIRONMENTDB_H

#include "initsqlitedb.h"

#include <gtest/gtest.h>
#include <cassert>

#include <QtSql>

using namespace testing;

class EnvironmentDB: public Environment
{
public:
    EnvironmentDB() {
        QSqlError err = initSqliteDb("fakeDb");
        assert(QSqlError::NoError == err.type());
        QSqlDatabase::database().transaction();
    }

    ~EnvironmentDB() {
        QSqlDatabase::database().rollback();
    }
};

#endif // ENVIRONMENTDB_H
