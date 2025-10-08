use anyhow::Result;

fn main() -> Result<()>{
    let i = read_identifiers()?;
    println!("Hello, world!: {i:?}");
    let image_sample = get_cam_image()?;
    Ok(())
}


#[derive(Debug)]
struct Identifiers {
    pub car_id: u64,
    pub token: u64,
}

fn read_identifiers() -> Result<Identifiers> {
    let contents = std::fs::read_to_string("my_identifiers.txt").unwrap();
    let car_id = contents.lines().find(|l| l.contains("car_id")).unwrap().split(' ').nth(1).unwrap();
    let car_id = car_id.parse().unwrap();
    let token = contents.lines().find(|l| l.contains("token")).unwrap().split(' ').nth(1).unwrap();
    let token = token.parse().unwrap();
    Ok(Identifiers { car_id, token })
}


const car_ip: &str = "192.168.0.105";
const cam1_ip: &str = "192.168.0.116:50051";
const cam2_ip: &str = "192.168.0.107:50051";
const cam1_token: u64 = 983149;
const cam_token: u64 = 378031;

fn get_cam_image() -> Result<u64> {
    let res = reqwest::blocking::get(cam1_ip)?;
}