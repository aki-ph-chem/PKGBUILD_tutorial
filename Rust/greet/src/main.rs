use std::env;
use std::process;
use greet;

fn main() {
    let args: Vec<_> = env::args().collect();
    if args.len() < 2 {
        eprintln!("No args");
        process::exit(1);
    }
    greet::run(args[1].as_str());
}
