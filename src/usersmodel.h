#ifndef USERSMODEL_H
#define USERSMODEL_H

#include <QSqlTableModel>
#include <QDebug>

class QString;
class QVariant;

class UsersModel: public QSqlTableModel
{
    Q_OBJECT

public:
    enum UserRoles {
        IdRole = Qt::UserRole,
        NameRole,
        AvatarRole
    };
    Q_ENUM(UserRoles)

    explicit UsersModel(QObject* parent = nullptr);

    QVariant data(const QModelIndex& index, int role) const override;

public slots:
    bool createUser(const QString& name, const QString& avatar);
    void deleteUser(const QString& name);
    QModelIndexList findRow(const QVariant& item, int role) const;
    bool rowExists(const QVariant& item, int role) const;

protected:
    QHash<int, QByteArray> roleNames() const override;

private:
    const char* usersTableName{ "users" };
};

#endif // USERSMODEL_H
