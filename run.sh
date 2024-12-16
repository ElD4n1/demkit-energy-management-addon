#!/bin/sh

CONFIG_PATH=/data/options.json

DEMKIT_FOLDER="$(bashio::config 'demkit_folder' '/data/model/offgridhouse_real')"
DEMKIT_MODEL="$(bashio::config 'demkit_model' 'realhouse_simulated')"

DEMKIT_INFLUXURL="$(bashio::config 'demkit_influxurl' 'http//influx')"
DEMKIT_INFLUXPORT="$(bashio::config 'demkit_influxport' '8068')"
DEMKIT_INFLUXDB="$(bashio::config 'demkit_influxdb' 'dem')"
DEMKIT_INFLUXUSER="$(bashio::config 'demkit_influxuser' 'demkit')"
DEMKIT_INFLUXPW="$(bashio::config 'demkit_influxpw' 'd1a2n3i4e5l6')"

/app/demkit/scripts/autoexec.sh