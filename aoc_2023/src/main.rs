use crate::HandType::{
    FiveOfAKind, FourOfAKind, FullHouse, HighCard, OnePair, ThreeOfAKind, TwoPair,
};
use std::cmp::Ordering;
use std::{
    fs,
    thread::{self, JoinHandle},
};

fn main() {
    // let hand = Hand::from("J233Q 789");
    // dbg!(hand);
    // let s7_ex1 = day7_1("../day7_ex.txt");
    // println!("{s7_ex1}");
    let s7_ex1 = day7_1("../day7.txt");
    println!("{s7_ex1}");
    // // dbg!(u64::MAX);
    // println!("----");
    // let five_1_ex = day5_1("./../day5_ex.txt");
    // println!("{five_1_ex}");
    // // let five_1_ex = day5_1("./../day5.txt");
    // // println!("{five_1_ex}");
    // let five_1_ex = day5_2("./../day5_ex.txt");
    // println!("{five_1_ex}");
    // // let five_1_ex = day5_2("./../day5.txt");
    // // println!("{five_1_ex}");
}

#[derive(Eq, PartialEq, Debug)]
struct Hand {
    cards: [u8; 5],
    type_: HandType,
    bid: u16,
}

impl From<&str> for Hand {
    fn from(value: &str) -> Self {
        let cards = value[..5]
            .chars()
            .clone()
            .map(|c| {
                if c.is_ascii_digit() {
                    // (c as u8) - 50
                    (c as u8) - 49
                } else {
                    match c {
                        // 'T' => 8,
                        // 'J' => 9,
                        'T' => 9,
                        'J' => 0,
                        'Q' => 10,
                        'K' => 11,
                        'A' => 12,
                        _ => panic!(),
                    }
                }
            })
            .collect::<Vec<u8>>()
            .try_into()
            .unwrap();
        let bid = value.split(' ').last().unwrap().parse().unwrap();
        let type_ = HandType::from(&cards);
        Hand { cards, type_, bid }
    }
}

impl PartialOrd<Self> for Hand {
    fn partial_cmp(&self, other: &Self) -> Option<Ordering> {
        if self == other {
            panic!()
            // Some(Equal)
        } else if self.type_ == other.type_ {
            Some(self.cards.cmp(&other.cards))
        } else {
            Some(self.type_.cmp(&other.type_))
        }
    }
}

impl Ord for Hand {
    fn cmp(&self, other: &Self) -> Ordering {
        self.partial_cmp(other).unwrap()
    }
}

fn day7_1(path: &str) -> u64 {
    let contents = fs::read_to_string(path).expect("Should have been able to read the file");

    let mut sorted = contents
        .lines()
        .map(|l| Hand::from(l))
        .collect::<Vec<Hand>>();
    sorted.sort();

    sorted
        .into_iter()
        .enumerate()
        .map(|(i, h)| ((i + 1) as u64) * h.bid as u64)
        .sum()
}

#[derive(Eq, PartialEq, Ord, PartialOrd, Debug)]
enum HandType {
    HighCard,
    OnePair,
    TwoPair,
    ThreeOfAKind,
    FullHouse,
    FourOfAKind,
    FiveOfAKind,
}

impl From<&[u8; 5]> for HandType {
    fn from(value: &[u8; 5]) -> Self {
        let mut map: [u8; 13] = [0; 13];
        value
            .iter()
            .for_each(|c| map[*c as usize] = map[*c as usize] + 1);
        let jokers = map[0];
        if jokers == 5 || jokers == 4 {
            return FiveOfAKind;
        }
        // let it = map.into_iter().filter(|x| *x != 0);
        let it = map[1..].into_iter().filter(|x| **x > 0);

        let no_joker_best = match (it.clone().min(), it.clone().max().unwrap()) {
            (Some(1), 1) => HighCard,
            (_, 2) if it.clone().filter(|x| **x == 2).count() == 2 => TwoPair,
            (_, 2) => OnePair,
            (Some(2), 3) => FullHouse,
            (_, 5) => FiveOfAKind,
            (_, 4) => FourOfAKind,
            (_, 3) => ThreeOfAKind,
            _ => panic!(),
        };

        match (no_joker_best, jokers) {
            (HighCard, 1) => OnePair,
            (HighCard, 2) => ThreeOfAKind,
            (HighCard, 3) => FourOfAKind,
            (HighCard, 4) => FiveOfAKind,
            (OnePair, 1) => ThreeOfAKind,
            (OnePair, 2) => FourOfAKind,
            (OnePair, 3) => FiveOfAKind,
            (TwoPair, 1) => FullHouse,
            (ThreeOfAKind, 1) => FourOfAKind,
            (ThreeOfAKind, 2) => FiveOfAKind,
            (FourOfAKind, 1) => FiveOfAKind,
            (x, 0) => x,
            _ => panic!(),
        }
    }
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

    let xs: Vec<JoinHandle<u64>> = seeds
        .chunks(2)
        .map(|s| s[0]..(s[0] + s[1]))
        .map(|range| {
            let maps = maps.clone();
            thread::spawn(move || {
                range
                    .map(|seed| {
                        maps.iter().fold(seed, |acc, e| {
                            e.iter().find_map(|m| m.check(acc)).or(Some(acc)).unwrap()
                        })
                    })
                    .min()
                    .unwrap()
            })
        })
        .collect();

    xs.into_iter().map(|t| t.join().unwrap()).min().unwrap()
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
