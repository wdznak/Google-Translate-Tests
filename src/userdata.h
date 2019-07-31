#ifndef USERDATA_H
#define USERDATA_H

#include <QString>

struct UserData
{
    int id = -1;
    QString userName{"none"};
    QString avatar{"defaultavatar.png"};
};

#endif // USERDATA_H
