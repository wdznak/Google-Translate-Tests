#ifndef GROUPWORDSMODEL_H
#define GROUPWORDSMODEL_H

#include <QSqlTableModel>
#include <QSqlQuery>

class GroupWordsModel : public QSqlTableModel
{
    Q_OBJECT
    Q_PROPERTY(int groupId WRITE setGroupId NOTIFY groupIdChanged)

public:
    enum GroupWordsRoles {
        IdRole = Qt::UserRole,
        GroupIdRole,
        WordIdRole
    };
    Q_ENUM(GroupWordsRoles)

    explicit GroupWordsModel(QObject* parent = nullptr);

    QVariant data(const QModelIndex& index, int role) const override;
    //friend bool deleteGroupWords(const int groupId);

public slots:
    void setGroupId(const int groupId);
    bool wordIdExists(const QVariant& wordId);
    bool addWordId(const int wordId);
    bool removeWordId(const int wordId);

signals:
    void groupIdChanged(const int groupIdChanged);

protected:
    QHash<int, QByteArray> roleNames() const override;

private:
    int groupId_ = -1;

};

static constexpr const char* groupWordsTableName = "group_words" ;
bool deleteGroupWords(const int groupId);

#endif // GROUPWORDSMODEL_H
