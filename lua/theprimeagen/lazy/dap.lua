return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "williamboman/mason.nvim",
    "jay-babu/mason-nvim-dap.nvim",
    "nvim-neotest/nvim-nio",
  },
 config = function()
    local dap = require("dap")
    local dapui = require("dapui")

    dapui.setup()

    require("mason-nvim-dap").setup({
      ensure_installed = { "codelldb" },
      automatic_setup = true,
    })

    -- DAP UI aç-kapa olayları
    dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
      dapui.close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
      dapui.close()
    end

    -- codelldb adapter tanımı
    local extension_path = vim.fn.stdpath("data") .. "/mason/packages/codelldb/extension/"
    local codelldb_path = extension_path .. "adapter/codelldb"

    dap.adapters.codelldb = {
      type = "server",
      port = "${port}",
      executable = {
        command = codelldb_path,
        args = { "--port", "${port}" },
      },
    }

    dap.configurations.cpp = {
      {
        name = "Launch file",
        type = "codelldb",
        request = "launch",
        program = function()
          return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
        end,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
      },
    }

    -- C dili için de aynısını kullan
    dap.configurations.c = dap.configurations.cpp

    -- Tuş atamaları
    vim.keymap.set("n", "<Leader>dr", function() dap.continue() end)
    --vim.keymap.set("n", "<F10>", function() dap.step_over() end)
    --vim.keymap.set("n", "<F11>", function() dap.step_into() end)
    vim.keymap.set("n", "<Leader>dx", function() require("dapui").toggle() end)
    vim.keymap.set("n", "<Leader>db", function() dap.toggle_breakpoint() end)
    vim.keymap.set("n", "<Leader>B", function()
      dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
    end)
  end,
}

