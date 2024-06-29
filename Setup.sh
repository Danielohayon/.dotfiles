sudo apt update
sudo apt install --yes build-essential
sudo apt install fd-find
sudo apt-get --yes install ripgrep
sudo apt --yes install fzf
sudo apt install --yes zip
sudo apt install --yes npm
sudo apt-get update -y
sudo apt-get install -y xsel
sudo npm i -g pyright




python_version=$(python3 -c "import sys; version = sys.version_info; print(f'{version.major}.{version.minor}')")

# Install the corresponding venv package
if [[ $python_version ]]; then
    echo "Detected Python version: $python_version"
    sudo apt install "python${python_version}-venv"




# Install nvim
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf nvim-linux64.tar.gz

echo 'export PATH="$PATH:/opt/nvim-linux64/bin"' >> ~/.bashrc

# link nvim and tmux configurations
rm -rf ~/.config/nvim
ln -s ~/.dotfiles/.config/nvim ~/.config/nvim
