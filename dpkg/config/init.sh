# about .bashrc
if [ ! -e '.bashrc' ]; then
	touch .bashrc
fi
echo 'set -o vi' >> .bashrc

# install Rust & Cargo
curl > /dev/null 2>&1
if [ $? -ne 0 ];then
	apt install -y curl
fi
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# add PATH to Cargo
echo 'PATH=$PATH:$HOME/.cargo/bin' >> .bashrc

# update
/root/.cargo/bin/rustup update

# install cargo-deb
/root/.cargo/bin/cargo install cargo-deb 
