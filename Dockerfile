FROM eldani/image-aarch64-demkit-addon:latest
LABEL authors="daniel"

ADD run.sh /app/demkit/scripts/run.sh
RUN chmod +x /app/demkit/scripts/run.sh

WORKDIR /app/demkit

CMD ["./scripts/run.sh"]