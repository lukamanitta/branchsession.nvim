# branchsession.nvim

## Setup

```lua
require("branchsession").setup({
    session_root_dir = "my/session/root", -- Defaults to '~/.vim/sessions/'
})
```

## Commands

- `:BranchSessionSave` saves the session (same behaviour as `:mksession`)
- `:BranchSessionLoad` loads the session for the current branch, if one exists
- `:BranchSessionDelete` deletes the session
