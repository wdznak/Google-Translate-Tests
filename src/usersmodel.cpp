#include "usersmodel.h"
#include "languagesmodel.h"

#include <QSqlRecord>
#include <QString>
#include <QVariant>
#include <QDebug>

UsersModel::UsersModel(QObject* parent)
    : QSqlTableModel(parent)
{
    setTable(usersTableName);
    setEditStrategy(QSqlTableModel::OnManualSubmit);
    select();
}

QVariant UsersModel::data(const QModelIndex& index, int role) const
{
    if (role < Qt::UserRole)
        return QSqlTableModel::data(index, role);

    const QSqlRecord sqlRecord = record(index.row());

    return sqlRecord.value(role - Qt::UserRole);
}

QModelIndexList UsersModel::findRow(const QVariant& item, int role) const
{
    return match(index(0, 0), role, item, 1, Qt::MatchFlags( Qt::MatchFixedString | Qt::MatchRecursive ));
}

bool UsersModel::rowExists(const QVariant &item, int role) const
{
    QModelIndexList result = match(index(0, 0), role, item, 1, Qt::MatchFlags( Qt::MatchFixedString | Qt::MatchRecursive ));

    return !result.isEmpty();
}

bool UsersModel::createUser(const QString& name, const QString& avatar)
{
    QSqlRecord newRecord = record();
    newRecord.setValue("name", name);
    newRecord.setValue("avatar", avatar);
    newRecord.setValue("points", 0);

    if (!insertRecord(rowCount(), newRecord))
        return false;

    return submitAll();
}

void UsersModel::deleteUser(const QString &name)
{
    QModelIndexList user = findRow(name, NameRole);

    if (!user.isEmpty()) {
        LanguagesModel languageModel;
        QModelIndex modelIndex = user.first();

        languageModel.deleteUserLanguages(data(modelIndex, IdRole).toInt());
        removeRow(modelIndex.row());
        submitAll();
    }
}

QHash<int, QByteArray> UsersModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[IdRole]     = "id";
    roles[NameRole]   = "name";
    roles[AvatarRole] = "avatar";

    return roles;
}
