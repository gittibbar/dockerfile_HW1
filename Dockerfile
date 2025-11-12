FROM ubuntu:latest
RUN apt-get update && \
    apt-get install -y \
    git \
    wget \
    build-essential && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
RUN git clone https://github.com/pjreddie/darknet && \
    cd darknet && \
    make
WORKDIR /darknet
RUN wget https://data.pjreddie.com/files/yolov3.weights
ENTRYPOINT ["/bin/bash", "-c", "wget -O input.jpg $1 && ./darknet detector test cfg/coco.data cfg/yolov3.cfg yolov3.weights input.jpg", "_"]
# ./darknet detector test [데이터셋 설정 파일] [모델 설정 파일] [가중치 파일] [입력 이미지 파일]
