local architectures = ["amd64","arm64"];

local version_6_0_0 =
{
    tag: "6.0.0",
    additional_tags: ["6.0"],
    dir: "6.0",

};

local version_5_1_0 =
{
    tag: "5.1.0",
    additional_tags: ["5","5.1","old-stable","latest"],
    dir: "5.1"
};

local version_6_1_0 =
{
    tag: "6.1.0",
    additional_tags: ["6.1","6","stable"],
    dir: "6.1",

};

local versions = [version_6_1_0, version_6_0_0, version_5_1_0];


local build_steps(versions,arch) = [
    {
        name: "Build " + version.tag,
        image: "quay.io/buildah/stable",
        privileged: true,
        volumes:
        [
        {
            name: "fedhq-ca-crt",
            path: "/etc/ssl/certs2/"

        }
        ],
        commands: [
            "scripts/setupEnvironment.sh",
            "cd " + version.dir + ";" + 'buildah bud --network host -t "registry.cloud.federationhq.de/redmine:' +version.tag + "-" + arch + '" --arch ' + arch,
            'buildah push --all registry.cloud.federationhq.de/redmine:'+version.tag + "-" + arch

        ]
    }
    for version in versions
];

local build_pipelines(architectures) = [
    {
        kind: "pipeline",
        type: "kubernetes",
        name: "build-"+arch,
        platform: {
            arch: arch
        },
        volumes:
            [
                {
                    name: "fedhq-ca-crt",
                    config_map:
                    {
                        name: "fedhq-ca-crt",
                        default_mode: 420,
                        optional: false
                    },

                }
            ],
        node_selector:
        {
            'kubernetes.io/arch': arch,
            'federationhq.de/compute': true
        },
        steps: build_steps(versions, arch),
    }
    for arch in architectures
];



local push_pipelines(versions, architectures) = [
    {
        kind: "pipeline",
        type: "kubernetes",
        name: "push-"+version.tag,
        platform: {
            arch: "amd64"
        },
        volumes:
            [
                {
                    name: "fedhq-ca-crt",
                    config_map:
                    {
                        name: "fedhq-ca-crt",
                        default_mode: 420,
                        optional: false
                    },

                }
            ],
        node_selector:
        {
            'kubernetes.io/arch': "amd64",
            'federationhq.de/compute': true
        },
        depends_on: [
            "build-"+arch
            for arch in architectures
        ],
        steps:
            [
                {
                    name: "Push " + version.tag,
                    image: "quay.io/buildah/stable",
                    privileged: true,
                    environment:
                        {
                            USERNAME:
                            {
                                from_secret: "username"
                            },
                            PASSWORD:
                            {
                                from_secret: "password"
                            }
                        },
                    volumes:
                    [
                        {
                            name: "fedhq-ca-crt",
                            path: "/etc/ssl/certs2/"

                        }
                    ],
                    commands:
                    [
                        "scripts/setupEnvironment.sh",
                        "buildah manifest create redmine:"+version.tag,
                    ]
                    +
                    [
                    "buildah manifest add redmine:" + version.tag + " registry.cloud.federationhq.de/redmine:"+version.tag + "-" + arch
                    for arch in architectures
                    ]
                    +
                    [
                        "buildah manifest push --all redmine:"+version.tag + " docker://registry.cloud.federationhq.de/redmine:"+tag
                        for tag in [version.tag]+version.additional_tags
                    ]
                    +
                    [
                        "buildah login -u $${USERNAME} -p $${PASSWORD} registry.hub.docker.com",
                    ]
                    +
                    [
                        "buildah manifest push --all redmine:"+version.tag + " docker://registry.hub.docker.com/byterazor/redmine:"+tag
                        for tag in [version.tag]+version.additional_tags
                    ]
                }
            ]
        }
        for version in versions
];

local push_github = {
    kind: "pipeline",
    type: "kubernetes",
    name: "mirror-to-github",
    node_selector: {
        "kubernetes.io/arch": "amd64",
        "federationhq.de/location": "Blumendorf",
        "federationhq.de/compute": true
    },
    steps: [
        {
            name: "github-mirror",
            image: "registry.cloud.federationhq.de/drone-github-mirror:latest",
            pull: "always",
            settings: {
                GH_TOKEN: {
                    from_secret: "GH_TOKEN"
                },
                GH_REPO: "byterazor/container-redmine",
                GH_REPO_DESC: "container for running redmine",
                GH_REPO_HOMEPAGE: "https://gitea.federationhq.de/Container/redmine"
            }
        }
    ],
    depends_on:
    [
        "push-"+version.tag
            for version in versions
    ]
};



    build_pipelines(architectures) + push_pipelines(versions,architectures) + [push_github] +
    [
{
    kind: "secret",
    name: "GH_TOKEN",
    get:{
        path: "github",
        name: "token"
    }
},
{
    kind: "secret",
    name: "username",
    get:{
        path: "docker",
        name: "username"
    }
},
{
    kind: "secret",
    name: "password",
    get:{
        path: "docker",
        name: "secret"
    }
}
    ]
