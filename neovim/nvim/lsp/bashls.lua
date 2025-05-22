-- Node.js and npm are required
-- System wide:
-- sudo npm install -g n
-- sudo n stable
-- Or:
-- curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
-- nvm install stable
-- nvm alias default stable
return {
    cmd = { "bash-language-server", "start" },
    filetypes = {"bash", "sh"},
    root_markers = {".git"},
    settings = {
        bashIde = {
            globPattern = "*@(.sh|.inc|.bash|.command)"
        }
    }
}
