-- render-markdown.nvim: in-buffer markdown rendering
-- Shows styled headings, tables, checkboxes, code blocks in normal mode
-- Reverts to raw markdown in insert mode
return {
  'MeanderingProgrammer/render-markdown.nvim',
  ft = { 'markdown' },
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'nvim-tree/nvim-web-devicons',
  },
  opts = {},
}
