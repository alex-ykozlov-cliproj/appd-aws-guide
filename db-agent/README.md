<!--not to html-->

All commands assume ghcr.io/alex-ykozlov-cliproj/ registry. Replace with the registry correct for your project.

# Building
Build docker image: ` ./build-image.sh `

# Running in ECS

ECS taskdef is in `task.json`.
It already includes all ENV, Secrets and Roles.
`task.json` defines task family as `ecs-appd-dbagent-task`

1. Setup correct values for AppDynamics account and roles

2. Register ECS taskdef:
`aws ecs register-task-definition --cli-input-json file://task.json`

3. Create task:
  ```
  aws ecs run-task \
  --cluster appd-aws-test-Cluster-tGtIrtZwGlDL \
  --task-definition ecs-appd-dbagent-task \
  --enable-execute-command \
  --capacity-provider-strategy 'capacityProvider=FARGATE,weight=1,base=1' \
  --propagate-tags TASK_DEFINITION \
  --network-configuration 'awsvpcConfiguration={subnets=[...],securityGroups=[...]}'
  ```
