# stackspot-plugins

[![Publish Github Plugins](https://github.com/GuillaumeFalourd/stackspot-plugins/actions/workflows/publish-github-plugins.yaml/badge.svg)](https://github.com/GuillaumeFalourd/stackspot-plugins/actions/workflows/publish-github-plugins.yaml) [![Publish Infra Plugins](https://github.com/GuillaumeFalourd/stackspot-plugins/actions/workflows/publish-infra-plugins.yaml/badge.svg)](https://github.com/GuillaumeFalourd/stackspot-plugins/actions/workflows/publish-infra-plugins.yaml) [![Publish Java Plugins](https://github.com/GuillaumeFalourd/stackspot-plugins/actions/workflows/publish-java-plugins.yaml/badge.svg)](https://github.com/GuillaumeFalourd/stackspot-plugins/actions/workflows/publish-java-plugins.yaml)

Repository with StackSpot plugins

## Plugins

### How to use

#### Plugin Schema V1

`stk apply plugin gha-auto-assign`: Plugin to add a auto-assign GitHub actions workflow

`stk apply plugin gha-gitleaks`: Plugin to add a gitleaks GitHub actions workflow

`stk apply plugin gha-horusec`: Plugin to add a horusec GitHub actions workflow

`stk apply plugin gha-super-linter`: Plugin to add a super-linter GitHub actions workflow

`stk apply plugin init-repo`: Plugin to init repository files

`stk apply plugin issues-templates`: Plugin to add issue templates to the GitHub repository

#### Plugin Schema V2

`stk apply plugin gha-stk-self-hosted`: Plugin to add a StackSpot Self Hosted Runtime GitHub actions workflow

`stk apply plugin java-spring-boot-base-plugin`: Plugin to add Java Spring Boot base implementation

`stk apply plugin java-feign-plugin`: Plugin to add Java Feign implementation
