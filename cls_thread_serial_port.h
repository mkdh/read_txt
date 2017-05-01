#ifndef CLS_THREAD_SERIAL_PORT_H
#define CLS_THREAD_SERIAL_PORT_H

#include <QThread>
#include <iostream>
#include <QtSerialPort/QSerialPort>
//#include <QElapsedTimer>

#include <QDebug>
#include <QSettings>

//using namespace std;

class clsThreadSerialPort : public QThread
{
    Q_OBJECT
public:
    clsThreadSerialPort();
    ~clsThreadSerialPort();

private:
    void run();
    QSerialPort serial;
    //    QElapsedTimer timer;
    bool _b_running_time = true;
    QSettings* _setting_default;
public slots:
    void slot_send_to_qml(QString msg);
    void set_setting_value(QString msg_key,QString msg_value);
    QString get_setting_value(QString msg_key);
    bool open_serial_port();
signals:
    void signal_send_to_qml(QString msg);
    void signal_send_command(QString msg);
};

#endif // CLS_THREAD_SERIAL_PORT_H
