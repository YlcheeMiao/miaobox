// Jupyter.keyboard_manager.edit_shortcuts.add_shortcut('Enter', 'jupyter-notebook:run-cell-and-select-next');
// https://github.com/lambdalisue/jupyter-vim-binding/wiki/Customization

require([
   'nbextensions/vim_binding/vim_binding',
], function() {
    CodeMirror.Vim.map("<C-x>", "<Esc>", "insert");
    CodeMirror.Vim.map("<C-o>", "<Esc>o", "insert");
    CodeMirror.Vim.map("<C-a>", "<Esc>^i", "insert");
    CodeMirror.Vim.map("<C-d>", "<Esc>$a", "insert");

    CodeMirror.Vim.map("<C-a>", "^", "normal");
    CodeMirror.Vim.map("<C-d>", "$", "normal");

    // Use Ctrl-h/j/k/l to move around in Insert mode
    CodeMirror.Vim.defineAction('[i]<C-h>', function(cm) {
        var head = cm.getCursor();
        CodeMirror.Vim.handleKey(cm, '<Esc>');
        if (head.ch <= 1) {
            CodeMirror.Vim.handleKey(cm, 'i');
        } else {
            CodeMirror.Vim.handleKey(cm, 'h');
            CodeMirror.Vim.handleKey(cm, 'a');
        }
    });
    CodeMirror.Vim.defineAction('[i]<C-l>', function(cm) {
        var head = cm.getCursor();
        CodeMirror.Vim.handleKey(cm, '<Esc>');
        if (head.ch === 0) {
            CodeMirror.Vim.handleKey(cm, 'a');
        } else {
            CodeMirror.Vim.handleKey(cm, 'l');
            CodeMirror.Vim.handleKey(cm, 'a');
        }
    });
    CodeMirror.Vim.mapCommand("<C-h>", "action", "[i]<C-h>", {}, { "context": "insert" });
    CodeMirror.Vim.mapCommand("<C-l>", "action", "[i]<C-l>", {}, { "context": "insert" });
    CodeMirror.Vim.map("<C-j>", "<Esc>ja", "insert");
    CodeMirror.Vim.map("<C-k>", "<Esc>ka", "insert");
});

// Configure Jupyter Keymap
require([
  'nbextensions/vim_binding/vim_binding',
  'base/js/namespace',
], function(vim_binding, ns) {
  // Add post callback
  vim_binding.on_ready_callbacks.push(function(){
    var km = ns.keyboard_manager;
    // Allow Ctrl-2 to change the cell mode into Markdown in Vim normal mode
    km.edit_shortcuts.add_shortcut('ctrl-2', 'vim-binding:change-cell-to-markdown', true);
    km.edit_shortcuts.add_shortcut('ctrl-1', 'vim-binding:change-cell-to-code', true);
    // Update Help
    km.edit_shortcuts.events.trigger('rebuild.QuickHelp');
  });
});
