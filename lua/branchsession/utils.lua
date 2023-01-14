local U = {}

function U.shell(command)
    return vim.fn.trim(vim.fn.system(command))
end

function U.inside_git_dir()
    local _ = U.shell("git rev-parse --is-inside-git-dir")
    return vim.v.shell_error == 0
end

return U
