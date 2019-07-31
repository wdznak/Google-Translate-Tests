#include "importdata.h"
#include "wordmodel.h"
#include "initsqlitedb.h"
#include "languagesmodel.h"
#include "groupsmodel.h"
#include "groupwordsmodel.h"
#include "usersmodel.h"
#include "usermanager.h"
#include "userwordsmodel.h"
#include "gtestssqlqueries.h"

#include <QGuiApplication>
#include <QFont>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QStandardPaths>
#include <QString>
#include <QSqlTableModel>
#include <QtSql>
#include <QQmlEngine>
#include <QJSEngine>

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QCoreApplication::setOrganizationName("DWojcik");
    QCoreApplication::setApplicationName("GTests");

    QGuiApplication app(argc, argv);
    app.setFont(QFont("Roboto"));

    QSqlError err = initSqliteDb("gtestdb");
    if(err.type() != QSqlError::NoError) return -1;

    qmlRegisterType<GroupsModel>("wd.qt.groupsmodel", 1, 0, "GroupsModel");
    qmlRegisterType<GroupWordsModel>("wd.qt.groupwordsmodel", 1, 0, "GroupWordsModel");
    qmlRegisterType<ImportData>("wd.qt.importdata", 1, 0, "ImportData");
    qmlRegisterType<LanguagesModel>("wd.qt.languagesmodel", 1, 0, "LanguagesModel");
    qmlRegisterType<UserWordsModel>("wd.qt.userwordsmodel", 1, 0, "UserWordsModel");
    qmlRegisterUncreatableType<WordModel>("wd.qt.wordmodel", 1, 0, "WordModel", "Pls leave me alone");
    qmlRegisterType<WordModel>();
    qmlRegisterSingletonType<UsersModel>("wd.qt.usersmodel", 1, 0, "UsersModel", [](QQmlEngine *engine, QJSEngine *scriptEngine) -> QObject * {
        Q_UNUSED(engine)
        Q_UNUSED(scriptEngine)

        UsersModel *usersModel = new UsersModel{};
        return usersModel;
    });

    UserManager um;

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty(QStringLiteral("UserManager"), &um);
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    if (engine.rootObjects().isEmpty()) return -1;


    return app.exec();
}
