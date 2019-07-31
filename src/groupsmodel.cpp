#include "groupsmodel.h"
#include "groupwordsmodel.h"
#include <QSqlRecord>
#include <QDebug>

GroupsModel::GroupsModel(QObject* parent )
    : QSqlTableModel(parent)
{
    setTable(groupsTableName);
    setEditStrategy(QSqlTableModel::OnManualSubmit);
}

QVariant GroupsModel::data(const QModelIndex &index, int role) const
{
    if (role < Qt::UserRole)
        return QSqlTableModel::data(index, role);

    const QSqlRecord sqlRecord = record(index.row());

    return sqlRecord.value(role - Qt::UserRole);
}

bool GroupsModel::setData(const QModelIndex &index, const QVariant &value, int role)
{
    if (!index.isValid()) return false;

    int columnIndex = role - Qt::UserRole;
    QModelIndex modelIndex = this->index(index.row(), columnIndex);

    if (!QSqlTableModel::setData(modelIndex, value, Qt::EditRole) || !submitAll())
        return false;

    emit dataChanged(index, index);
    return true;
}

void GroupsModel::setLanguageId(const int languageId)
{
    if (languageId == languageId_) return;

    languageId_ = languageId;

    QString filter = QString("language_id = %1").arg(languageId_);
    setFilter( filter );
    select();

    emit languageIdChanged(languageId_);
}

void GroupsModel::setGroupId(const int groupId)
{
    if (groupId == groupId_) return;

    groupId_ = groupId;
    QString filter;

    if (-1 == groupId_) {
        filter = "";
    } else {
        filter = QString("id = %1").arg(groupId_);
    }

    setFilter( filter );
    select();

    emit groupIdChanged(groupId_);
}

QVariant GroupsModel::getRow(const int row, const int role)
{
    return data(index(row, 0), role);
}

bool GroupsModel::createNewGroup(const QString& groupName)
{
    if (-1 == languageId_) return false;

    QSqlTableModel::insertRow(rowCount());

    const int lastRow = rowCount() - 1;
    QSqlTableModel::setData(index(lastRow, GroupNameRole - Qt::UserRole), groupName);
    QSqlTableModel::setData(index(lastRow, LanguageIdRole - Qt::UserRole), languageId_);

    return submitAll();
}

bool GroupsModel::deleteGroup(const QString& groupName)
{
    QModelIndex modelIndex = index(0, 0);
    QModelIndexList indexList = match(modelIndex, GroupNameRole, groupName, 1, Qt::MatchFlags(Qt::MatchExactly|Qt::MatchWrap));

    if (indexList.isEmpty()) return false;

    const auto index = indexList.first();
    if (!::deleteGroupWords(data(index, IdRole).toInt())) return false;

    removeRow(index.row());

    return submitAll();
}

bool GroupsModel::deleteGroup(const QModelIndex& index)
{
    if (!index.isValid() || !::deleteGroupWords(data(index, IdRole).toInt()))
        return false;

    removeRow(index.row());

    return submitAll();
}

void GroupsModel::deleteAllGroups()
{
    if (-1 == languageId_) return;

    setGroupId(-1);

    for (int i = 0; i < rowCount(); ++i) {
        deleteGroup(index(i,0));
    }

}

QHash<int, QByteArray> GroupsModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[IdRole]         = "id";
    roles[GroupNameRole]  = "groupName";
    roles[LanguageIdRole] = "languageId";
    roles[PointsRole]     = "points";
    roles[LevelRole]      = "level";

    return roles;
}
