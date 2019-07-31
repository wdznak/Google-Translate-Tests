#ifndef USERWORDSMODEL_H
#define USERWORDSMODEL_H

#include <QSqlTableModel>
#include <QDebug>

class WordModel;

class UserWordsModel: public QSqlTableModel
{
    Q_OBJECT
    Q_PROPERTY(QVariantMap name WRITE setTableName NOTIFY tableNameChanged)

public:
    enum UserWordsRoles {
        IdRole = Qt::UserRole,
        WordRole,
        TranslationRole,
        AttemptRole,
        StreakRole,
        DescriptionRole,
        ActiveRole,
        DateRole
    };
    Q_ENUM(UserWordsRoles)

    explicit UserWordsModel(QObject* parent = nullptr);

    QVariant data(const QModelIndex& index, int role) const override;

    void setTableName(const QVariantMap& name);

public slots:
    bool rowExists(const QString& wordA, const QString& wordB) const;
    int idRow(const int wordId);
    bool addRows(WordModel* model);
    QVector<int> duplicatedRows(WordModel* model) const;
    bool setData(const QModelIndex& index, const QVariant& value, int role = Qt::EditRole) override;
    bool selectIds(const QList<QString>& list);

signals:
    void tableNameChanged(const QString& name);

protected:
    QHash<int, QByteArray> roleNames() const override;
};

#endif // USERWORDSMODEL_H
