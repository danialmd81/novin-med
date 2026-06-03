#include <QGuiApplication>
#include <QQmlApplicationEngine>

int main(int argc, char* argv[])
{
	qputenv("QT_IM_MODULE", QByteArray("qtvirtualkeyboard"));

	QGuiApplication app(argc, argv);
	QString layoutPath = QGuiApplication::applicationDirPath() + "/../../QtQuick/VirtualKeyboard/Layouts";
	qputenv("QT_VIRTUALKEYBOARD_LAYOUT_PATH", layoutPath.toUtf8());

	QQmlApplicationEngine engine;
	engine.addImportPath(QGuiApplication::applicationDirPath() + "/../../");
	const QUrl url(QStringLiteral("qrc:/keyboard/main.qml"));
	QObject::connect(
		&engine,
		&QQmlApplicationEngine::objectCreated,
		&app,
		[url](QObject* obj, const QUrl& objUrl)
		{
			if (!obj && url == objUrl)
				QCoreApplication::exit(-1);
		},
		Qt::QueuedConnection);
	engine.load(url);

	return app.exec();
}
