# Customized Owasp ZAP Dockerfile with support for authentication

FROM owasp/zap2docker-weekly
MAINTAINER Dick Snel <dick.snel@ictu.nl>

USER root

# Required for running headless webdriver
RUN apt-get install xvfb

RUN cd /opt && \
	wget https://github.com/mozilla/geckodriver/releases/download/v0.11.1/geckodriver-v0.11.1-linux64.tar.gz && \
	tar -xvzf geckodriver-v0.11.1-linux64.tar.gz && \
	chmod +x geckodriver && \
	ln -s /opt/geckodriver /usr/bin/geckodriver && \
	export PATH=$PATH:/usr/bin/geckodriver

RUN apt-get -y remove firefox
RUN cd /opt && \
	wget http://ftp.mozilla.org/pub/firefox/releases/46.0/linux-x86_64/en-US/firefox-46.0.tar.bz2 && \
	bunzip2 firefox-46.0.tar.bz2 && \
	tar xvf firefox-46.0.tar && \
	ln -s /opt/firefox/firefox /usr/bin/firefox
	
#RUN apt-get install firefox

RUN pip install --upgrade pip
RUN pip install selenium==2.53
RUN pip install pyvirtualdisplay

COPY zap-baseline-custom.py /zap/

RUN chown zap:zap /zap/zap-baseline-custom.py && \ 
	chmod +x /zap/zap-baseline-custom.py

USER root
#USER zap