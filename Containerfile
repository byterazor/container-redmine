FROM docker.io/redmine:5.1

RUN apt-get -qy update && apt-get -qy upgrade && apt-get -qy install git 
#libffi-dev make gcc nodejs

RUN cd /usr/src/redmine/plugins;git clone https://github.com/Ilogeek/redmine_issue_dynamic_edit.git
#RUN cd /usr/src/redmine/plugins;git clone https://github.com/akpaevj/dashboard.git
RUN cd /usr/src/redmine/plugins;git clone https://github.com/haru/redmine_wiki_extensions.git; cd redmine_wiki_extensions; git checkout 0.9.5

RUN cd /usr/src/redmine/plugins;git clone -b stable https://www.github.com/alphanodes/additionals.git
RUN cd /usr/src/redmine/plugins;git clone -b stable https://www.github.com/alphanodes/additional_tags.git

RUN apt-get -qy install unzip
RUN cd /usr/src/redmine/plugins;wget https://redmine-kanban.com/files/redmine_kanban.zip; unzip redmine_kanban.zip

RUN cd /usr/src/redmine/plugins;git clone https://github.com/mikitex70/redmine_drawio.git
RUN cd /usr/src/redmine/plugins;git clone https://github.com/alphanodes/redmine_messenger.git

RUN cd /usr/src/redmine/plugins;wget https://redmine.ociotec.com/attachments/download/581/scrum-0.23.1.tar.gz; tar zxf scrum-0.23.1.tar.gz

#RUN cd /usr/src/redmine/plugins;git clone https://github.com/cryptogopher/issue_recurring.git

RUN cd /usr/src/redmine/plugins;git clone https://github.com/cat-in-136/redmine_hearts.git

RUN cd /usr/src/redmine/plugins;git clone https://github.com/wellbia/redmine_microsoftteams.git redmine_microsoftteams

RUN cd /usr/src/redmine/plugins;git clone https://github.com/redmica/redmica_ui_extension.git

RUN cd /usr/src/redmine/plugins;git clone https://github.com/onozaty/redmine-view-customize.git view_customize

#RUN cd /usr/src/redmine/plugins;git clone https://github.com/haru/redmine_theme_changer.git

#RUN cd /usr/src/redmine/public/themes/; git clone https://github.com/mrliptontea/PurpleMine2.git

RUN cd /usr/src/redmine/public/themes/; git clone https://github.com/farend/redmine_theme_farend_bleuclair.git bleuclair

#RUN cd /usr/src/redmine/public/themes/; git clone https://github.com/fraoustin/redmine_dark.git

#RUN cd /usr/src/redmine/public/themes/; git clone https://github.com/fraoustin/RTMaterial.git

#RUN cd /usr/src/redmine/public/themes/; git clone https://github.com/jbbarth/redmine_theme_ministere.git

#RUN cd /usr/src/redmine/public/themes/; git clone https://github.com/Intera/redmine_theme_intera.git

#RUN cd /usr/src/redmine/public/themes/; git clone https://github.com/knt419/material.git

#RUN cd /usr/src/redmine/public/themes/; git clone https://github.com/letuankhoipm/qkit-redmine-rezii.git

#RUN cd /usr/src/redmine/public/themes/; git clone https://github.com/makotokw/redmine-theme-gitmike.git

#RUN cd /usr/src/redmine/public/themes/; git clone https://github.com/alexcode-cc/redmine-theme-dwarf-build.git

RUN cd /usr/src/redmine/plugins;git clone https://gitea.federationhq.de/byterazor/redmine-git-remote.git redmine_git_remote

RUN cd /usr/src/redmine/plugins;git clone https://gitea.federationhq.de/byterazor/redmine_glossary.git

RUN cd /usr/src/redmine/plugins;git clone https://github.com/Intera/redmine_startpage.git

#RUN cd /usr/src/redmine/plugins;git clone -b master https://github.com/xmera-circle/redmine_cookie_consent

#RUN cd /usr/src/redmine/plugins;git clone https://github.com/hicknhack-software/redmine_hourglass.git; cd redmine_hourglass; git checkout v1.3.0-beta
