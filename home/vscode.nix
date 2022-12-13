{
  self,
  pkgs,
  ...
}: {
  programs.vscode.package = self.lib.mkDummy pkgs "vscode";

  programs.vscode.extensions = with pkgs.vscode-extensions; [
    vscodevim.vim
    file-icons.file-icons
    usernamehw.errorlens
    eamodio.gitlens
    mkhl.direnv
    jnoortheen.nix-ide
    matklad.rust-analyzer
    tamasfe.even-better-toml
    serayuzgur.crates
    golang.go
    denoland.vscode-deno
    dbaeumer.vscode-eslint
    esbenp.prettier-vscode
    ms-azuretools.vscode-docker
    ms-vscode-remote.remote-ssh
  ];

  programs.vscode.userSettings = {
    terminal.integrated = {
      fontSize = 14;
      cursorStyle = "line";
      defaultProfile.osx = "zsh";
      shellIntegration.enabled = false;
    };

    editor = {
      fontSize = 14;
      fontFamily = "'JetBrainsMono Nerd Font Mono', Menlo, Monaco, monospace";
      bracketPairColorization.enabled = true;
      minimap.enabled = false;
      cursorBlinking = "solid";
      formatOnSave = true;
    };

    explorer = {
      confirmDelete = false;
      confirmDragAndDrop = false;
    };

    workbench = {
      startupEditor = "none";
      iconTheme = "file-icons";
    };

    git = {
      confirmSync = false;
      autofetch = true;
    };

    nix = {
      enableLanguageServer = true;
      serverPath = "nil";
      serverSettings.nil.formatting.command = ["alejandra"];
    };

    vim.useSystemClipboard = true;

    telemetry.telemetryLevel = "off";

    errorLens.enabledDiagnosticLevels = ["error" "warning"];

    typescript.updateImportsOnFileMove.enabled = true;
    javascript.updateImportsOnFileMove.enabled = true;
  };
}
