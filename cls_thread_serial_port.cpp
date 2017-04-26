#include "cls_thread_serial_port.h"

clsThreadSerialPort::clsThreadSerialPort()
{
    serial.setPortName("COM5");
    serial.open(QIODevice::ReadWrite);

    serial.setBaudRate(QSerialPort::Baud9600);
    serial.setDataBits(QSerialPort::Data8);
    serial.setParity(QSerialPort::NoParity);
    serial.setStopBits(QSerialPort::OneStop);
    //http://stackoverflow.com/questions/28770862/qserialport-proper-sending-of-many-lines
    serial.setFlowControl(QSerialPort::SoftwareControl);//serial.setFlowControl(QSerialPort::NoFlowControl);

}

clsThreadSerialPort::~clsThreadSerialPort()
{
    _b_running_time = false;
    msleep(3000);
    this->thread()->quit();
    this->thread()->wait(3000);
}

void clsThreadSerialPort::run()
{
    slot_send_to_qml(QString(__func__) + ": trying open serial port...");

    while(!serial.isOpen())
    {
        if(_b_running_time == false)
        {
            return;
        }

        serial.open(QIODevice::ReadWrite);

    }

    if (serial.isOpen() && serial.isWritable())
    {
        slot_send_to_qml("Serial is open");

        QByteArray input;
        QByteArray compare_input;

        while(true)
        {
            if(_b_running_time == false)
            {
                return;
            }
            //output = "a";
            //serial.write(output);
            //serial.flush();
            //timer.start();
            // Sleep(80);
            // qDebug() << timer.elapsed();
            // serial.waitForBytesWritten(100);
            serial.waitForReadyRead(100);

            if(serial.bytesAvailable()> 0)
            {
                input = serial.readAll();
                compare_input.append(input);
                qDebug()<< input;
            }

            if(compare_input.length() > 0)
            {
                while(compare_input.indexOf("\r\n") >= 0)
                {
                    QByteArray command;
                    command = compare_input.left(compare_input.indexOf("\r\n"));
                    if(command.length() > 0)
                    {
                        slot_send_to_qml("command: " + command);
                    }
                    compare_input = compare_input.right(compare_input.length() - compare_input.indexOf("\r\n") - 2);
                }
            }

        }//while
    }//if

}

void clsThreadSerialPort::slot_send_to_qml(QString msg)
{
    emit signal_send_to_qml(msg);
}

void clsThreadSerialPort::set_setting_value(QString msg_key, QString msg_value)
{
    qDebug() << msg_key << msg_value;
    _setting_default.setValue(msg_key, msg_value);
}

QString clsThreadSerialPort::get_setting_value(QString msg_key)
{
    qDebug() << msg_key << _setting_default.value(msg_key).value<QString>();
    return _setting_default.value(msg_key).value<QString>();

}
