local U = {}
local config = {}
local utils = require("branchsession.utils")

local function get_project_name()
    return vim.fn.fnamemodify(
        utils.shell("git rev-parse --show-toplevel"),
        ":t"
    )
end

local function notify_not_in_git_dir_err()
    vim.notify(
        "Need to be inside a git project!",
        vim.log.levels.ERROR,
        { title = "branchsession.nvim" }
    )
end

local function generate_session_filename()
    local session_root_dir = config.session_root_dir
    local branch = utils.shell("git rev-parse --abbrev-ref HEAD"):gsub("/", "-")
    local this_session_dir = session_root_dir .. get_project_name() .. "/"

    -- Create project session dir if doesn't exist
    vim.fn.system("mkdir " .. this_session_dir .. " > /dev/null 2>&1")

    return this_session_dir .. branch .. ".vim"
end

local function save_branch_session()
    if utils.inside_git_dir() then
        vim.cmd("mksession! " .. generate_session_filename())
    else
        notify_not_in_git_dir_err()
    end
end

local function load_branch_session()
    if utils.inside_git_dir() then
        vim.cmd("source " .. generate_session_filename())
    else
        notify_not_in_git_dir_err()
    end
end

local function delete_branch_session()
    if utils.inside_git_dir() then
        vim.cmd("silent! !rm " .. generate_session_filename())
    else
        notify_not_in_git_dir_err()
    end
end

function U.setup(opts)
    config.session_root_dir = vim.fn.expand(opts.session_root_dir)
        or vim.fn.expand("~/.vim/sessions/")

    vim.api.nvim_create_user_command("BranchSessionSave", function()
        save_branch_session()
    end, { nargs = 0 })
    vim.api.nvim_create_user_command("BranchSessionLoad", function()
        load_branch_session()
    end, { nargs = 0 })
    vim.api.nvim_create_user_command("BranchSessionDelete", function()
        delete_branch_session()
    end, { nargs = 0 })

    -- notify user if a branch session is available on startup
    if utils.inside_git_dir() then
        local session_file = generate_session_filename()
        if vim.fn.filereadable(session_file) == 1 then
            vim.notify(
                "A session is available for your current branch. Use `:BranchSessionLoad` to load it.",
                vim.log.levels.INFO,
                { title = "branchsession.nvim" }
            )
        end
    end
end

return U
