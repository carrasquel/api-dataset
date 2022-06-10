# api-dataset

Have you ever wanted to access pre-populated APIs with dummy but valid data? It can be for something as simple as practicing backend integrations to frontend development practices. Under such circumstances, you have to either create dummy data with an api or utilize some Internet-searching skills to find data to populate your api. I think this is a common enough problem/requirement that solution can be Dockerized for reuse. So here is a Docker image for [PostgreSQL](https://www.postgresql.org/) with databases populated with sample data and a http API ready to be consume.

## Tags

Available tags are `dellstore`, `iso3166`,  `sportsdb`, `usda`, `world`, `all` and `latest`. `all` and `latest` are the same image with all the datasets in one image. Each of them has been loaded into their own database in the image. The rest of the tags belong to images single datasets.

## Usage

You can start the container by running:
```
docker run -d --name pg-ds-<tag> carrasquel/api-dataset:<tag>
```
and access it by:
```
docker exec -it pg-ds-<tag> psql -d <db_name>
```
where `<tag>` is one of the tags mentioned [here](#tags) and `<db_name>` is the database name which is one of the dataset names mentioned [here](#datasets). You can also use them with `docker-compose`. See [this example](https://github.com/aa8y/data-dude/blob/master/docker-compose.yml) for information on how to use them.

## Access

You can access the database schema with the next URL:

```
http://localhost:5000/resources
```

In here you will find the different entities available for the chose dataset, al CRUD operations are available for each entity, and the API also has **CORS** enabled so you can connect from different origins.
