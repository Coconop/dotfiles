return {
    local jar_path = vim.fn.glob(vim.fn.expand("~/git/groovy-language-server/build/libs/*all.jar"))
    cmd = { "java", "-jar" },
    filetypes = { "groovy" },
}
