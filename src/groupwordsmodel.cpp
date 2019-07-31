#include "groupwordsmodel.h"
#include <QDebug>

GroupWordsModel::GroupWordsModel(QObject* parent)
    : QSqlTableModel(parent)
{
    setTable(groupWordsTableName);
    //We sort by ID so elements insertion order is preserved
    //after setting the filter
    setSort(0, Qt::AscendingOrder);
    setEditStrategy(QSqlTableModel::OnManualSubmit);
}

QVariant GroupWordsModel::data(const QModelIndex& index, int role) const
{
    QVariant result;

    if (index.isValid()) {
        if (role < Qt::UserRole) {
            result = QSqlTableModel::data(index, role);
        } else {
            int columnIndex = role - Qt::UserRole;
            QModelIndex modelIndex = this->index(index.row(), columnIndex);

            result = QSqlTableModel::data(modelIndex, Qt::DisplayRole);
        }
    }

    return result;
}

void GroupWordsModel::setGroupId(const int groupId)
{
    if (groupId == groupId_) return;

    groupId_ = groupId;

    QString filter = QString("group_id = %1").arg(groupId_);
    setFilter( filter );
    select();

    emit groupIdChanged(groupId);
}

bool GroupWordsModel::wordIdExists(const QVariant& wordId)
{
    QModelIndex modelIndex = index(0, 0);
    QModelIndexList indexList = QSqlTableModel::match(modelIndex, WordIdRole, wordId, 1, Qt::MatchFlags(Qt::MatchExactly|Qt::MatchWrap));

    return indexList.count() > 0 ? true: false;
}

bool GroupWordsModel::addWordId(const int wordId)
{
    if (wordIdExists(wordId)) return false;

    QSqlTableModel::insertRow(rowCount());

    const int lastRow = rowCount() - 1;
    QSqlTableModel::setData(index(lastRow, GroupIdRole - Qt::UserRole), groupId_);
    QSqlTableModel::setData(index(lastRow, WordIdRole - Qt::UserRole), wordId);

    return submitAll();
}

bool GroupWordsModel::removeWordId(const int wordId)
{
    QModelIndex modelIndex = index(0, 0);
    QModelIndexList indexList = QSqlTableModel::match(modelIndex, WordIdRole, wordId, 1, Qt::MatchFlags(Qt::MatchExactly|Qt::MatchWrap));
    QSqlTableModel::removeRow(indexList.first().row());

    return submitAll();
}

QHash<int, QByteArray> GroupWordsModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[IdRole]      = "IdRole";
    roles[GroupIdRole] = "groupId";
    roles[WordIdRole]  = "wordId";

    return roles;
}

bool deleteGroupWords(const int groupId) {
    QString deletePrep = QString("DELETE FROM %1 WHERE group_id = :groupId").arg(groupWordsTableName);

    QSqlQuery deleteQuery;
    deleteQuery.prepare(deletePrep);
    deleteQuery.bindValue(":groupId", groupId);

    return deleteQuery.exec();;
}

