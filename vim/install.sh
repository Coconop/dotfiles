# TODO Remove Vim installation ? (dangerous on shared machine)

# TODO ensure dependencies are satisfied
# sudo apt install git
# sudo apt install make
# sudo apt install clang
# sudo apt install libtool-bin

# UPDATE ME
local location="/usr/local"

WORK_DIR=$(pwd)

git clone https://github.com/vim/vim.git
cd vim/src

# Clear any previous attempt
make clean
make distclean

./configure \
	--with-features=huge \
	--enable-cscope \
	--enable-multibyte \
	#--enable-perlinterp=dynamic \
	#--enable-rubyinterp=dynamic \
	--enable-luainterp=dynamic \
	# CAREFUL CHECK CORRECT VERSION AND DIRECTORY
	--with-python3-config-dir=/usr/lib/python3.8/config-3.8-x86_64-linux-gnu \
	--with-python3-command=python3 \
	# TODO don't want the GUI but clipboard can be useful
	--enable-gui=auto \
	--enable-gtk3-check \
	--enable-gtk2-check \
	--enable-gnome-check \
	--with-x \
	--disable-netbeans \
	--enable-largefile \
	# Where to install it
	--prefix=${location} \
	# Greetings sir
	--with-compiledby="Coconop" \
	--enable-terminal \
	--enable-fontset \
	--enable-fail-if-missing

# Double check Makefile options
vi Makefile
# Build it
make
# Check for erros
make test
# Install it (sudo might not be required depending on '--prexix')
sudo make install

echo -e "Vim successfully installed in [${location}]"
${location}/vim --version

echo -e "Installing Plugins..."
vim -c 'PlugInstall' -c 'qa!'
cd ${WORK_DIR}
