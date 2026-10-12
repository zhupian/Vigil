#![windows_subsystem = "windows"]
fn main() {
    std::process::exit(vigil_service::taskmgr::launcher_main());
}
