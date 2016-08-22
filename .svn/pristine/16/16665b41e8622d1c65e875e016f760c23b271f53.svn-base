# -*- coding: utf-8 -*-
import sys
from PyQt4.QtCore import *
from PyQt4.QtGui import *



class MktWatch(QMainWindow):
    def __init__(self, parent=None):
        QMainWindow.__init__(self, parent)
        self.create_main_frame()

    def create_main_frame(self):

        self.setGeometry(300, 300, 500, 350)
        self.setWindowTitle('Market Watch v1.0')

        page = QWidget()
        self.button = QPushButton(u'券商板块实时跟踪', page)
        self.button.setGeometry(100, 100, 200, 150)

        vbox1 = QVBoxLayout()
        vbox1.addWidget(self.button)
        page.setLayout(vbox1)
        self.setCentralWidget(page)

        self.connect(self.button, SIGNAL('clicked()'), self.clicked)

    def clicked(self):
        QMessageBox.about(self, u'券商板块实时跟踪', u'开始监控')

'''
    def initUI(self):
        #self.textEdit = QtGui.QTextEdit()
        #self.setCentralWidget(self.textEdit)
        self.statusBar()
        openFile = QtGui.QAction(QtGui.QIcon('open.png'), 'Open', self)
        openFile.setShortcut('Ctrl+O')
        openFile.setStatusTip('Open new File')
        openFile.triggered.connect(self.showDialog)
        menubar = self.menuBar()
        fileMenu = menubar.addMenu('&File')
        fileMenu.addAction(openFile)
        self.setGeometry(300, 300, 350, 300)
        self.setWindowTitle('File dialog')
        self.show()


    def showDialog(self):
        fname = QtGui.QFileDialog.getOpenFileName(self, 'Open file',
                '/home')
        f = open(fname, 'r')
        with f:
            data = f.read()
            self.textEdit.setText(data)
'''

if __name__ == '__main__':
    app = QApplication(sys.argv)
    form = MktWatch()
    form.show()
    app.exec_()