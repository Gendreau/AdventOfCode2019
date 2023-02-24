mod parse;

fn main() {
    let is_part_one = false;
    let target = 19690720;
    let input: Vec<String> = parse::read_lines("../inputs/2.txt");
    let input: Vec<&str> = input[0].split(",").collect();
    let input: Result<Vec<usize>, _> = input.iter().map(|x| x.parse()).collect();
    let mut input = input.unwrap();
    if is_part_one {
        input[1] = 12;
        input[2] = 2;
        println!("{:?}",evaluate(input.clone()));
    } else {
        let one = {
            let mut low = 1;
            let mut high = 100;
            let target = target - target%1000;
            loop {
                input[1] = (low + high)/2;
                let mut output = evaluate(input.clone());
                output -= output % 1000;
                if output < target {low = (low + high)/2;} 
                else if output > target {high = (low+high)/2;} 
                else {break (low+high)/2;}
            }
        };
        let two = {
            let mut low = 1;
            let mut high = 100;
            loop {
                input[2] = (low + high)/2;
                let output = evaluate(input.clone());
                if output < target {low = (low + high)/2;} 
                else if output > target {high = (low+high)/2;} 
                else {break (low+high)/2;}
            }
        };
        println!("{:?}", (100*one)+two);
    }
}

fn evaluate(mut input: Vec<usize>) -> usize {
    let mut index = 0;
    loop {
        let target = input[index+3];
        match input[index] {
            1 => input[target] = input[input[index+1]] + input[input[index+2]],
            2 => input[target] = input[input[index+1]] * input[input[index+2]],
            99 => break,
            _ => {
                println!("Error for value {}", input[index]);
                break;
            }
        };
        index+=4;
    }
    input[0]
}