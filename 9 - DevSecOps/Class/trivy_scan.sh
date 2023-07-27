#!/bin/bash

TRIVY_REPORT=result_trivy.json

ALLOW=2
NUM_CRITICAL=$(grep CRITICAL $TRIVY_REPORT | wc -l)
NUM_HIGH=$(grep HIGH $TRIVY_REPORT | wc -l)

echo "$NUM_CRITICAL | $NUM_HIGH"

if [ $NUM_CRITICAL -ge $ALLOW ]; then
  echo "Deny to production"
  echo "Total Critical Vulnerabilities: $NUM_CRITICAL"
  echo "Total High Critical Vulnerabilities: $NUM_HIGH"
  exit 1
else
  echo "Allow to production"
fi