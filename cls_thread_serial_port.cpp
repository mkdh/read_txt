#include "cls_thread_serial_port.h"

clsThreadSerialPort::clsThreadSerialPort()
{

#if __APPLE__
    _setting_default = new QSettings();
#else
    _setting_default = new QSettings("/myapp.ini", QSettings::IniFormat);
#endif
    qDebug() << _setting_default->fileName();
}

clsThreadSerialPort::~clsThreadSerialPort()
{
    _b_running_time = false;
    msleep(3000);
    this->thread()->quit();
    this->thread()->wait(3000);
#if __APPLE__
    this->terminate();
#else
#endif
}

void clsThreadSerialPort::slot_send_to_qml(QString msg)
{
    emit signal_send_to_qml(msg);
}

void clsThreadSerialPort::set_setting_value(QString msg_key, QString msg_value)
{
    qDebug() << msg_key << msg_value;
    _setting_default->setValue(msg_key, msg_value);
}

QString clsThreadSerialPort::get_setting_value(QString msg_key)
{
    qDebug() << msg_key << _setting_default->value(msg_key).value<QString>();
    return _setting_default->value(msg_key).value<QString>();
}

// new method for open serial port
bool clsThreadSerialPort::slot_open_serial_port()
{
    serial.setPortName("COM5");
    serial.setBaudRate(QSerialPort::Baud9600);
    serial.setDataBits(QSerialPort::Data8);
    serial.setParity(QSerialPort::NoParity);
    serial.setStopBits(QSerialPort::OneStop);
    //http://stackoverflow.com/questions/28770862/qserialport-proper-sending-of-many-lines
    serial.setFlowControl(QSerialPort::SoftwareControl);//serial.setFlowControl(QSerialPort::NoFlowControl);

    if(!serial.isOpen())
    {
        serial.open(QIODevice::ReadWrite);
    }

    if(serial.isOpen())
    {
        //this->start();
        //http://stackoverflow.com/questions/26612852/how-does-readyread-work-in-qt
        connect(&serial, SIGNAL(readyRead()),this, SLOT(handleReadyRead()));
        slot_send_to_qml("serial.isOpen(): true");
        return true;
    }
    else
    {
        slot_send_to_qml("serial.isOpen(): false");
        return false;
    }
}

void clsThreadSerialPort::handleReadyRead()
{
    QByteArray qba_message;
    qba_message = serial.readAll();
    qba_command.append(qba_message);

    //simulator keyboard
    if(qba_command.indexOf("\r\n") > -1)
    {
        qba_message = qba_command.left(qba_command.indexOf("\r\n"));
        /*
        if(qba_message == " REPEAT")
        {
            input_command(qba_old_command);
        }
        else
        {
            input_command(qba_message);
            qba_old_command = qba_message;
        }
        qba_command.clear();
        slot_send_to_qml(qba_message);
        */
        emit signal_send_command(qba_message);

    }
    else {
        slot_send_to_qml(qba_message);
    }
    qDebug() << __func__ << qba_message << qba_command;
}

/* bad method by using thread to read serial port data
bool clsThreadSerialPort::open_serial_port()
{
    serial.setPortName("COM5");
    serial.setBaudRate(QSerialPort::Baud9600);
    serial.setDataBits(QSerialPort::Data8);
    serial.setParity(QSerialPort::NoParity);
    serial.setStopBits(QSerialPort::OneStop);
    //http://stackoverflow.com/questions/28770862/qserialport-proper-sending-of-many-lines
    serial.setFlowControl(QSerialPort::SoftwareControl);//serial.setFlowControl(QSerialPort::NoFlowControl);

    if(!serial.isOpen())
    {
        serial.open(QIODevice::ReadWrite);
    }

    if(serial.isOpen())
    {
        this->start();
        return true;
    }
    else
    {
        return false;
    }
}

void clsThreadSerialPort::run()
{
    slot_send_to_qml(QString(__func__) + ": trying open serial port...");

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
                        emit signal_send_command(command);
                    }
                    compare_input = compare_input.right(compare_input.length() - compare_input.indexOf("\r\n") - 2);
                }
            }
        }//while
    }//if
}
*/
