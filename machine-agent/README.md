<!--not to html-->

- All commands assume ghcr.io/alex-ykozlov-cliproj/ registry. Replace with the registry correct for your project.
- Dockerfile adds to the basic AppDynamcis machinr agent image 6 AWS extensions and configures them.
- See config.yml in each extension directory to customize
- It is assumed that all extensions share AWS credentias (key+secret)
- Both AppDynamics and AWS secrets are passed in as environment variables.
- src/startup.sh file applies ENV to the agent properties and updates extension config files with AWS credentials.

# Building
Build docker image: ` ./build-image.sh `

# Running in ECS

ECS taskdef is in `task.json`.
It already includes all ENV, Secrets and Roles.
`task.json` defines task familty as `ecs-appd-aws-ingestion-task`

1. Setup correct values for AppDynamics account and roles
2. Create SSM secret strings for task secrets

3. Register taskdef:
`aws ecs register-task-definition --cli-input-json file://task.json`

4. Create task:
  ```
  aws ecs run-task \
  --cluster appd-aws-test-Cluster-tGtIrtZwGlDL \
  --task-definition ecs-appd-aws-ingestion-task \
  --enable-execute-command \
  --capacity-provider-strategy 'capacityProvider=FARGATE,weight=1,base=1' \
  --propagate-tags TASK_DEFINITION \
  --network-configuration 'awsvpcConfiguration={subnets=[...],securityGroups=[...]}'
  ```
