# Cron job chart

The cron job chart can be used to run cron jobs in kubernetes.

The chart supports istio service mesh. In order to complete a job in a istio service mesh the envoy proxy needs to be stoped by the container running the job.

The recommended way to ensure a job running with istio is to do two checks:

Check to see if the envoy proxy is up and running BEFORE the job starts.

Endpoint to check status:

```.shell
http://127.0.0.1:15000/server_info
```

Terminate the envoy proxy AFTER the job finish.

Endpoint to quit envoy proxy:

```.shell
http://127.0.0.1:15000/quitquitquit
```
