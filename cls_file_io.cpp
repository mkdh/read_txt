#include "cls_file_io.h"
#include <QFile>
#include <QTextStream>

clsFileIO::clsFileIO()
{
}

QString clsFileIO::read()
{
    if (mSource.isEmpty()){
        emit error("source is empty");
        return QString();
    }
#if __APPLE__
    mSource = mSource.replace("file://","");
#else
    mSource = mSource.replace("file:///","");
#endif

    QFile file(mSource);
    QString fileContent;
    if ( file.open(QIODevice::ReadOnly) )
    {
        QTextStream t( &file );
        /*
        QString line;
        do {
            line = t.readLine();
            fileContent += line + "\r\n";
        } while (!line.isNull());
        */
        fileContent = t.readAll();
        file.close();
    } else {
        emit error("Unable to open the file");
        return QString();
    }

    return fileContent;
}

