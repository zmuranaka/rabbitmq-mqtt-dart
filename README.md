1. Pull rabbitmq from DockerHub

```shell
docker pull rabbitmq
```

2. Start up RabbitMQ and enable MQTT

```shell
docker run -d --hostname rabbit-host --name rabbit-server -p 8080:15672 -p 1883:1883 -e RABBITMQ_DEFAULT_USER=admin -e RABBITMQ_DEFAULT_PASS=sneaky rabbitmq:management
docker exec -it rabbit-server rabbitmq-plugins enable rabbitmq_mqtt
```

3. You can now visit the RabbitMQ management at `localhost:8080`. Log in with the credentials specified above ("admin" for the user and "sneaky" for the password).

4. If you look under "Ports and contexts", you should see mqtt listed at port 1883.

5. You can completely remove the server at any time

```shell
docker container rm -f rabbit-server
```
