{ ... }:
{
  perSystem =
    { pkgs, ... }:
    let
      # Kanagawa Dragon palette
      # bg=#181616  bgM=#282727  bgS=#393836
      # fg=#c5c9c5  comments=#625e5a
      kanagawaStyle = pkgs.writeText "glow-kanagawa-dragon.json" (
        builtins.toJSON {
          document = {
            block_suffix = "\n";
            margin = 2;
          };

          block_quote = {
            indent = 1;
            indent_token = "│ ";
            color = "#625e5a";
          };

          list = {
            level_indent = 2;
          };

          heading = {
            block_suffix = "\n";
            bold = true;
          };

          h1 = {
            prefix = " ";
            suffix = " ";
            color = "#c4b28a"; # dragonYellow
            background_color = "#282727"; # bgM
            bold = true;
          };

          h2 = {
            prefix = "## ";
            color = "#8ba4b0"; # dragonBlue2
            bold = true;
          };

          h3 = {
            prefix = "### ";
            color = "#87a987"; # dragonGreen
            bold = true;
          };

          h4 = {
            prefix = "#### ";
            color = "#a6a69c"; # dragonGray
            bold = true;
          };

          h5 = {
            prefix = "##### ";
            color = "#625e5a"; # dragonBlack6/comments
            bold = true;
          };

          h6 = {
            prefix = "###### ";
            color = "#625e5a";
          };

          strikethrough = {
            crossed_out = true;
          };

          emph = {
            color = "#a292a3"; # dragonPink
            italic = true;
          };

          strong = {
            color = "#c4b28a"; # dragonYellow
            bold = true;
          };

          hr = {
            color = "#393836"; # bgS
            format = "─";
          };

          item = {
            block_prefix = "• ";
          };

          enumeration = {
            block_prefix = ". ";
          };

          task = {
            ticked = "[✓] ";
            unticked = "[ ] ";
          };

          link = {
            color = "#8ba4b0"; # dragonBlue2
            underline = true;
          };

          link_text = {
            color = "#8ea4a2"; # dragonAqua
            bold = true;
          };

          image = {
            color = "#8ba4b0"; # dragonBlue2
            underline = true;
          };

          image_text = {
            color = "#8ea4a2"; # dragonAqua
            bold = true;
          };

          code = {
            prefix = " ";
            suffix = " ";
            color = "#b6927b"; # dragonOrange
            background_color = "#282727"; # bgM
          };

          code_block = {
            margin = 2;
            color = "#c5c9c5"; # dragonWhite
            background_color = "#12120f"; # dragonBlack1
            chroma = {
              text.color = "#c5c9c5";
              error.color = "#c4746e"; # dragonRed
              comment = {
                color = "#625e5a";
                italic = true;
              };
              comment_hashbang = {
                color = "#625e5a";
                italic = true;
              };
              comment_multiline = {
                color = "#625e5a";
                italic = true;
              };
              comment_preproc.color = "#8ba4b0"; # dragonBlue2
              comment_single = {
                color = "#625e5a";
                italic = true;
              };
              comment_special = {
                color = "#393836";
                bold = true;
                italic = true;
              };
              keyword = {
                color = "#8992a7"; # dragonViolet
                bold = true;
              };
              keyword_constant.color = "#b98d7b"; # dragonOrange2
              keyword_declaration = {
                color = "#8ba4b0"; # dragonBlue2
                bold = true;
              };
              keyword_namespace = {
                color = "#a6a69c"; # dragonGray
                bold = true;
              };
              keyword_pseudo.color = "#8ba4b0";
              keyword_reserved = {
                color = "#8ba4b0";
                bold = true;
              };
              keyword_type = {
                color = "#949fb5"; # dragonTeal
                bold = true;
              };
              operator.color = "#c4b28a"; # dragonYellow
              operator_word = {
                color = "#8992a7"; # dragonViolet
                bold = true;
              };
              punctuation.color = "#625e5a";
              name.color = "#c5c9c5";
              name_attribute.color = "#8ea4a2"; # dragonAqua
              name_builtin.color = "#8ba4b0"; # dragonBlue2
              name_builtin_pseudo.color = "#8ba4b0";
              name_class = {
                color = "#c4b28a"; # dragonYellow
                bold = true;
              };
              name_constant.color = "#b98d7b"; # dragonOrange2
              name_decorator.color = "#8ea4a2";
              name_entity.color = "#c4746e"; # dragonRed
              name_exception = {
                color = "#c4746e";
                bold = true;
              };
              name_function.color = "#8ea4a2"; # dragonAqua
              name_function_magic = {
                color = "#8ea4a2";
                italic = true;
              };
              name_label = {
                color = "#8ba4b0";
                bold = true;
              };
              name_namespace.color = "#c5c9c5";
              name_other.color = "#c5c9c5";
              name_tag = {
                color = "#8ba4b0";
                bold = true;
              };
              name_variable.color = "#c5c9c5";
              name_variable_class.color = "#c4b28a";
              name_variable_global.color = "#b98d7b";
              name_variable_instance.color = "#c5c9c5";
              name_variable_magic.color = "#8992a7"; # dragonViolet
              literal_string.color = "#87a987"; # dragonGreen
              literal_string_affix.color = "#87a987";
              literal_string_backtick.color = "#87a987";
              literal_string_char.color = "#87a987";
              literal_string_delimiter.color = "#c4746e"; # dragonRed
              literal_string_doc = {
                color = "#625e5a";
                italic = true;
              };
              literal_string_double.color = "#87a987";
              literal_string_escape.color = "#b98d7b"; # dragonOrange2
              literal_string_heredoc.color = "#87a987";
              literal_string_interpol.color = "#c4b28a"; # dragonYellow
              literal_string_other.color = "#87a987";
              literal_string_regex.color = "#a292a3"; # dragonPink
              literal_string_single.color = "#87a987";
              literal_string_symbol.color = "#b98d7b";
              literal_number.color = "#b6927b"; # dragonOrange
              literal_number_bin.color = "#b6927b";
              literal_number_float.color = "#b6927b";
              literal_number_hex.color = "#b6927b";
              literal_number_integer.color = "#b6927b";
              literal_number_integer_long.color = "#b6927b";
              literal_number_oct.color = "#b6927b";
              generic_deleted.color = "#c4746e"; # dragonRed
              generic_emph.italic = true;
              generic_error.color = "#c4746e";
              generic_heading = {
                color = "#c4b28a"; # dragonYellow
                bold = true;
              };
              generic_inserted.color = "#87a987"; # dragonGreen
              generic_output.color = "#625e5a";
              generic_prompt = {
                color = "#8ba4b0"; # dragonBlue2
                bold = true;
              };
              generic_strong.bold = true;
              generic_subheading = {
                color = "#8992a7"; # dragonViolet
                bold = true;
              };
              generic_traceback.color = "#c4746e";
              background.background_color = "#12120f";
            };
          };

          table = {
            center_separator = "┼";
            column_separator = "│";
            row_separator = "─";
          };

          definition_list = { };
          definition_term = { };
          definition_description = {
            block_prefix = "\n🠶 ";
          };
          html_block = { };
          html_span = { };
        }
      );
    in
    {
      packages.glow = pkgs.writeShellApplication {
        name = "glow";
        runtimeInputs = [ pkgs.glow ];
        text = ''
          exec glow --style "${kanagawaStyle}" "$@"
        '';
      };
    };
}
