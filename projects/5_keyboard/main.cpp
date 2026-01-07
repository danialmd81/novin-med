#include <QGuiApplication>
#include <QQmlApplicationEngine>

int main(int argc, char* argv[])
{
	qputenv("QT_IM_MODULE", QByteArray("qtvirtualkeyboard"));
	qputenv("QT_VIRTUALKEYBOARD_LAYOUT_PATH", QByteArray("/home/danial/Code/keyboard/QtQuick/VirtualKeyboard/Layouts"));
	qputenv("QT_VIRTUALKEYBOARD_LANGUAGES", QByteArray("en_US,fa_FA"));

	// Select a custom Virtual Keyboard style QML.
	// This must be set before the keyboard QML is loaded.
	// The style file is embedded by qrc.qrc as ":/KeyboardStyle.qml".
	// qputenv("QT_VIRTUALKEYBOARD_STYLE", QByteArray("qrc:/KeyboardStyle.qml"));

	QGuiApplication app(argc, argv);

	QQmlApplicationEngine engine;
	engine.addImportPath(QGuiApplication::applicationDirPath() + "/../../");
	const QUrl url(QStringLiteral("qrc:/keyboard/main.qml"));
	QObject::connect(
			&engine, &QQmlApplicationEngine::objectCreated, &app,
			[url](QObject* obj, const QUrl& objUrl)
			{
				if (!obj && url == objUrl)
					QCoreApplication::exit(-1);
			},
			Qt::QueuedConnection);
	engine.load(url);

	return app.exec();
}
