#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QtQml/QQmlEngine>
#include <QtQml/QQmlComponent>
#include <QtQuick/QQuickWindow>
#include "datebackend.h"
#include "datamaster.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    qmlRegisterType<DateBackEnd>("stan.date", 1, 0, "DateBackEnd");
    qmlRegisterType<DataMaster>("stan.date", 1, 0, "DataMaster");

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();

}
