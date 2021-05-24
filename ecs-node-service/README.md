<!--not to html-->


This example defines a task 'ecs-node-task' which runs a minimal nodeJS application in ECS.
The NodeJS application container is published at ghcr.io/alex-y-kozlov-sandbox/helloworld-k8s/helloworld-node:1.0.0

Instrumentation with AppDynamics agent happens at the runtime. The container image agent doesn't contain an agent.
Taskdef includes a container called `appd-agent` that contains a container image and on startup copies agent binaries into ephemeral storage shared between the agent and the application container.
Application container will start after agent container completes its copy operation.
NodeJS application is instrumented by inclusion of an environment variable ` NODE_OPTIONS="--require /opt/appdynamics/shim.js" `

# Running in ECS

ECS taskdef is in `task.json`.
It already includes all ENV, Secrets and Roles.
`task.json` defines task family as `ecs-node-task`

1. Setup correct values for AppDynamics account and roles

2. Register ECS taskdef:
`aws ecs register-task-definition --cli-input-json file://task.json`

3. Create service based on the taskdef in AWS Console
