# SessionTicketExtension problematic memory behavior

## TLDR;
Run
```
./gradlew dockerCreateDockerFile && docker-compose --compatibility up --build
```
Collect heap usage data (tenured gen) with
```
./log-mem-usage.sh
```
View it with
```
gnuplot -p -e 'plot "data.log" with linespoints'
```
or something else that could visualize numbers.

Without JVM parameters, i.e. the default

`-Djdk.tls.client.enableSessionTicketExtension=true`

, memory will climb until it reaches the roof and then collected as needed (because of the
sessioncache having softreferences), whereas with

`-Djdk.tls.client.enableSessionTicketExtension=false`

memory will behave in a way pre-java-14-applications have gotten ourselves used to,
rise initially and then flatline on a comfortable level, leaving plenty of room for
unexpected things to require memory. An example of this could be seen here:

With `-Djdk.tls.client.enableSessionTicketExtension=true` (default)
![Alt text](images/with-ste.png?raw=true "With jdk.tls.client.enableSessionTicketExtension=true")

With `-Djdk.tls.client.enableSessionTicketExtension=false`
![Alt text](images/without-ste.png?raw=true "With jdk.tls.client.enableSessionTicketExtension=true")

## The long version
TBD