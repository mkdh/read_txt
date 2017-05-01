#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <qqmlcontext.h>


#include "cls_thread_serial_port.h"
clsThreadSerialPort* g_cls_thread_serial_port = 0;
#include "cls_file_io.h"

#include <QDebug>
int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);


    QQmlApplicationEngine engine;
    QQmlContext *ctext = engine.rootContext();
    g_cls_thread_serial_port = new clsThreadSerialPort;
    ctext->setContextProperty("g_cls_thread_serial_port", g_cls_thread_serial_port);


    qmlRegisterType<clsFileIO, 1>("FileIO", 1, 0, "FileIO");
    engine.load(QUrl(QLatin1String("qrc:/main.qml")));

    return app.exec();
}

