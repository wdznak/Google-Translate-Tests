#include "languagesmodel.h"
#include "gtestssqlqueries.h"
#include "groupsmodel.h"

#include <QSqlRecord>
#include <QDebug>

using namespace GTestsSqlQueries;

LanguagesModel::LanguagesModel(QObject* parent)
    : QSqlTableModel(parent)
{
    setTable(languagesTableName);
    setEditStrategy(QSqlTableModel::OnFieldChange);
}

QVariant LanguagesModel::data(const QModelIndex& index, int role) const
{
    QVariant result;

    if (index.isValid()) {
        if(role < Qt::UserRole) {
            result = QSqlTableModel::data(index, role);
        } else {
            int columnIndex = role - Qt::UserRole;
            QModelIndex modelIndex = this->index(index.row(), columnIndex);

            result = QSqlTableModel::data(modelIndex, Qt::DisplayRole);
        }
    }

    return result;
}

bool LanguagesModel::setData(const QModelIndex &index, const QVariant &value, int role)
{
    if (!index.isValid()) return false;

    const int columnIndex = role - Qt::UserRole;
    const QModelIndex modelIndex = this->index(index.row(), columnIndex);

    if (!QSqlTableModel::setData(modelIndex, value, Qt::EditRole) || !submitAll())
        return false;

    emit dataChanged(index, index);
    return true;
}

void LanguagesModel::deleteUserLanguages(const int userId)
{
    setUserId(userId);
    int rows = rowCount();

    if (0 == rows) return;

    QModelIndex modelIndex;
    GroupsModel groupsModel;

    for (int i = 0; i < rows; ++i) {
        modelIndex = index(i,0);
        User::deleteLanguageTable(data(modelIndex, TableNameRole).toString());
        groupsModel.setLanguageId(data(modelIndex, IdRole).toInt());
        groupsModel.deleteAllGroups();

        removeRow(modelIndex.row());
    }
}

int LanguagesModel::wordsCount(const QString &tableName)
{
    QSqlQuery query;
    query.prepare(QString("SELECT COUNT(*) FROM ") + tableName);

    if(query.exec() && query.first()) {
        return query.value(0).toInt();
    }

    return -1;
}

QHash<int, QByteArray> LanguagesModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[IdRole]        = "id";
    roles[UserIdRole]    = "userId";
    roles[TableNameRole] = "tableName";
    roles[LangARole]     = "langA";
    roles[LangBRole]     = "langB";

    return roles;
}

void LanguagesModel::setUserId(const int userId)
{
    if(userId == userId_) return;

    userId_ = userId;

    QString filter = QString( "user_id = %1" ).arg(userId_);
    setFilter( filter );
    select();

    emit userChanged(userId_);
}

QVariant LanguagesModel::getFirstRow(const int role) const
{
    if (-1 == userId_) return QVariant();

    return data(index(0,0), role);
}
