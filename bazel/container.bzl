load("@io_bazel_rules_docker//container:container.bzl", "container_push")

def sara_container_push(image,repository):
    container_push(
        name = "publish",
        format = "Docker",
        image = image,
        registry = "index.docker.io",
        repository = repository,
        tag = "main",
    )

    container_push(
        name = "publish_dev",
        format = "Docker",
        image = image,
        registry = "index.docker.io",
        repository = repository,
        tag = "dev",
    )
