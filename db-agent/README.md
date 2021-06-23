<!--not to html-->

All commands assume ghcr.io/alex-ykozlov-cliproj/ registry. Replace with the registry correct for your project.

# Building
Build docker image: ` ./build-image.sh `

# Running in Docker on local machine

```sh
docker run --rm -it --name dbagent --env-file env.txt ghcr.io/alex-ykozlov-cliproj/appd-aws-ingestion/appd-dbagent:1.0.0
```

# Running in ECS

ECS taskdef is in `task.json`.
It already includes all ENV, Secrets and Roles.
`task.json` defines task family as `ecs-appd-dbagent-task`

1. Setup correct values for AppDynamics account and roles

2. Register ECS taskdef:
`aws ecs register-task-definition --cli-input-json file://task.json`

3. Create task:
  ```sh
  aws ecs run-task \
  --cluster appd-aws-test-Cluster-tGtIrtZwGlDL \
  --task-definition ecs-appd-dbagent-task \
  --enable-execute-command \
  --capacity-provider-strategy 'capacityProvider=FARGATE,weight=1,base=1' \
  --propagate-tags TASK_DEFINITION \
  --network-configuration 'awsvpcConfiguration={subnets=[...],securityGroups=[...]}'
  ```
  
## Running docekr-compose on Ubuntu (Reference)
```sh
sudo apt update
sudo apt install snapd
sudo systemctl unmask snapd.service
sudo systemctl enable snapd.service
sudo systemctl start snapd.service
sudo snap install docker

sudo curl -L "https://github.com/docker/compose/releases/download/1.26.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

docker–compose –version
```
