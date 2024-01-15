use std::{fs, sync::mpsc::{self, Sender}, thread, time::Duration};

fn main() {
    let five_1_ex = day5_1("./../day5_ex.txt");
    println!("{five_1_ex}");
    let five_1_ex = day5_1("./../day5.txt");
    println!("{five_1_ex}");
    let five_1_ex = day5_2("./../day5_ex.txt");
    println!("{five_1_ex}");
    let five_1_ex = day5_2("./../day5.txt");
    println!("{five_1_ex}");
}

fn day5_1(path: &str) -> u64 {
    let contents = fs::read_to_string(path).expect("Should have been able to read the file");

    let mut lines = contents.lines();

    let seeds: Vec<u64> = lines
        .next()
        .unwrap()
        .split(" ")
        .filter_map(|w| w.parse::<u64>().ok())
        .collect::<Vec<u64>>();
    let _ = lines.next();
    let _ = lines.next();

    lol(lines, seeds)
}

fn day5_2(path: &str) -> u64 {
    let contents = fs::read_to_string(path).expect("Should have been able to read the file");

    let mut lines = contents.lines();

    let mut seeds: Vec<u64> = lines
        .next()
        .unwrap()
        .split(" ")
        .filter_map(|w| w.parse::<u64>().ok())
        .collect::<Vec<u64>>();

    let mut curr = 0;
    let mut seeds_with_range = Vec::new();

    while curr < seeds.len() {
        let x = seeds[curr];
        for i in 0..seeds[curr+1] {
            seeds_with_range.push(x+i);
        }
        curr+=2
    } //Lol already takes long, 1.7 billion!

    let _ = lines.next();
    let _ = lines.next();
    dbg!(&seeds_with_range.len());
    lol(lines, seeds_with_range)
}

fn lol(lines: std::str::Lines<'_>, seeds: Vec<u64>) -> u64 {
    let mut maps: [Vec<Mapping>; 7] = [
        Vec::new(),
        Vec::new(),
        Vec::new(),
        Vec::new(),
        Vec::new(),
        Vec::new(),
        Vec::new(),
    ];
    let mut current = 0;

    for line in lines {
        if line == "" {
            continue;
        }

        let mut x = line.split(" ").filter_map(|f| f.parse::<u64>().ok());
        let y = x.next();
        match y {
            Some(z) => maps[current].push(Mapping::from([z, x.next().unwrap(), x.next().unwrap()])),
            None => {
                current += 1;
                continue;
            }
        }
    }

    // let cores= 8;

    // let mut calcs: Vec<Sender<(u64, Sender<u64>)>> = Vec::with_capacity(cores);

    // for _ in 0..cores {
    //     let (tx, rx) = mpsc::channel();
    //     calcs.push(tx);
    //     let maps = maps.clone();
    //     thread::spawn(move || {
    //         loop {
    //             let rec = rx.recv_timeout(Duration::from_secs(10));
    //             match rec {
    //                 Ok((seed, return_tx)) => {
    //                    let res =  maps.iter().fold(seed, |acc, e| {
    //                         e.iter().find_map(|m| m.check(acc)).or(Some(acc)).unwrap()

    //                 });
    //                 return_tx.send(res).unwrap();
    //             },
    //                 _ => break
    //             }
    //         }
    //     });

    // }

    seeds
        .into_iter()
        .map(|s| {
            maps.iter().fold(s, |acc, e| {
                e.iter().find_map(|m| m.check(acc)).or(Some(acc)).unwrap()
            })
        })
        .min()
        .unwrap()
}

#[derive(Clone)]
struct Mapping {
    dest_start: u64,
    source_start: u64,
    range: u64,
}

impl Mapping {
    fn check(&self, inp: u64) -> Option<u64> {
        if inp >= self.source_start && inp < self.source_start + self.range {
            Some(inp - self.source_start + self.dest_start)
        } else {
            None
        }
    }
}

impl From<[u64; 3]> for Mapping {
    fn from(value: [u64; 3]) -> Self {
        Mapping {
            dest_start: value[0],
            source_start: value[1],
            range: value[2],
        }
    }
}
