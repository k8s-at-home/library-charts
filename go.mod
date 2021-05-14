module github.com/k8s-at-home/library-charts

go 1.16

require (
    github.com/stretchr/testify v1.7.0
    github.com/vmware-labs/yaml-jsonpath v0.2.0
    gopkg.in/yaml.v3 v3.0.0-20200313102051-9f266ea9e77c
    helm.sh/helm/v3 v3.5.4
)

replace (
    github.com/docker/distribution => github.com/docker/distribution v0.0.0-20191216044856-a8371794149d
    github.com/docker/docker => github.com/moby/moby v17.12.0-ce-rc1.0.20200618181300-9dc6525e6118+incompatible
)
