FROM debian:bullseye

# Update System and Install Tools
RUN apt-get update
RUN apt-get install -y nodejs npm

ADD ./tools/TetrisAi .

ADD ./tools/index.html .
ADD ./tools/*.js .

CMD node site.js