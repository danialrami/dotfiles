return {
    "nomnivore/ollama.nvim",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    cmd = { "Ollama", "OllamaModel", "OllamaServe", "OllamaServeStop" },
    keys = {
      {
        "<leader>oo",
        ":<c-u>lua require('ollama').prompt()<cr>",
        desc = "ollama prompt",
        mode = { "n", "v" },
      },
      {
        "<leader>oG",
        ":<c-u>lua require('ollama').prompt('Generate_Code')<cr>",
        desc = "ollama Generate Code",
        mode = { "n", "v" },
      },
      {
        "<leader>oC",
        ":<c-u>lua require('ollama').prompt('Commit_Message')<cr>",
        desc = "ollama Generate Commit",
        mode = { "n", "v" },
      },
      {
        "<leader>oD",
        ":<c-u>lua require('ollama').prompt('Doc_String')<cr>",
        desc = "ollama Generate DocString",
        mode = { "n", "v" },
      },
    },
    opts = {
      model = "mistral",
      url = "http://siku.local:11434",
      serve = {
        on_start = false,
        command = "ollama",
        args = { "serve" }
      },
      prompts = {
        Generate_Code = {
          prompt = "Generate code based on the following description:\n$input",
          model = "phi4",
          action = "display",
        },
        Commit_Message = {
          prompt = "Generate a concise git commit message for the following changes:\n$input",
          model = "llama3.2",
          action = "display",
        },
        Doc_String = {
          prompt = "Generate a documentation string for the following code:\n$input",
          model = "mistral",
          action = "display",
        },
        Explain_Code = {
          prompt = "Explain what the following code does:\n$input",
          model = "phi4",
          action = "display",
        },
      },
      models = {
        {
          name = "phi4",
          params = {
            temperature = 0.7,
            top_k = 40,
            top_p = 0.9,
          }
        },
        {
          name = "mistral",
          params = {
            temperature = 0.8,
            top_k = 40,
            top_p = 0.9,
          }
        },
        {
          name = "llama3.2",
          params = {
            temperature = 0.7,
            top_k = 40,
            top_p = 0.9,
          }
        },
      }
    }
  }
  
