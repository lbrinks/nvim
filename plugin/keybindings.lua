local bind = vim.keymap.set

bind('i', 'jk', '<Esc>')
bind('n', 'Y', 'y$')
bind('v', '>', '>gv')
bind('v', '<', '<gv')
bind('v', 'jk', '<Esc>')
bind('n', '<leader>w', ':w<CR>')
bind('n', '<leader>W', ':wq<CR>')
bind('n', '<leader>q', ':q<CR>')
bind('n', '<leader>Q', ':q!<CR>')
bind('n', '<leader>b', ':NvimTreeFocus<CR>')
bind('n', '<C-b>', ':NvimTreeToggle<CR>')
bind('i', '<C-b>', ':NvimTreeToggle<CR>')

-- terminal mode
bind('t','<Esc>' ,'<C-\\><C-n>')
bind('t','jk' ,'<C-\\><C-n>')
