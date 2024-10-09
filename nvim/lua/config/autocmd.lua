-- colorscheme
vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		vim.cmd("colorscheme solarized-osaka")
	end
})

-- Each time a file is opened, automatically navigate to the directory where the file resides
vim.api.nvim_create_autocmd("BufEnter", {
	pattern = "*",
	callback = function()
		local dir = vim.fn.expand("%:p:h")
		vim.cmd("silent! lcd " .. vim.fn.fnameescape(dir))
	end
})
