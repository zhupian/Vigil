#![windows_subsystem = "windows"]
fn main() {
    std::process::exit(vigil_service::taskmgr::recover_main());
}
