#!/bin/bash

set -e

BASE="http://localhost:8000"

pass() { echo "✅ $1"; }
fail() { echo "❌ $1"; exit 1; }

echo "======================"
echo "STATUSPULSE TEST RUN"
echo "======================"

# ---------------- HEALTH ----------------
echo "[TEST] /health"
RES=$(curl -s $BASE/health)
echo "$RES" | grep "status" || fail "Invalid JSON response"
echo "$RES" | grep "healthy" || fail "Health not healthy"
pass "Health check"

# ---------------- CREATE SERVICE ----------------
echo "[TEST] POST /services"
RES=$(curl -s -X POST $BASE/services \
  -H "Content-Type: application/json" \
  -d '{"name":"svc1","url":"http://example.com"}')

echo "$RES" | grep "id" || fail "Service creation failed"
pass "Create service"

# ---------------- DUPLICATE SERVICE ----------------
echo "[TEST] Duplicate service (expect 409)"
CODE=$(curl -s -o /dev/null -w "%{http_code}" \
  -X POST $BASE/services \
  -H "Content-Type: application/json" \
  -d '{"name":"svc1","url":"http://example.com"}')

[ "$CODE" -eq 409 ] || fail "Duplicate check failed"
pass "Duplicate service handled"

# ---------------- GET SERVICES ----------------
echo "[TEST] GET /services"
RES=$(curl -s $BASE/services)
echo "$RES" | grep "svc1" || fail "Service not found"
pass "List services"

# ---------------- CREATE INCIDENT ----------------
echo "[TEST] POST /incidents"
RES=$(curl -s -X POST $BASE/incidents \
  -H "Content-Type: application/json" \
  -d '{"service_name":"svc1","title":"issue"}')

echo "$RES" | grep "id" || fail "Incident creation failed"
pass "Create incident"

# ---------------- GET INCIDENTS ----------------
echo "[TEST] GET /incidents"
RES=$(curl -s $BASE/incidents)
echo "$RES" | grep "svc1" || fail "Incident not found"
pass "List incidents"

echo "======================"
echo "🎉 ALL TESTS PASSED"
echo "======================"
