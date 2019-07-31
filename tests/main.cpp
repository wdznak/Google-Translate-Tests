#include "tst_usermanager.h"
#include "tst_usersmodel.h"
#include "tst_importdata.h"
#include "environmentdb.h"

#include <gtest/gtest.h>

int main(int argc, char *argv[])
{
    ::testing::InitGoogleTest(&argc, argv);
    ::testing::AddGlobalTestEnvironment(new EnvironmentDB);
    return RUN_ALL_TESTS();
}
