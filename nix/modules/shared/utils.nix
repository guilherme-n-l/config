{
  pkgs ? import <nixpkgs>,
}:
let
  lib = pkgs.lib;
  mkShellConfig =
    {
      prelude ? "",
      prefix ? "",
      quotePrefix ? false,
      suffix ? "\n",
      quoteSuffix ? false,
      finale ? "",
      list ? [ ],
      attrSet ? { },
      separator ? "",
      quoteKey ? false,
      quoteValue ? false,
    }:
    let
      ensureQuoted = cond: value: if cond then ''"${value}"'' else "${value}";

      prefixQuoted = ensureQuoted quotePrefix prefix; # "{PREFIX}"
      suffixQuoted = ensureQuoted quoteSuffix suffix; # "{SUFFIX}"

      # LIST
      listFiltered = lib.filter (x: x != "") list; # [ foo " " bar] -> [ foo bar ]
      listQuoted = lib.map (x: ensureQuoted quoteValue x) listFiltered; # [ "foo" ] -> [ ''"foo"'' ]
      listFullStrings = lib.map (x: prefixQuoted + x + suffixQuoted) listQuoted; # [ "foo" ] -> [ "{PREFIX}foo{SUFFIX}" ]
      listConcated = lib.concatStringsSep separator listFullStrings; # [ "foo" "bar" ] -> "foo{SEPARATOR}bar"

      # ATTRSET
      attrSetQuoted = lib.mapAttrs' (
        k: v: lib.nameValuePair (ensureQuoted quoteKey k) (ensureQuoted quoteValue v)
      ) attrSet; # { foo = "bar"; } -> { "\"foo\" = ''"bar"'' }
      attrSetList = lib.mapAttrsToList (
        k: v: prefixQuoted + k + separator + v + suffixQuoted
      ) attrSetQuoted; # { foo = "bar"; bazz = "foobar"; } -> [ "{PREFIX}foo{SEPARATOR}bar{SUFFIX}" "{PREFIX}bazz{SEPARATOR}foobar{SUFFIX}" ]
      attrSetConcated = lib.concatStringsSep "" attrSetList; # [ "foo" "bar" ] -> "foobar"

      # STRING
      data = if builtins.length list == 0 then attrSetConcated else listConcated;
    in
    prelude + data + finale;
  mkShellVariables =
    {
      vars,
      export ? true,
    }:
    mkShellConfig {
      prefix = if export then "export " else "";
      attrSet = vars;
      separator = "=";
      quoteValue = true;
    };
  mkShellAliases =
    aliases:
    mkShellConfig {
      prefix = "alias -- ";
      attrSet = aliases;
      separator = "=";
      quoteValue = true;
    };
  mkShellPath =
    paths:
    mkShellConfig {
      prelude = ''export PATH="'';
      suffix = "";
      separator = ":";
      finale = ''
        :$PATH"
      '';
      list = paths;
    };
  mkShellFunctions =
    fns:
    mkShellConfig {
      separator = "() {\n\t";
      suffix = "}\n";
      attrSet = lib.mapAttrs (
        _: v:
        let
          tabbed = lib.replaceStrings [ "\n" ] [ "\n\t" ] v;
          trimmed = lib.strings.removeSuffix "\n\t" tabbed;
        in
        trimmed + "\n"
      ) fns;
    };
  mkShellOpts =
    opts:
    mkShellConfig {
      prefix = "setopt ";
      list = opts;
    };
  mkShellBindkeys =
    binds:
    mkShellConfig {
      prefix = "bindkey ";
      separator = " ";
      attrSet = binds;
    };
  mkShellSources =
    sources:
    mkShellConfig {
      prefix = "source ";
      list = sources;
    };
  mkShellZinitPlugins =
    plugins:
    mkShellConfig {
      prefix = "zinit light ";
      list = plugins;
    };
  mkShellZstyles =
    styles:
    mkShellConfig {
      prefix = "zstyle ";
      list = styles;
    };
  mkShellZleWidgets =
    widgets:
    mkShellConfig {
      prefix = "zle -N ";
      list = widgets;
    };
  mkShellEvals =
    evals:
    mkShellConfig {
      prefix = "eval ";
      quoteValue = true;
      list = evals;
    };
  mkShellZshHooks =
    hooks:
    mkShellConfig {
      prelude = "autoload -Uz add-zsh-hook\n";
      prefix = "add-zsh-hook ";
      list =
        let
          listOfLists = lib.mapAttrsToList (k: v: (map (x: "${k} ${x}") v)) hooks; # { chpwd = [ "foo" ]; precmd = [ "bar" ]; } -> [ [ "chpwd foo" ] [ "precmd bar" ] ]
        in
        lib.flatten listOfLists;
    };
in
{
  inherit
    mkShellVariables
    mkShellAliases
    mkShellPath
    mkShellFunctions
    mkShellOpts
    mkShellBindkeys
    mkShellSources
    mkShellZinitPlugins
    mkShellZstyles
    mkShellZleWidgets
    mkShellEvals
    mkShellZshHooks
    ;
}
