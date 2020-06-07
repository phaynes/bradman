
//#[global_allocator]
//static ALLOC: snmalloc_rs::SnMalloc = snmalloc_rs::SnMalloc;

//#[macro_use]
//extern crate serde_derive;

use actix_web::{get, web, App, HttpServer, Responder};

#[get("/")]
async fn index() -> impl 
Responder {
    format!("Fuck you CCP")
}

#[actix_rt::main]
async fn main() -> std::io::Result<()> {
    HttpServer::new(|| App::new().service(index))
        .bind("127.0.0.1:8080")?
        .run()
        .await
}
