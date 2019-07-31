#include "usermanager.h"
#include "wordmodel.h"

UserManager::UserManager(QObject *parent): QObject(parent)
{
}

int UserManager::id() const {
    return userData_.id;
}

QString UserManager::userName() const {
    return userData_.userName;
}

QString UserManager::avatar() const {
    return userData_.avatar;
}

bool UserManager::createLanguageTable(WordModel *model)
{
    if(userData_.id == -1)
        return false;

    return createLanguageTable_(model, nullptr);
}

void UserManager::logout()
{
    if (userData_.userName != "none") {
        userData_ = UserData{};
        emit userChanged(userData_.userName);
    }
}

void UserManager::setUser(const QString &userName)
{
    /*
     * First check to avoid an unnecessary hit on the database
     */
    if(userData_.userName == userName)
        return;
    /*
     * Second check if we have found the record in the database
     */
    UserData userData = findUser_(userName);
    if ("" != userData.userName) {
        userData_ = userData;
        emit userChanged(userData_.userName);
    }
}

UserData UserManager::findUser_(const QString &userName)
{
    return User::findUser(userName);
}

bool UserManager::createLanguageTable_(WordModel *model, void*)
{
    return User::createLanguageTable(userData_, model);
}
