---
lang: EN_US
---

# Redmine Container Image

## Description

This repository contains the Containerfile and associated scripts for a container image that runs [Redmine](https://www.redmine.org/).

This Container Image is at the moment based on the original [Redmine Dockerfile](https://hub.docker.com/_/redmine)

This image includes the following additional plugins:

- https://github.com/Ilogeek/redmine_issue_dynamic_edit.git
- https://github.com/jgraichen/redmine_dashboard.git
- https://github.com/haru/redmine_wiki_extensions.git
- https://www.github.com/alphanodes/additionals.git
- https://www.github.com/alphanodes/additional_tags.git
- https://github.com/mikitex70/redmine_drawio.git
- https://github.com/alphanodes/redmine_messenger.git
- https://redmine.ociotec.com/attachments/download/581/scrum-0.23.1.tar.gz
- https://github.com/cat-in-136/redmine_hearts.git
- https://github.com/wellbia/redmine_microsoftteams.git
- https://github.com/redmica/redmica_ui_extension.git
- https://github.com/onozaty/redmine-view-customize.git
- https://github.com/haru/redmine_theme_changer.git
- https://gitea.federationhq.de/byterazor/redmine-git-remote.git
- https://gitea.federationhq.de/byterazor/redmine_glossary.git
- https://github.com/Intera/redmine_startpage.git
- https://github.com/eyp/redmine_spent_time.git
- https://github.com/tckz/redmine-wiki_graphviz_plugin.git
- https://github.com/jkraemer/redmine_percent_done.git
- https://github.com/alperenbozkurt/redmine_users_performance.git
- https://github.com/smoreau/redmine_documents_short.git
- https://github.com/akiko-pusu/redmine_issue_badge.git
- https://github.com/alphanodes/redmine_ref_issues.git


and the following themes:

- https://github.com/mrliptontea/PurpleMine2.git
- https://github.com/farend/redmine_theme_farend_bleuclair.git
- https://github.com/tantic/redmine_asap_theme.git
- https://github.com/PlockGames/redmine-plock-theme.git
- https://github.com/alexcode-cc/redmine-theme-dwarf-build.git
- https://github.com/jbbarth/redmine_theme_ministere.git
- https://github.com/tomy-shen/TW-Style.git
- https://github.com/Intera/redmine_theme_intera.git
- https://github.com/knt419/material.git
- https://github.com/alexcode-cc/redmine-theme-minimalflat2-build.git



## Usage

The same as the official Redmine Docker Image.


## Security

Unfortunatly, is the security of the original image very limitted. 

- rootfs can not be mounted readonly (requirement for kubernetes sucurity best practices)
- the image updates itself on restart  (suddenly container not working anymore if a problem witht he dependency exist, no rollback possible in kubernetes)

In the future a complete new Image is planned that will address these issues.

## Supported Architectures

- amd64
- arm64

## Updates

I am trying to update the image weekly as long as my private kubernetes cluster is available. So I do not promise anything and do **not** rely 
your business on this image.

## Prebuild Images

- https://hub.docker.com/repository/docker/byterazor/redmine/general


## Git Repository

- https://gitea.federationhq.de/Container/redmine

## Authors

- the authors of the original image 
- **Dominik Meyer** - *extending with plugins and themes* 

## License

This project is licensed under the GPLv2 License - see the [LICENSE](LICENSE) file for details.
