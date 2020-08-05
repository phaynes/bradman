use actix_web::{get, App, HttpServer, Responder, middleware};
use actix_web::middleware::Logger;
use env_logger::Env;
use actix_files as fs;


#[get("/")]
async fn index() -> impl 
Responder {
    format!("Fuck you CCP")
}

#[actix_rt::main]
async fn main() -> std::io::Result<()> {

    println!("Started http server: 127.0.0.1:8080");
    
    env_logger::from_env(Env::default().default_filter_or("info")).init();

    HttpServer::new(|| {
        App::new()
            .wrap(middleware::DefaultHeaders::new().header("X-Version", "0.1"))
            .wrap(Logger::default())
            .wrap(Logger::new("%a %{User-Agent}i"))
            .service(fs::Files::new("/static", ".")
                .show_files_listing()
                .use_last_modified(true)
            )
            .service(index)
    })
    .bind("0.0.0.0:8080")?
    .run()
    .await
}
