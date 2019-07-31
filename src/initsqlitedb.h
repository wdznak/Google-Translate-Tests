#ifndef INITSQLITEDB_H
#define INITSQLITEDB_H

#include <QtSql>
#include <array>

static constexpr const std::array<const char*, 4> seeds {
    "CREATE TABLE users ("
    "id INTEGER PRIMARY KEY AUTOINCREMENT, "
    "name VARCHAR NOT NULL CONSTRAINT unique_name UNIQUE ON CONFLICT IGNORE, "
    "avatar VARCHAR)",

    "CREATE TABLE groups ("
    "id INTEGER PRIMARY KEY,"
    "group_name VARCHAR NOT NULL,"
    "language_id INTEGER REFERENCES languages (id) NOT NULL,"
    "points INTEGER DEFAULT (0) NOT NULL,"
    "level INTEGER DEFAULT (1) NOT NULL)",

    "CREATE TABLE languages ("
    "id INTEGER PRIMARY KEY, "
    "user_id INTEGER REFERENCES users (id), "
    "table_name VARCHAR NOT NULL, "
    "lang_a VARCHAR NOT NULL, "
    "lang_b VARCHAR NOT NULL)",

    "CREATE TABLE group_words ("
    "id INTEGER PRIMARY KEY AUTOINCREMENT UNIQUE,"
    "group_id INTEGER REFERENCES groups (id) NOT NULL,"
    "word_id INTEGER NOT NULL,"
    "CONSTRAINT [index] UNIQUE (group_id, word_id) "
    "ON CONFLICT FAIL)"
};

QSqlError initSqliteDb(const char* dbName)
{
    QSqlDatabase db = QSqlDatabase::addDatabase("QSQLITE");
    db.setDatabaseName(dbName);

    if(!db.open())
        return db.lastError();

    QStringList tables = db.tables();

    if (tables.contains("users", Qt::CaseInsensitive))
        return QSqlError();

    db.transaction();
    QSqlQuery query;

    for(std::size_t i = 0; i < seeds.size(); ++i){
        if(!query.exec(seeds[i])){
            db.rollback();
            return query.lastError();
        }
    }

    db.commit();

    return QSqlError();
}



#endif // INITSQLITEDB_H
