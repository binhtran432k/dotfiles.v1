from ranger.api.commands import Command


class edir(Command):
    '''
    :edir [file|dir]

    Run edir on the selected file or dir.
    Default argument is current dir.
    '''
    def execute(self):
        self.fm.run('edir -q ' + self.rest(1))

    def tab(self, tabnum):
        return self._tab_directory_content()


class lg(Command):
    def execute(self):
        self.fm.run('lazygit ' + self.rest(1))


class ld(Command):
    def execute(self):
        self.fm.run('lazydocker ' + self.rest(1))


class v(Command):
    def execute(self):
        self.fm.run('nvim ' + self.rest(1))


class nv(Command):
    def execute(self):
        self.fm.run('neovide ' + self.rest(1))
