### Zalando Postgresql Operator + Linkerd ###
It solves a common problem with k8s CronJobs that never get completed when being used in conjunction with Linkerd. 
This is a modified Logical-backup docker image by [Zalando postgres operator](https://github.com/zalando/postgres-operator). 
It uses [Linkerd-await](https://github.com/linkerd/linkerd-await) to gracefully shut down the Linkerd's sidecar container when the logical backup job is finished.