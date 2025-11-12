# 기본 이미지 설정 - 우분투 최신 버전기반 이미지 만듦
FROM ubuntu:latest 

# 필수 패키지 설치 - apt 패키지 목록 업데이트, git(소스코드 다운로드), wget(파일 다운로드), build-essential(컴파일 도구 모음) 설치

RUN apt-get update && \
    apt-get install -y \
    git \
    wget \
    build-essential && \
    apt-get clean && \
    # 설치 후 불필요한 파일 정리하여 이미지 용량 축소
    rm -rf /var/lib/apt/lists/*

# Darknet 소스코드 클론(다운로드) 및 컴파일 
RUN git clone https://github.com/pjreddie/darknet && \
    cd darknet && \
    make

# 작업 디렉토리 설정 - Darknet 디렉토리로
WORKDIR /darknet

# YOLOv3 가중치 파일 다운로드 - Darknet에서 사전 학습된 YOLOv3 모델 사용
RUN wget https://data.pjreddie.com/files/yolov3.weights

# 컨테이너 실행 명령어(ENTRYPOINT) 설정
ENTRYPOINT ["/bin/bash", "-c", "wget -O input.jpg $1 && ./darknet detector test cfg/coco.data cfg/yolov3.cfg yolov3.weights input.jpg", "_"]
# 'docker run [이미지] [URL]' 형태로 실행 시 -> [URL]을 $1 인자로 받아 'input.jpg'로 다운로드 -> 다운로드한 이미지를 대상으로 'darknet detector'를 실행
# ./darknet detector test [데이터셋 설정 파일] [모델 설정 파일] [가중치 파일] [입력 이미지 파일]
