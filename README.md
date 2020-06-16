# SessionTicketExtension problematic memory behavior

## Background
When upgrading to Java 14 one may notice a drastic change in memory usage when
regularly creating SSL connections (as shown here with a SSL-enabled postgresql database).
The reason seems to be the `-Djdk.tls.client.enableSessionTicketExtension=true` flag,
which was set true as default in Java 14, which in turn causes all handshake sessions to
be cached, even though the connections are just thrown away when their maxLifetime has expired.

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

To be able to spot the issue faster, I have set the Hikari connection pool to have a short
maxLifetime (30s) on its connections, but it will be the same with the default settings (1800s),
it will just take a little longer.

## The long version
TBD