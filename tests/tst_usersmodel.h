#ifndef TST_USERSMODEL_H
#define TST_USERSMODEL_H

#include "usersmodel.h"

#include <gtest/gtest.h>

/*
 * Tests on existing Sqlite database
 * db is set in the environmentdb.h
 * Every interaction with db is and should be made in the transaction
 */
class UsersModelTest: public ::testing::Test
{
protected:
    virtual void SetUp() override {
        QSqlDatabase::database().transaction();
        um.createUser("TestName", "TestAvatar.png");
        um.createUser("TestName2", "TestAvatar2.png");
        um.createUser("TestName3", "TestAvatar3.png");
    }
    virtual void TearDown() override {
        QSqlDatabase::database().rollback();
    }

    UsersModel um;
};

TEST_F(UsersModelTest, CanCreateUser)
{
    EXPECT_EQ("TestName", um.data(um.index(0,0), um.NameRole));
    EXPECT_EQ("TestAvatar.png", um.data(um.index(0,0), um.AvatarRole));
}

TEST_F(UsersModelTest, CanDeleteUser)
{
    EXPECT_EQ(3, um.rowCount());

    um.deleteUser("TestName");
    EXPECT_EQ(2, um.rowCount());
}

TEST_F(UsersModelTest, RowExists)
{
    EXPECT_TRUE(um.rowExists("TestName", um.NameRole));
    EXPECT_TRUE(um.rowExists("testname", um.NameRole));
    EXPECT_TRUE(um.rowExists("TestAvatar.png", um.AvatarRole));
    EXPECT_FALSE(um.rowExists("TestNameX", um.NameRole));
}

TEST_F(UsersModelTest, CanFindRow)
{
    QModelIndexList mIndex = um.findRow("TestName", um.NameRole);
    EXPECT_EQ(1, mIndex.size());
}

#endif // TST_USERSMODEL_H
