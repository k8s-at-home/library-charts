module github.com/k8s-at-home/library-charts

go 1.16

require (
    github.com/Jeffail/gabs/v2 v2.6.1
    github.com/stretchr/testify v1.7.0
    helm.sh/helm/v3 v3.7.2
    sigs.k8s.io/yaml v1.3.0
)

replace (
    github.com/docker/distribution => github.com/docker/distribution v0.0.0-20191216044856-a8371794149d
    github.com/docker/docker => github.com/moby/moby v17.12.0-ce-rc1.0.20200618181300-9dc6525e6118+incompatible
)
