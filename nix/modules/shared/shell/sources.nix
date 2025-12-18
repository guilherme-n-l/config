{
  pkgs ? import <nixpkgs> { },
}:
[
  "${pkgs.zinit}/share/zinit/zinit.zsh"
  "${pkgs.fzf}/share/fzf/completion.zsh"
]
