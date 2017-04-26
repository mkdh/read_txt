QT += qml quick
QT += serialport

CONFIG += c++11

SOURCES += main.cpp \
    cls_thread_serial_port.cpp \
    cls_file_io.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

HEADERS += \
    cls_thread_serial_port.h \
    cls_file_io.h
