#include "userwordsmodel.h"
#include "wordmodel.h"

#include <QSqlRecord>
#include <QSqlQuery>
#include <QSqlError>
#include <QVariantList>
#include <QDebug>

#include <algorithm>

UserWordsModel::UserWordsModel(QObject* parent)
    : QSqlTableModel(parent)
{
    setEditStrategy(QSqlTableModel::OnManualSubmit);
}

QVariant UserWordsModel::data(const QModelIndex& index, int role) const
{
    if (role < Qt::UserRole)
        return QSqlTableModel::data(index, role);

    const QSqlRecord sqlRecord = record(index.row());

    return sqlRecord.value(role - Qt::UserRole);
}

bool UserWordsModel::selectIds(const QList<QString>& list)
{
    if (list.isEmpty()) return false;

    auto it = list.cbegin();
    QString query = QString("id IN (");

    query += *it++;
    std::for_each(it, list.cend(), [&query](const QString& el){ query += ", " + el; });
    query += ")";
    qDebug() << query;
    QSqlTableModel::setFilter(query);

    return select();
}

bool UserWordsModel::addRows(WordModel *model)
{

    const int rowCount = model->rowCount();
    if (nullptr == model || 0 == rowCount) return false;

    QString query = QString("INSERT INTO %1 (word_a, word_b) "
                            "VALUES (?, ?)").arg(tableName());

    QSqlDatabase::database().transaction();
    QSqlQuery insertWords;
    QVariantList wordsA, wordsB;
    QModelIndex index;

    insertWords.prepare(query);
    for(int i = 0; i < rowCount; ++i){
        index = model->index(i);
        wordsA << model->data(index, WordModel::WordRole);
        wordsB << model->data(index, WordModel::TranslationRole);
    }
    insertWords.addBindValue(wordsA);
    insertWords.addBindValue(wordsB);

    if(insertWords.execBatch() && QSqlDatabase::database().commit()){
        select();
        return true;
    }

    QSqlDatabase::database().rollback();
    return false;
}

bool UserWordsModel::rowExists(const QString& wordA, const QString& wordB) const
{
    QString query = QString("SELECT EXISTS(SELECT 1 FROM %1 WHERE (word_a = :wordA AND word_b = :wordB))").arg(tableName());
    QSqlQuery findRow;
    findRow.prepare(query);
    findRow.bindValue(":wordA", wordA);
    findRow.bindValue(":wordB", wordB);
    findRow.exec();
    findRow.first();

    return findRow.value(0).toBool();
}

int UserWordsModel::idRow(const int wordId)
{
    int result = -1;
    QModelIndex modelIndex = this->index(0, 0);
    QModelIndexList indexList = QSqlTableModel::match(modelIndex,
                                                      IdRole,
                                                      wordId,
                                                      1,
                                                      Qt::MatchFlags(Qt::MatchExactly|Qt::MatchWrap));
    if (indexList.count() > 0) {
        result = indexList[0].row();
    }

    return result;
}

QVector<int> UserWordsModel::duplicatedRows(WordModel *model) const
{
    QVector<int> result;
    const int rowCount = model->rowCount();

    if (0 == rowCount) return result;

    QSqlDatabase::database().transaction();
    QString fakeTable("CREATE TABLE fake ("
                        "id INTEGER PRIMARY KEY AUTOINCREMENT, "
                        "word_a VARCHAR NOT NULL, "
                        "word_b VARCHAR NOT NULL )");
    QSqlQuery query;

    query.exec(fakeTable);
    query.lastQuery();

    QSqlQuery insertWords;
    insertWords.prepare("INSERT INTO fake (word_a, word_b) "
                        "VALUES(?, ?)");

    QVariantList wordsA, wordsB;
    QModelIndex index;

    for(int i = 0; i < rowCount; ++i){
        index = model->index(i);
        wordsA << model->data(index, WordModel::WordRole);
        wordsB << model->data(index, WordModel::TranslationRole);
    }

    insertWords.addBindValue(wordsA);
    insertWords.addBindValue(wordsB);

    if(!insertWords.execBatch()){
        QSqlDatabase::database().rollback();
        return result;
    }

    QSqlQuery findRows;

    findRows.exec("SELECT fake.id FROM fake "
                  "JOIN " + tableName() + " AS old "
                  "ON fake.word_a = old.word_a AND fake.word_b = old.word_b");
    findRows.lastQuery();
    findRows.lastError().text();

    while(findRows.next()) {
        result << findRows.value(0).toInt() - 1;
    }

    QSqlDatabase::database().rollback();
    return result;
}

bool UserWordsModel::setData(const QModelIndex& index, const QVariant& value, int role)
{
    if (!index.isValid()) return false;

    const int columnIndex = role - Qt::UserRole;
    const QModelIndex modelIndex = this->index(index.row(), columnIndex);
    bool result = false;

    //before we change word or its translation we need to check if
    //it's not exists already
    if (role == WordRole) {
        if (!rowExists(data(index, role).toString(), value.toString())) {
            result = QSqlTableModel::setData(modelIndex, value);
        }
    } else if (role == TranslationRole) {
        if(!rowExists(value.toString(), data(index, role).toString())) {
            result = QSqlTableModel::setData(modelIndex, value);
        }
    } else {
        result = QSqlTableModel::setData(modelIndex, value, Qt::EditRole);
    }

    if (result && submitAll()) {
        emit dataChanged(modelIndex, modelIndex);
        return result;
    }

    return result;
}

void UserWordsModel::setTableName(const QVariantMap& name)
{
    const QString& tableName = name.value("tableName").toString();

    if (tableName == QSqlTableModel::tableName() || tableName == "") return;

    setTable(tableName);

    if (name.value("select").toBool()) select();

    emit tableNameChanged(tableName);
}

QHash<int, QByteArray> UserWordsModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[IdRole]          = "id";
    roles[WordRole]        = "word";
    roles[TranslationRole] = "translation";
    roles[AttemptRole]     = "attempt";
    roles[StreakRole]      = "streak";
    roles[DescriptionRole] = "description";
    roles[ActiveRole]      = "active";
    roles[DateRole]        = "date";

    return roles;
}
