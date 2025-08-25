return {
  "sschleemilch/slimline.nvim",
  opts = {
    bold = true,
    style = 'fg',
    components = {
      left = {
        'mode',
      },
      center = {
      },
      right = {
        'path',
        'git',
        'progress',
      }
    },
    hl = {
      secondary = 'Comment',
    },
    configs = {
      mode = {
        verbose = true,
        hl = {
          normal  = 'Boolean',
          visual  = 'Keyword',
          insert  = 'Statement',
          replace = 'Statement',
          command = 'Identifier',
          other   = 'Label',
        },
        format = {
          ['n']  =  { verbose = 'Normal',        short = 'N' },
          ['v']  =  { verbose = 'Visual',        short = 'V' },
          ['V']  =  { verbose = 'Visual_line',   short = 'V-L' },
          ['\22'] = { verbose = 'Visual_block',  short = 'V-B' },
          ['s']  =  { verbose = 'Select',        short = 'S' },
          ['S']  =  { verbose = 'Select_line',   short = 'S-L' },
          ['\19'] = { verbose = 'Select_block',  short = 'S-B' },
          ['i']  =  { verbose = 'Insert',        short = 'I' },
          ['R']  =  { verbose = 'Replace',       short = 'R' },
          ['c']  =  { verbose = 'Command',       short = 'C' },
          ['r']  =  { verbose = 'Prompt',        short = 'P' },
          ['!']  =  { verbose = 'Shell',         short = 'S' },
          ['t']  =  { verbose = 'Terminal',      short = 'T' },
          ['U']  =  { verbose = 'Unknown',       short = 'U' },
          ['qf'] =  { verbose = 'Quickfix_list', short = 'QF'},
          ['l']  =  { verbose = 'Location List', short = 'LL'},
          ['_g'] =  { verbose = '_None List',    short = '_'},
          ['_t'] =  { verbose = '_None List',    short = '_'},
          ['_l'] =  { verbose = '_None List',    short = '_'},
        },
      },
      path = {
        trunc_width = 8,
        truncate = {
          chars = 4,
        },
        hl = {
          primary = 'Normal',
        },
        icons = {
          modified = '[+]'
        }
      },
      git = {
        hl = {
          primary = 'String',
        },
      },
      filetype_lsp = {
        hl = {
          primary = 'String',
        },
      },
      progress = {
        follow = 'path',
        column = true,
      }
    },
  }
}
