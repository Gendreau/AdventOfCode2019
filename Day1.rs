mod parse;

fn main() {
    let input = parse::read_lines("../inputs/1.txt");
    let is_part_one = false;
    let mut total = 0;
    for line in input {
        let mut m = line.parse::<i32>().unwrap();
        if is_part_one {
            total += m/3-2;
        }
        else {
            loop {
                m = m/3-2;
                if m <= 0 {
                    break;
                }
                total += m;
            }
        }
    }
    println!("{}", total);
}