//! Guarded handle scan: `cargo run -p vigil-service --example handle_lockers
//! --release -- <absolute path>`. No service installation or elevation.
use std::time::Instant;

fn main() {
    if let Some(code) = vigil_service::run_mode() {
        std::process::exit(code);
    }
    let paths: Vec<_> = std::env::args().skip(1).collect();
    let start = Instant::now();
    let report = vigil_service::find_handle_lockers(paths);
    println!("{}", serde_json::to_string_pretty(&report).unwrap());
    eprintln!("scan: {:?}", start.elapsed());
}
