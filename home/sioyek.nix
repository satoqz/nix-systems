{
  self,
  pkgs,
  ...
}: {
  programs.sioyek.package = self.lib.mkDummy pkgs "sioyek";

  # https://github.com/ahrm/sioyek/blob/main/pdf_viewer/prefs.config
  programs.sioyek.config = {
    should_launch_new_window = "1";
    background_color = "1 1 1";
    status_bar_color = "1 1 1";
    status_bar_text_color = "0 0 0";
    status_bar_font_size = "14";
  };

  # https://github.com/ahrm/sioyek/blob/main/pdf_viewer/keys.config
  programs.sioyek.bindings = {
    "fit_to_page_width;fit_to_page_height;previous_page" = "u";
    "fit_to_page_width;fit_to_page_height;next_page" = "d";
    "fit_to_page_width;fit_to_page_height" = "f";
  };
}
