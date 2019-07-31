#ifndef GROUPSMODEL_H
#define GROUPSMODEL_H

#include <QSqlTableModel>
#include <QSqlQuery>
#include <QDebug>

class GroupsModel : public QSqlTableModel
{
    Q_OBJECT
    Q_PROPERTY(int languageId WRITE setLanguageId NOTIFY languageIdChanged)
    Q_PROPERTY(int groupId WRITE setGroupId NOTIFY groupIdChanged)

public:
    enum GroupRoles {
        IdRole = Qt::UserRole,
        GroupNameRole,
        LanguageIdRole,
        PointsRole,
        LevelRole
    };
    Q_ENUM(GroupRoles)

    explicit GroupsModel(QObject* parent = nullptr);

    QVariant data(const QModelIndex& index, int role) const override;
    bool setData(const QModelIndex& index, const QVariant& value, int role) override;

public slots:
    void setLanguageId(const int languageId);
    void setGroupId(const int groupId);
    QVariant getRow(const int row, const int role);
    bool createNewGroup(const QString& groupName);
    bool deleteGroup(const QString& groupName);
    bool deleteGroup(const QModelIndex& index);
    void deleteAllGroups();

signals:
    void languageIdChanged(const int languageId);
    void groupIdChanged(const int groupId);

protected:
    QHash<int, QByteArray> roleNames() const override;

private:
    const char* groupsTableName{ "groups" };
    int languageId_ = -1;
    int groupId_    = -1;

};

#endif // GROUPSMODEL_H
