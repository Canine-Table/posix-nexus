#include <QApplication>
#include <QTextEdit>

#include <QApplication>
#include <QTextEdit>
#include <QMainWindow>
#include <QMenuBar>
#include <QStatusBar>
#include <QFileDialog>
#include <QFile>
#include <QTextStream>

#include <QSystemTrayIcon>
#include <QTimer>
#include <QIcon>
#include <QMenu>
#include <QCloseEvent>
#include <QTabBar>
#include <QTabWidget>
#include <QKeySequence>
#include <QInputDialog>
#include <QString>
#include <QRandomGenerator>


class NxNotepad : public QMainWindow {
public:
	NxNotepad() {
		tabs = new QTabWidget(this);
		setCentralWidget(tabs);
		
		// create the first tab
		//
		//

		QString quote = randomQuote();

		QTextEdit *editor = new QTextEdit(this);
		editor->setPlainText(quote);

		QString title = quote.left(20) + "...";  // short tab label
		tabs->addTab(editor, title);
		tabs->setCurrentWidget(editor);
		tabs->setTabsClosable(true);
		tabs->tabBar()->installEventFilter(this);



		connect(tabs, &QTabWidget::tabCloseRequested, this, [this](int index) {
			QWidget *w = tabs->widget(index);
			tabs->removeTab(index);
			delete w;
		});

		tabs->tabBar()->setContextMenuPolicy(Qt::CustomContextMenu);

		connect(tabs->tabBar(), &QTabBar::customContextMenuRequested,
			this, [this](const QPoint &pos) {
				int index = tabs->tabBar()->tabAt(pos);
				if (index < 0) return;

				QMenu menu;
				QAction *rename = menu.addAction("Rename");
				QAction *close  = menu.addAction("Close");

				QAction *chosen = menu.exec(tabs->tabBar()->mapToGlobal(pos));
				if (chosen == rename) {
					bool ok;
					QString name = QInputDialog::getText(
						this, "Rename Tab", "New name:",
						QLineEdit::Normal,
						tabs->tabText(index), &ok
					);
					if (ok) tabs->setTabText(index, name);
				}
				if (chosen == close) {
					QWidget *w = tabs->widget(index);
					tabs->removeTab(index);
					delete w;
				}
			});

		QMenu *fileMenu = menuBar()->addMenu("File");

		QAction *openAction = fileMenu->addAction("Open");
		QAction *saveAction = fileMenu->addAction("Save");

		openAction->setShortcut(QKeySequence("Ctrl+O"));
		saveAction->setShortcut(QKeySequence("Ctrl+S"));

		connect(openAction, &QAction::triggered, this, &NxNotepad::openFile);
		connect(saveAction, &QAction::triggered, this, &NxNotepad::saveFile);

		setWindowTitle("Posix-Nexus Notepad");
		resize(600, 400);

		QTimer *timer = new QTimer(this);
		connect(timer, &QTimer::timeout, this, [this]() {
			statusBar()->showMessage(
			QDateTime::currentDateTime().toString("yyyy-MM-dd hh:mm:ss.zzz")
			);
		});
		timer->start(100);

		tray = new QSystemTrayIcon(this);
		tray->setIcon(QIcon::fromTheme("text-editor"));
		tray->setToolTip("Posix-Nexus Notepad");

		QMenu *trayMenu = new QMenu(this);
		QAction *showAction = trayMenu->addAction("Show");


		QAction *closeTabAction = fileMenu->addAction("Close Tab");
		connect(closeTabAction, &QAction::triggered, this, [this]() {
			int index = tabs->currentIndex();
			if (index != -1) {
				QWidget *w = tabs->widget(index);
				tabs->removeTab(index);
				delete w;
			}
		});
		closeTabAction->setShortcut(QKeySequence("Ctrl+C"));


		QAction *newTabAction = fileMenu->addAction("New Tab");
		connect(newTabAction, &QAction::triggered, this, [this]() {
			QTextEdit *editor = new QTextEdit(this);
			tabs->addTab(editor, "Untitled");
			tabs->setCurrentWidget(editor);
		});
		newTabAction->setShortcut(QKeySequence("Ctrl+T"));


		QAction *newWindow = fileMenu->addAction("New Window");
		connect(newWindow, &QAction::triggered, this, []() {
			NxNotepad *w = new NxNotepad();
			w->show();
		});
		newWindow->setShortcut(QKeySequence("Ctrl+W"));

		QAction *quitAction = trayMenu->addAction("Quit");
		connect(quitAction, &QAction::triggered, this, []() {
			QApplication::quit();
		});
		connect(quitAction, &QAction::triggered, qApp, &QApplication::quit);
		connect(tray, &QSystemTrayIcon::activated, this,
			[this](QSystemTrayIcon::ActivationReason reason) {
				if (reason == QSystemTrayIcon::Trigger) {
					toggleVisibility();
				}
			}
		);

		tray->setContextMenu(trayMenu);
		tray->show();
	}

	static QString randomQuote() {
		static const QStringList quotes = {
			"Talk is cheap. Show me the code. — Linus Torvalds",
			"Bad programmers worry about the code. Good programmers worry about data structures and their relationships. — Linus Torvalds",
			"Most good programmers do programming not because they expect to get paid, but because it is fun. — Linus Torvalds",
			"If you need more than 3 levels of indentation, you're screwed anyway. — Linus Torvalds",
			"I'm generally a very pragmatic person: that which works, works. — Linus Torvalds",
			"I like offending people, because I think people who get offended should be offended. — Linus Torvalds",
			"Software is like sex: it's better when it's free. — Linus Torvalds",
			"Only wimps use tape backup. Real men just upload their important stuff on FTP and let the rest of the world mirror it. — Linus Torvalds",
			"I'm a bastard. I have absolutely no clue why people can ever think otherwise. — Linus Torvalds",
			"Intelligence is the ability to avoid doing work, yet getting the work done. — Linus Torvalds",
			"If you think your users are idiots, only idiots will use it. — Linus Torvalds"
		};

		int idx = QRandomGenerator::global()->bounded(quotes.size());
		return quotes.at(idx);
	}

private:
	QTextEdit *editor;
	QSystemTrayIcon *tray;
	QTabWidget *tabs;

	bool eventFilter(QObject *obj, QEvent *event) override {
		if (obj == tabs->tabBar()) {
			if (event->type() == QEvent::MouseButtonDblClick) {
				// Create a new tab
				QTextEdit *editor = new QTextEdit(this);
				tabs->addTab(editor, "Untitled");
				tabs->setCurrentWidget(editor);
				return true; // event handled
			}
			if (event->type() == QEvent::MouseButtonRelease) {
				auto *me = static_cast<QMouseEvent*>(event);
				if (me->button() == Qt::MiddleButton) {
					int index = tabs->tabBar()->tabAt(me->pos());
					if (index != -1) {
						QWidget *w = tabs->widget(index);
						tabs->removeTab(index);
						delete w;
					}
				}
			}
		}
		return QMainWindow::eventFilter(obj, event);
	}

	void saveFile() {
		QTextEdit *editor = currentEditor();
		if (!editor) return;

		QString path = QFileDialog::getSaveFileName(this, "Save File");
		if (path.isEmpty()) return;

		QFile file(path);
		if (file.open(QIODevice::WriteOnly | QIODevice::Text)) {
			file.write(editor->toPlainText().toUtf8());
			tabs->setTabText(tabs->currentIndex(), QFileInfo(path).fileName());
		}
	}


	void openFile() {
		QString path = QFileDialog::getOpenFileName(this, "Open File");
		if (path.isEmpty()) return;

		QFile file(path);
		if (file.open(QIODevice::ReadOnly | QIODevice::Text)) {
			QTextEdit *editor = new QTextEdit(this);
			editor->setPlainText(QString::fromUtf8(file.readAll()));
			tabs->addTab(editor, QFileInfo(path).fileName());
			tabs->setCurrentWidget(editor);
		}
	}

	QTextEdit *currentEditor() {
		return qobject_cast<QTextEdit*>(tabs->currentWidget());
	}

	void toggleVisibility() {
		if (isVisible()) {
			setVisible(false);
		} else {
			showNormal();
			raise();
			activateWindow();
		}
	}
};

void NxApplication(QApplication *app)
{
	app->setStyleSheet(R"(
		QMainWindow {
			background-color: #1e1e1e;
		}
		QTextEdit {
			background-color: #1e1e1e;
			color: #dddddd;
			selection-background-color: #444444;
			font-family: monospace;
			font-size: 14px;
		}
		QMenuBar {
			background-color: #2b2b2b;
			color: #cccccc;
		}
		QMenuBar::item:selected {
			background-color: #3c3c3c;
		}
		QMenu {
			background-color: #2b2b2b;
			color: #cccccc;
		}
		QMenu::item:selected {
			background-color: #3c3c3c;
		}
	)");


}



int main(int argc, char *argv[]) {
	QApplication app(argc, argv);
	NxApplication(&app);
	NxNotepad window;
	window.show();
	return app.exec();
}

