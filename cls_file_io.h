#ifndef CLS_FILE_IO_H
#define CLS_FILE_IO_H

#include <QObject>


class clsFileIO : public QObject
{
    Q_OBJECT

public:
    Q_PROPERTY(QString source
               READ source
               WRITE setSource
               NOTIFY sourceChanged)
    clsFileIO();

    Q_INVOKABLE QString read();

    QString source() { return mSource; }

public slots:
    void setSource(const QString& source) { mSource = source; }

signals:
    void sourceChanged(const QString& source);
    void error(const QString& msg);

private:
    QString mSource;
};

#endif // CLS_FILE_IO_H
