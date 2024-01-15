use std::{
    fs,
    ops::Range,
    sync::mpsc::{self, Sender},
    thread,
};

fn main() {
    // dbg!(u64::MAX);
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

    lol(lines, seeds.into_iter())
}

fn day5_2(path: &str) -> u64 {
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

    let threads = seeds.len();
    // let threads = 16;

    let mut calcs: Vec<Sender<(Range<u64>, Option<Sender<u64>>)>> = Vec::with_capacity(threads);

    for i in 0..threads {
        let (tx, rx) = mpsc::channel();
        calcs.push(tx);
        let maps = maps.clone();
        let builder = thread::Builder::new().name(i.to_string());

        builder
            .spawn(move || {
                let mut my_min = u64::MAX;
                loop {
                    let rec = rx.recv();
                    match rec {
                        Ok((seeds, None)) => {
                            my_min = seeds
                                .map(|seed| {
                                    maps.iter().fold(seed, |acc, e| {
                                        e.iter().find_map(|m| m.check(acc)).or(Some(acc)).unwrap()
                                    })
                                })
                                .min()
                                .unwrap();
                        }
                        Ok((_, Some(return_tx))) => {
                            return_tx.send(my_min).unwrap();
                            break;
                        }
                        _ => panic!(),
                    }
                }
            })
            .unwrap();
    }

    seeds
        .chunks(2)
        .map(|s| s[0]..(s[0] + s[1]))
        .enumerate()
        .for_each(|(ix, range)| calcs[ix % threads].send((range, None)).unwrap());

    calcs
        .into_iter()
        .map(|c| {
            let (tx, rx) = mpsc::channel();
            c.send((0..0, Some(tx))).unwrap();
            rx.recv().unwrap()
        })
        .min()
        .unwrap()

}

fn lol(lines: std::str::Lines<'_>, seeds: impl Iterator<Item = u64>) -> u64 {
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

    seeds
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
