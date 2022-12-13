load("@io_bazel_rules_docker//container:container.bzl", "container_push")

def sara_container_push(image,repository):
    container_push(
        name = "main_publish",
        format = "Docker",
        image = image,
        registry = "index.docker.io",
        repository = repository,
        tag = "main",
    )

    container_push(
        name = "sha1_main_publish",
        format = "Docker",
        image = image,
        registry = "index.docker.io",
        repository = repository,
        tag = "{GIT_SHA}",
    )

    container_push(
        name = "dev_publish",
        format = "Docker",
        image = image,
        registry = "index.docker.io",
        repository = repository,
        tag = "dev",
    )

    container_push(
        name = "sha1_dev_publish",
        format = "Docker",
        image = image,
        registry = "index.docker.io",
        repository = repository,
        tag = "{GIT_SHA}",
    )
