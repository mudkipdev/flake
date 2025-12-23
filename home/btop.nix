{ config, pkgs, lib, ... }:

{
  programs.btop = {
    enable = true;

    # Use btop-rocm for AMD GPU support
    package = pkgs.btop-rocm;

    settings = {
      # Theme and appearance
      color_theme = "Default";
      theme_background = false; # Use terminal transparency
      truecolor = true;

      # Update interval (milliseconds)
      update_ms = 2000;

      # Shown boxes (cpu mem net proc gpu0)
      # Add gpu0 for GPU monitoring support
      shown_boxes = "cpu mem net proc gpu0";

      # CPU settings
      cpu_graph_upper = "total";
      cpu_graph_lower = "total";
      cpu_invert_lower = true;
      cpu_single_graph = false;
      show_uptime = true;
      check_temp = true;
      cpu_sensor = "Auto";
      show_coretemp = true;
      show_cpu_freq = true;

      # Memory settings
      mem_graphs = true;
      mem_below_net = false;
      show_swap = true;
      swap_disk = true;
      show_disks = true;

      # Network settings
      net_download = 100; # Mebibits
      net_upload = 100;   # Mebibits
      net_auto = true;
      net_sync = true;
      net_iface = "";     # Empty = auto
      show_battery = true;
      selected_battery = "Auto";

      # Graph symbols
      # Options: "braille", "block", "tty"
      graph_symbol = "braille";
      graph_symbol_cpu = "default";
      graph_symbol_mem = "default";
      graph_symbol_net = "default";
      graph_symbol_proc = "default";

      # Process settings
      proc_sorting = "cpu lazy";
      proc_reversed = false;
      proc_tree = false;
      proc_colors = true;
      proc_gradient = true;
      proc_per_core = false;
      proc_mem_bytes = true;
      proc_cpu_graphs = true;
      proc_info_smaps = false;
      proc_left = false;

      # Temperature scale
      # Options: "celsius", "fahrenheit", "kelvin", "rankine"
      temp_scale = "celsius";

      # Base 10 for bits/bytes
      base_10_sizes = false;

      # Clock format
      clock_format = "%X";

      # Background update
      background_update = true;

      # Custom CPU name
      custom_cpu_name = "";

      # Disk IO mode
      # Options: "io", "iops"
      disks_filter = "";
      io_mode = false;
      io_graph_combined = false;
      io_graph_speeds = "";

      # Log level
      # Options: "ERROR", "WARNING", "INFO", "DEBUG"
      log_level = "WARNING";
    };
  };
}
