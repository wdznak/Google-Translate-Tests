#ifndef USERMANAGER_H
#define USERMANAGER_H

#include "gtestssqlqueries.h"
#include "userdata.h"

#include <QObject>

class WordModel;
class QString;

using namespace GTestsSqlQueries;

class UserManager: public QObject
{
    Q_OBJECT
    Q_PROPERTY(int id READ id NOTIFY userChanged)
    Q_PROPERTY(QString userName READ userName NOTIFY userChanged)
    Q_PROPERTY(QString avatar READ avatar NOTIFY userChanged)

public:
    explicit UserManager(QObject* parent = nullptr);

    int id() const;
    QString userName() const;
    QString avatar() const;

public slots:
    void setUser(const QString& userName);
    void logout();
    bool createLanguageTable(WordModel* model);

signals:
    void userChanged(const QString& userName);

private:
    UserData userData_;
    virtual UserData findUser_(const QString& userName);
    virtual bool createLanguageTable_(WordModel* model, void*);
};

#endif // USERMANAGER_H
