#![allow(unused_variables)]
#![allow(dead_code)]
use anyhow::Result;
use opencv::{
    self,
    core::Mat,
    highgui::{self, imshow, named_window, WINDOW_AUTOSIZE},
    imgcodecs::imdecode,
    imgproc::COLOR_BGR2RGB,
};
use reqwest::blocking::Client;

fn main() -> Result<()> {
    let i = read_identifiers()?;
    println!("Hello, world!: {i:?}");
    let image_sample = get_cam_image()?;
    let window = named_window("hello", WINDOW_AUTOSIZE)?;
    imshow("hello", &image_sample)?;
    highgui::wait_key(10000)?;

    Ok(())
}

#[derive(Debug)]
struct Identifiers {
    pub car_id: u64,
    pub token: u64,
}

fn detect_objects(img: Mat) -> Result<()> {
    todo!();
}

fn read_identifiers() -> Result<Identifiers> {
    let contents = std::fs::read_to_string("my_identifiers.txt").unwrap();
    let car_id = contents
        .lines()
        .find(|l| l.contains("car_id"))
        .unwrap()
        .split(' ')
        .nth(1)
        .unwrap();
    let car_id = car_id.parse().unwrap();
    let token = contents
        .lines()
        .find(|l| l.contains("token"))
        .unwrap()
        .split(' ')
        .nth(1)
        .unwrap();
    let token = token.parse().unwrap();
    Ok(Identifiers { car_id, token })
}

const CAR_IP: &str = "http://192.168.0.105";
const CAM_1_URL: &str = "http://192.168.0.116:50051/frame";
const CAM_2_IP: &str = "http://192.168.0.107:50051";
const CAM_1_TOKEN: u64 = 983149;
const CAM_TOKEN: u64 = 378031;

fn get_cam_image() -> Result<Mat> {
    let client = Client::new();

    let res = client
        .get(CAM_1_URL)
        .header("Authorization", CAM_1_TOKEN)
        .send()?
        .error_for_status()?;
    dbg!(&res);
    let bytes = res.bytes()?;
    let img = imdecode(&bytes.as_ref(), COLOR_BGR2RGB)?;
    Ok(img)
}
