#/bin/bash

while [ 1 ]
do
    curl localhost:8081/actuator/prometheus | grep "jvm_memory_used_bytes{area=\"heap\",id=\"Tenured Gen\",}" | cut -d '}' -f 2 | xargs >> data.log
    sleep 1
done
