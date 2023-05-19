XDG_CONFIG_HOME=$(HOME)/.config

# .PHONY: install
# install: ## Sets up symlink for user and root .vimrc for vim and neovim.
# 	ln -snf "$(HOME)/.vim/vimrc" "$(HOME)/.vimrc"
# 	mkdir -p "$(XDG_CONFIG_HOME)"
# 	ln -snf "$(HOME)/.vim" "$(XDG_CONFIG_HOME)/nvim"
# 	ln -snf "$(HOME)/.vimrc" "$(XDG_CONFIG_HOME)/nvim/init.vim"
# 	sudo ln -snf "$(HOME)/.vim" /root/.vim
# 	sudo ln -snf "$(HOME)/.vimrc" /root/.vimrc
# 	sudo mkdir -p /root/.config
# 	sudo ln -snf "$(HOME)/.vim" /root/.config/nvim
# 	sudo ln -snf "$(HOME)/.vimrc" /root/.config/nvim/init.vim

.PHONY: update
update: update-vim-plug ## Updates vim-plug.

.PHONY: update-vim-plug
update-vim-plug: ## Updates vim-plug.
	sh -c 'curl -fLo ${HOME}/.config/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
