use std::env;
use std::fs;
use std::process;

const DIRS: [(isize, isize); 8] = [(0,-1), (1,0), (0,1), (-1,0),
                                   (-1,-1), (1, 1), (1, -1), (-1, 1)];

fn occupied_neighbors(board: &Vec<Vec<char>>, x: isize, y: isize) -> isize {
    DIRS.iter().map(|(dx, dy)| {
        board.get((y+dy) as usize)
             .and_then(|row| row.get((x+dx) as usize))
    }).fold(0, |sum, tile| {
        if let Some('#') = tile {
            sum + 1
        } else {
            sum
        }
    })
}

fn occupied_los(board: &Vec<Vec<char>>, x: isize, y: isize) -> isize {
    DIRS.iter().fold(0, |sum, (dx, dy)| {
        let mut cx: isize = x + dx;
        let mut cy: isize = y + dy;
        while let Some('.') = board.get(cy as usize)
                                   .and_then(|row| row.get(cx as usize)) {
            cx += dx;
            cy += dy;
        }
        if let Some('#') = board.get(cy as usize)
                                .and_then(|row| row.get(cx as usize)) {
            sum + 1
        } else {
            sum
        }
    })
}

fn part1(input: &str) -> usize {
    let mut board: Vec<Vec<char>> = input.lines()
                                         .map(str::to_string)
                                         .map(|l| l.chars().collect())
                                         .collect();
    let mut next: Vec<Vec<char>> = board.clone();

    loop {
        //println!();

        board.iter().enumerate()
             .for_each(|(row, line)| {
                 //println!("{}", line.iter().collect::<String>());
                 line.iter().enumerate().for_each(|(col, &tile)| {
                     next[row][col] = match (tile, occupied_neighbors(&board, col as isize, row as isize)) {
                         ('L', 0) => '#',
                         ('#', x) if x >= 4 => 'L',
                         //('#', x) => std::char::from_digit(x as u32,10).unwrap(),
                         _ => tile
                     }
                 })
             });

        if next == board {
            //println!("done");
            break;
        } else {
            std::mem::swap(&mut board, &mut next);
        }
    }

    return board.iter()
                .map(|row| row.iter().filter(|&tile| *tile == '#').count())
                .sum::<usize>();
}


fn part2(input: &str) -> usize {
    let mut board: Vec<Vec<char>> = input.lines()
                                         .map(str::to_string)
                                         .map(|l| l.chars().collect())
                                         .collect();
    let mut next: Vec<Vec<char>> = board.clone();

    loop {
        //println!();

        board.iter().enumerate()
             .for_each(|(row, line)| {
                 //println!("{}", line.iter().collect::<String>());
                 line.iter().enumerate().for_each(|(col, &tile)| {
                     next[row][col] = match (tile, occupied_los(&board, col as isize, row as isize)) {
                         ('L', 0) => '#',
                         ('#', x) if x >= 5 => 'L',
                         //('#', x) => std::char::from_digit(x as u32,10).unwrap(),
                         _ => tile
                     }
                 })
             });

        if next == board {
            //println!("done");
            break;
        } else {
            std::mem::swap(&mut board, &mut next);
        }
    }

    return board.iter()
                .map(|row| row.iter().filter(|&tile| *tile == '#').count())
                .sum::<usize>();
}

fn main() {
    let args = env::args().collect::<Vec<String>>();
    if args.len() != 2 {
        println!("usage: {} input_file", args[0]);
        process::exit(1);
    }

    let input = fs::read_to_string(&args[1]).expect("file err");

    println!("Part 1: {}", part1(&input));
    println!("Part 2: {}", part2(&input));
}
