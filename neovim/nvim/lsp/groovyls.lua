local home = vim.fn.expand("~")
local jar_path = vim.fs.joinpath(home,"git","groovy-language-server","build","libs","groovy-language-server-all.jar")

return {
    cmd = { "java", "-jar", jar_path },
    filetypes = { "groovy" },
    root_markers = { "Jenkinsfile", ".git"}
}
