return {
	'echasnovski/mini.files',
	config = function()
		require('mini.files').setup{
			mappings = {
				close       = 'q',
				go_in       = 'I',
				go_in_plus  = 'i',
				go_out      = 'N',
				go_out_plus = 'n',
				reset       = '<BS>',
				reveal_cwd  = '@',
				show_help   = 'g?',
				synchronize = '=',
				trim_left   = '<',
				trim_right  = '>',
			}
		}
	end
}

