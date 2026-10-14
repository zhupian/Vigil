//! Ordinary-permission identity and Windows idle-counter probe.
use std::time::{Duration, Instant};
fn main() {
    let cpu = vigil_core::hardware::cpu_info();
    println!(
        "CPU: {}, base {} MHz ({:?}), {} physical / {} logical",
        cpu.name, cpu.base_mhz, cpu.base_source, cpu.cores, cpu.logical
    );
    let mut collector = vigil_core::Collector::new(vigil_core::MetaStore::new());
    for _ in 0..4 {
        std::thread::sleep(Duration::from_secs(1));
        let start = Instant::now();
        let frame = collector.sample();
        let elapsed = start.elapsed();
        let idle = &frame.hardware.cpu_idle;
        let average = |field: fn(&vigil_core::hardware::CpuIdle) -> Option<f32>| {
            let values: Option<Vec<_>> = idle.iter().map(field).collect();
            values
                .filter(|v| !v.is_empty())
                .map(|v| v.iter().sum::<f32>() / v.len() as f32)
        };
        println!(
            "Windows idle: {} threads, C1 {:?}%, C2 {:?}%, C3 {:?}%; sample {:?}",
            idle.len(),
            average(|v| v.c1),
            average(|v| v.c2),
            average(|v| v.c3),
            elapsed
        );
    }
}
