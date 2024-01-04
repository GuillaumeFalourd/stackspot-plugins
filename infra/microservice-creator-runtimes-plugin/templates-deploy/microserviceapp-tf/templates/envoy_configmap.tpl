apiVersion: v1
kind: ConfigMap
metadata:
  name: configmap-${microservice_name}
  namespace: ${namespace}
data:
  envoy-config.yml: |
    static_resources:
      listeners:
        - address:
            socket_address:
              address: 0.0.0.0
              port_value: 8000
          filter_chains:
            - filters:
                - name: envoy.filters.network.http_connection_manager
                  typed_config:
                    "@type": type.googleapis.com/envoy.extensions.filters.network.http_connection_manager.v3.HttpConnectionManager
                    codec_type: auto
                    stat_prefix: ingress_http
                    route_config:
                      name: local_route
                      virtual_hosts:
                        - name: backend
                          domains:
                            - "*"
                          routes:
                            - match:
                                prefix: "/"
                                headers:
                                  - name: "dryRun"
                                    present_match: true
                              direct_response:
                                status: 200
                                body:
                                  inline_string: 'This is a direct response'
                            - match:
                                prefix: "/"
                              route:
                                cluster: service
                    http_filters:
                      - name: envoy.ext_authz
                        typed_config:
                          "@type": type.googleapis.com/envoy.extensions.filters.http.ext_authz.v3.ExtAuthz
                          transport_api_version: V3
                          failure_mode_allow: false
                          grpc_service:
                            google_grpc:
                              target_uri: 127.0.0.1:9191
                              stat_prefix: ext_authz
                            timeout: 0.5s
                      - name: envoy.filters.http.router
                        typed_config:
                          "@type": type.googleapis.com/envoy.extensions.filters.http.router.v3.Router
      clusters:
        - name: service
          connect_timeout: 0.25s
          type: strict_dns
          lb_policy: round_robin
          load_assignment:
            cluster_name: service
            endpoints:
              - lb_endpoints:
                  - endpoint:
                      address:
                        socket_address:
                          address: 127.0.0.1
                          port_value: ${port}
    admin:
      access_log_path: "/dev/null"
      address:
        socket_address:
          address: 0.0.0.0
          port_value: 8001
    layered_runtime:
      layers:
        - name: static_layer_0
          static_layer:
            envoy:
              resource_limits:
                listener:
                  example_listener_name:
                    connection_limit: 10000
            overload:
              global_downstream_max_connections: 50000