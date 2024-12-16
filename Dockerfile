FROM eldani/image-aarch64-demkit-addon:v1.0.0-beta15
LABEL authors="daniel"

ADD run.sh /app/demkit/scripts/run.sh

WORKDIR /app/demkit

CMD ["./scripts/run.sh"]