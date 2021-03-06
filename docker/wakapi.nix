{ config, pkgs, ... }:

{
    services.docker-compose.wakapi.config = {
        services.mysql = {
            image = "mysql:8.0";
            env_file = "/srv/docker/wakapi/.db.env";
            volumes = ["/srv/docker/wakapi/db:/var/lib/mysql"];
        };


        services.wakapi = {
            image = "ghcr.io/muety/wakapi:2.3.4";
            labels = [
                "traefik.enable=true"
                "traefik.http.routers.http-hakatime.entrypoints=web"
                "traefik.http.routers.http-hakatime.rule=Host(`time.fos.gg`)"
                "traefik.http.routers.http-hakatime.middlewares=web-redirect@file"
                "traefik.http.routers.hakatime.entrypoints=websecure"
                "traefik.http.routers.hakatime.rule=Host(`time.fos.gg`)"
                "traefik.http.routers.hakatime.tls=true"
                "traefik.http.routers.hakatime.middlewares=compress@file"
                "traefik.http.routers.hakatime.tls.certresolver=cf"
                "traefik.http.routers.hakatime.tls.domains[0].main=fos.gg"
                "traefik.http.routers.hakatime.tls.domains[0].sans=*.fos.gg"
            ];
            env_file = "/srv/docker/wakapi/.app.env";
            volumes = ["/srv/docker/wakapi/db:/var/lib/mysql"];
        };
    };
}