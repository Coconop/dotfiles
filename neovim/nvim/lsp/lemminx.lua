xml_settings = janus and janus.lemminx.xml_settings or {}
vim.notify("Java: " .. vim.inspect(xml_settings.xml.java), vim.log.levels.DEBUG)
vim.notify("XSD: " .. vim.inspect(xml_settings.xml.fileAssociations), vim.log.levels.TRACE)

-- -- TODO
--         xml_settings = {
--             xml = {
--                 -- Always sent by VSCode so...
--                 java = {
--                     home = 'JAVA_HOME'
--                 },
--                 server = {
--                     -- Set a custom folder path for cached XML Schemas
--                     workDir = vim.fn.expand('~/.lemminx'),
--                     -- extra VM arguments used to launch the XML Language Server
--                     vmargs = '-Xmx64M',
--                     -- If this setting is enabled, a binary version of the server will be launched even if Java is installed
--                     preferBinary = 'PATH/TO/lemminx',
--                     -- Specify the path of a custom binary version of the XML server to use. A binary will be downloaded if this is not set
--                     binary = {
--                         path = 'PATH/TO/lemminx',
--                         -- Command line arguments to supply to the binary server when the binary server is being used
--                         args = '',
--                         -- List of the SHA256 hashes of trusted copies of the lemminx (XML language server) binary.
--                         trustedHashes = {},
--                     }
--                 },
--                 fileAssociations = {
--                     {
--                         pattern = '**/pattern*.xml',
--                         systemId = vim.fn.expand('PATH/TO/XSD'),
--                     },
--                 },
--                 trace =
--                 {
--                     server = 'verbose'
--                 },
--                 validation = { enabled = true },
--                 format = {
--                     enabled = true,
--                     splitAttributes = false,
--                     joinContentLines = false,
--                 },
--                 catalogs = {},
--                 logs = { client = true },
--                 telemetry = { enabled = false },
--             },
--         }

return {
    cmd = {"lemminx"},
    filetypes = {"xml", "xsd", "xslt", "svg",},
    root_markers = {".git"},
    init_options = {
        settings = xml_settings,
        extendedClientCapabilities = {
            codeLens = { codeLensKind = { valueSet = { 'references' } } },
            actionableNotificationSupported = true,
            openSettingsCommandSupported = true,
            completionResolveSupported = true,
        },
    },
}
