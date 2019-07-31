#ifndef LANGUAGESMODEL_H
#define LANGUAGESMODEL_H

#include <QSqlTableModel>
#include <QSqlQuery>
#include <QDebug>

class LanguagesModel : public QSqlTableModel
{
    Q_OBJECT
    Q_PROPERTY(int userId WRITE setUserId NOTIFY userChanged)

public:
    enum LanguageRoles {
        IdRole = Qt::UserRole,
        UserIdRole,
        TableNameRole,
        LangARole,
        LangBRole
    };
    Q_ENUM(LanguageRoles)

    explicit LanguagesModel(QObject* parent = nullptr);

    QVariant data(const QModelIndex& index, int role) const override;
    bool setData(const QModelIndex &index, const QVariant &value, int role) override;
    void deleteUserLanguages(const int userId);

public slots:
    void setUserId(const int userId);
    QVariant getFirstRow(const int role) const;
    int wordsCount(const QString& tableName);

signals:
    void userChanged(const int userId);

protected:
    QHash<int, QByteArray> roleNames() const override;

private:
    const char* languagesTableName{ "languages" };
    int userId_ = -1;
};

#endif // LANGUAGESMODEL_H
