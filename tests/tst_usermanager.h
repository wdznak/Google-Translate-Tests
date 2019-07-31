#include "usermanager.h"
#include "userdata.h"

#include <gtest/gtest.h>
#include <gmock/gmock-matchers.h>

#include <QSqlQuery>

using namespace testing;

/*
 * Stub functions for UserManager class
 * As the app is very simple i am not extracting interface
 * to create mock for gtestssqlqueries.h
 * Interactions are checked by extra variables findUserCalls and createLangTabCalls
 */
class UserManagerFake: public UserManager
{
public:
    int findUserCalls = 0;
    int createLangTabCalls = 0;

private:
    UserData findUser_(const QString&) override {
        findUserCalls++;
        return UserData{1, "TestName", "testAvatar.png"};
    }

    bool createLanguageTable_(WordModel*, void*) override{
        createLangTabCalls++;
        return true;
    }

};

TEST(UserManager, HasDefaultUserWhenCreated)
{
    UserManager um;
    UserData ud;

    EXPECT_EQ(ud.id, um.id());
    EXPECT_EQ(ud.userName, um.userName());
    EXPECT_EQ(ud.avatar, um.avatar());
}

TEST(UserManager, HasValidUserInformationWhenLoggedIn)
{
    UserManagerFake um;
    QString userName;
    QObject::connect(&um, &UserManager::userChanged,
                     [&userName](const QString& var){ userName = var; });
    um.setUser("");

    EXPECT_EQ(1, um.id());
    EXPECT_EQ("TestName", um.userName());
    EXPECT_EQ("testAvatar.png", um.avatar());
    EXPECT_EQ(userName, um.userName());
    EXPECT_EQ(1, um.findUserCalls);
}

TEST(UserManager, CanNotChangeUserWhenIsSame)
{
    UserManagerFake um;
    um.setUser("");
    EXPECT_EQ(1, um.findUserCalls);

    bool signalEmited = false;
    QObject::connect(&um, &UserManager::userChanged,
                     [&signalEmited](){ signalEmited = true; });
    um.setUser("TestName");

    EXPECT_FALSE(signalEmited);
    EXPECT_EQ(1, um.findUserCalls);
}

TEST(UserManager, CanNotCreateLanguageTableWhenUserIsNotLoggedIn)
{
    UserManagerFake um;
    EXPECT_FALSE(um.createLanguageTable(nullptr));
    EXPECT_EQ(0, um.createLangTabCalls);
}

TEST(UserManager, DoesCreateLanguageTableWhenUserIsLoggedIn)
{
    UserManagerFake um;
    um.setUser("");

    EXPECT_TRUE(um.createLanguageTable(nullptr));
    EXPECT_EQ(1, um.createLangTabCalls);
}

TEST(UserManager, DoesNotLogoutWhenDefaultUser)
{
    UserManagerFake um;
    um.logout();

    bool signalEmited = false;
    QObject::connect(&um, &UserManager::userChanged,
                     [&](){ signalEmited = true;});

    EXPECT_FALSE(signalEmited);
}

TEST(UserManager, CanLogoutWhenUserLogged)
{
    UserManagerFake um;
    UserData ud;
    um.setUser("TestName");

    bool signalEmited = false;
    QString userName;
    QObject::connect(&um, &UserManager::userChanged,
                     [&](const QString& var){ signalEmited = true; userName = var; });

    um.logout();

    EXPECT_TRUE(signalEmited);
    EXPECT_EQ(ud.userName, userName);
}
