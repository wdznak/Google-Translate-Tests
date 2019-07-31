#include "gtestssqlqueries.h"
#include "userdata.h"

#include <QSqlQuery>
#include <QSqlError>

namespace GTestsSqlQueries {
namespace User {

bool createLanguageTable(const UserData &userData, const WordModel *model)
{
    if (nullptr == model) return false;
    /*
     * Name convention "username_langa_langb" e.g. "john_english_spanish"
     */
    QString tableName = (userData.userName + "_" + model->wordOrigin() + "_" + model->translationOrigin()).toLower();
    QString inversedTableName = (userData.userName + "_" + model->translationOrigin() + "_" + model->wordOrigin()).toLower();

    if(languageTableExists(tableName) || languageTableExists(inversedTableName))
        return false;

    /*
     * Creating table and inserting information about it into "laguages" table
     * is made in transaction
     */
    QSqlDatabase::database().transaction();

    /*
     * Insert name of the new table into "languages" table to track
     * different user's language courses
     */
    QSqlQuery insertToLangTab;
    insertToLangTab.prepare("INSERT INTO languages (user_id, table_name, lang_a, lang_b) "
                            "VALUES (:userId, :tableName, :langA, :langB)");
    insertToLangTab.bindValue(":userId", userData.id);
    insertToLangTab.bindValue(":tableName", tableName);
    insertToLangTab.bindValue(":langA", model->wordOrigin());
    insertToLangTab.bindValue(":langB", model->translationOrigin());

    if(!insertToLangTab.exec()){
        QSqlDatabase::database().rollback();
        return false;
    }

    /*
     * Create table with language pair
     */
    QString createPrep = QString("CREATE TABLE %1 "
              "(id INTEGER PRIMARY KEY AUTOINCREMENT, "
              "word_a VARCHAR NOT NULL, "
              "word_b VARCHAR NOT NULL, "
              "attempt INTEGER DEFAULT (0) NOT NULL, "
              "streak INTEGER DEFAULT (0) NOT NULL, "
              "description VARCHAR, "
              "active BOOLEAN DEFAULT (1) NOT NULL, "
              "date DATETIME DEFAULT (datetime('now', 'localtime')) NOT NULL, "
              "UNIQUE (word_a, word_b) ON CONFLICT IGNORE)").arg(tableName);

    QSqlQuery createQuery;
    createQuery.prepare(createPrep);

    if(!createQuery.exec()){
        QSqlDatabase::database().rollback();
        return false;
    }

    QSqlQuery insertQuery;
    QVariantList wordsA, wordsB;
    QModelIndex index;

    insertQuery.prepare("INSERT INTO " + tableName + " (word_a, word_b) VALUES (?, ?)");

    for(int i = 0; i < model->rowCount(); ++i){
        index = model->index(i);
        wordsA << model->data(index, WordModel::WordRole);
        wordsB << model->data(index, WordModel::TranslationRole);
    }
    insertQuery.addBindValue(wordsA);
    insertQuery.addBindValue(wordsB);

    if(!insertQuery.execBatch()){
        QSqlDatabase::database().rollback();
        return false;
    }

    return QSqlDatabase::database().commit();
}

UserData findUser(const QString &name)
{
    QSqlQuery query;
    UserData userData;

    query.prepare("SELECT * FROM users WHERE name = (:name)");
    query.bindValue(":name", name);

    if(query.exec() && query.first()){
        userData.id = query.value(0).toInt();
        userData.userName = query.value(1).toString();
        userData.avatar = query.value(2).toString();
    }

    return userData;
}

bool languageTableExists(const QString &tableName)
{
    QSqlQuery query;
    query.prepare("SELECT 1 FROM languages WHERE table_name = (:tableName)");
    query.bindValue("tableName", tableName);

    if(query.exec() && query.first()) return true;

    return false;
}

void deleteLanguageTable(const QString &tableName)
{
    QString queryPrep = QString("DROP TABLE IF EXISTS %1").arg(tableName);
    QSqlQuery query(queryPrep);
}


}
}
