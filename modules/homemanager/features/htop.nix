{ ... }:
{

  programs.htop.enable = true;

  programs.htop.settings = {
    hide_kernel_threads = true;
    hide_userland_threads = true;
    hide_running_in_container = false;
    shadow_other_users = true;
    show_thread_names = true;
    show_program_path = false;
    highlight_base_name = true;
    highlight_deleted_exe = true;
    highlight_threads = true;
    find_comm_in_cmdline = true;
    strip_exe_from_cmdline = true;
    show_merged_command = true;
    header_margin = true;
    cpu_count_from_one = 1;
    tree_view = true;
  };
}
