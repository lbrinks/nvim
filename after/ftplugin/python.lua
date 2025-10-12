vim.keymap.set('n', '<F5>', ":w<CR>:exec '!python3' shellescape(@%, 1)<CR>")
vim.keymap.set('i',  '<F5>',"'<esc> :w<CR>:exec '!python3' shellescape(@%, 1)<CR>")
