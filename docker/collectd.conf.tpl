Hostname "{{ .Env "COLLECTD_HOST" }}"

FQDNLookup false
Interval {{ .Env "COLLECTD_INTERVAL" }}
Timeout 2
ReadThreads 5

LoadPlugin write_http
<Plugin write_http>
    <Node "node1">
        URL "https://"{{ .Env "SPLUNK_HOST" }}":"{{ .Env "HTTP_PORT" }}"/services/collector/raw"
        Header "Authorization: Splunk "{{ .Env "HEC_TOKEN" }}""
        Format "JSON"
        VerifyPeer false
        VerifyHost false
        Metrics true
        StoreRates true
    </Node>
</Plugin>

LoadPlugin exec
<Plugin exec>
  Exec "collectd-docker-collector" "/usr/bin/collectd-docker-collector" "-endpoint" "unix:///var/run/docker.sock" "-host" "{{ .Env "COLLECTD_HOST" }}" "-interval" "{{ .Env "COLLECTD_INTERVAL" }}"
</Plugin>
