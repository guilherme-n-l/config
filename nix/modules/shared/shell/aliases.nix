{
  # Nix
  ngc = "sudo nix-collect-garbage -d";

  # System Shutdown/Reboot
  sd = "sudo shutdown -h now";
  rb = "sudo shutdown -r now";

  # Fzf Directory Search
  fzfd = "fd --hidden --type d | fzf";

  # Lazygit
  lg = "lazygit";

  # Git
  gs = "git status";
  gc = "git commit";
  gcl = "git clone";
  gcfg = "git config";
  gco = "git checkout";
  gf = "git fetch origin";
  gp = "git pull";
  gP = "git push";
  gl = "git log --graph --abbrev-commit --decorate";
  gwa = "git worktree add";
  gwr = "git worktree remove";
  gwl = "git worktree list";
}
