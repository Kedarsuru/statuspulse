#!/bin/bash

set -e

BASE="http://localhost:8000"

echo "======================"
echo "STATUSPULSE TEST RUN"
echo "======================"

# ---------------- HEALTH ----------------
echo "[TEST] /health"
RESP=$(curl -s -o /dev/null -w "%{http_code}" $BASE/health)
[ "$RESP" -eq 200 ] || exit 1
echo "PASS"

# ---------------- CREATE SERVICE ----------------
echo "[TEST] POST /services"
RESP=$(curl -s -o /dev/null -w "%{http_code}" \
  -X POST $BASE/services \
  -H "Content-Type: application/json" \
  -d '{"name":"svc1","url":"http://example.com"}')

[ "$RESP" -eq 200 ] || exit 1
echo "PASS"

# ---------------- GET SERVICES ----------------
echo "[TEST] GET /services"
RESP=$(curl -s -o /dev/null -w "%{http_code}" $BASE/services)
[ "$RESP" -eq 200 ] || exit 1
echo "PASS"

# ---------------- CREATE INCIDENT ----------------
echo "[TEST] POST /incidents"
RESP=$(curl -s -o /dev/null -w "%{http_code}" \
  -X POST $BASE/incidents \
  -H "Content-Type: application/json" \
  -d '{"service_name":"svc1","title":"issue"}')

[ "$RESP" -eq 200 ] || exit 1
echo "PASS"

# ---------------- GET INCIDENTS ----------------
echo "[TEST] GET /incidents"
RESP=$(curl -s -o /dev/null -w "%{http_code}" $BASE/incidents)
[ "$RESP" -eq 200 ] || exit 1
echo "PASS"

echo "======================"
echo "ALL TESTS PASSED"
echo "======================"
